/* eslint-disable no-undef */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const fetch = require("node-fetch");
const client_id = "12024_bxiGH3cXhx2XMCYvwr4DOlIet2RypA1pPkhZMr1FYXxFnsjuZC";
const client_secret = "nScgvXBTiQcLozMDb1KO1rpqexpCtHOzr5oPVvncyFTsrq05WT";
const redirect_uri = "https://oauthcallback-quxhzwbyha-uc.a.run.app";
const cors = require('cors')({ origin: true });

admin.initializeApp();

exports.listUsers = functions.https.onRequest(async (req, res) => {
  try {
    const listUsersResult = await admin.auth().listUsers();
    const users = listUsersResult.users.map((userRecord) => ({
      uid: userRecord.uid,
      email: userRecord.email,
    }));

    res.status(200).json(users);
  } catch (error) {
    res.status(500).send(`Error fetching users: ${error.message}`);
  }
});

exports.startAuth = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
    if (!req.headers.authorization || !req.headers.authorization.startsWith('Bearer ')) {
      res.status(401).send('Unauthorized');
      return;
    }

    const token = req.headers.authorization.split('Bearer ')[1];
    let decodedToken;
    try {
      decodedToken = await admin.auth().verifyIdToken(token);
    } catch (error) {
      res.status(403).send('Unauthorized');
      return;
    }

    const uid = decodedToken.uid;
    const authorizationUrl = `https://id.ctrader.com/my/settings/openapi/grantingaccess?client_id=${client_id}&scope=accounts&redirect_uri=${redirect_uri}&state=${uid}`;

    res.status(200).send({ url: authorizationUrl });
  });
});

// Callback para receber o código de autorização e trocar pelo token
exports.oauthCallback = functions.https.onRequest(async (req, res) => {
  const code = req.query.code;
  const uid = req.query.state;

  if (!code || !uid) {
    console.log("Missing code or state:", { code, uid });
    return res.status(400).send("Missing authorization code or user ID.");
  }

  try {
    console.log("Code recebido:", code);
    console.log("State recebido:", uid);

    // Timer para medir o tempo da troca do token
    console.time("Token Exchange Time");
    const tokenResponse = await fetch("https://openapi.ctrader.com/apps/token", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: new URLSearchParams({
        grant_type: "authorization_code",
        code,
        client_id,
        client_secret,
        redirect_uri,
      }),
    });
    console.timeEnd("Token Exchange Time");

    if (!tokenResponse.ok) {
      console.error("Token exchange failed:", await tokenResponse.text());
      return res.status(400).send("Failed to exchange code for tokens.");
    }

    const tokenData = await tokenResponse.json();
    console.log("Token Data recebido:", tokenData);

    // Timer para medir o tempo de gravação no Firestore
    console.time("Firestore Save Time");
    const expiryTime = Date.now() + tokenData.expires_in * 1000;
    await admin.firestore().collection("users").doc(uid).set(
      {
        access_token: tokenData.access_token,
        refresh_token: tokenData.refresh_token,
        token_expiry: expiryTime,
      },
      { merge: true }
    );
    console.timeEnd("Firestore Save Time");

    console.log("Tokens salvos no Firestore para UID:", uid);
    res.status(200).send("Authentication successful. You can close this page.");
  } catch (error) {
    console.error("Erro ao trocar code pelo token:", error);
    res.status(500).send("Failed to exchange code for tokens.");
  }
});

exports.authenticateCTrader = functions.https.onCall(async (data, context) => {
  console.log('Received request with data:', data);

  if (!context.auth) {
    console.log('No authentication context available.');
    throw new functions.https.HttpsError('unauthenticated', 'The function must be called while authenticated. (authenticateCTrader)');
  }

  try {
    const response = await fetch("https://api.ctrader.com/oauth/token", {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: `client_id=${client_id}&client_secret=${client_secret}&grant_type=client_credentials`
    });

    if (!response.ok) {
      console.error('HTTP error', response.statusText);
      throw new Error(`HTTP status ${response.status}`);
    }

    const tokenData = await response.json();
    console.log('Received token data:', tokenData);
    return { cTraderToken: tokenData.access_token };
  } catch (error) {
    console.error('Failed to authenticate with cTrader API:', error);
    throw new functions.https.HttpsError('internal', 'Failed to authenticate with cTrader API', error.toString());
  }
});


// Buscar as contas do usuário
exports.getAccounts = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "The function must be called while authenticated. (getAccounts)"
    );
  }

  const uid = context.auth.uid;

  try {
    const userDoc = await admin.firestore().collection("users").doc(uid).get();
    if (!userDoc.exists) {
      throw new functions.https.HttpsError(
        "not-found",
        "User data not found."
      );
    }

    const userData = userDoc.data();
    let accessToken = userData.access_token;

    // Verificar se o token expirou
    if (Date.now() >= userData.token_expiry) {
      const refreshResponse = await fetch("https://api.ctrader.com/token", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: `refresh_token=${userData.refresh_token}&client_id=${client_id}&client_secret=${client_secret}&grant_type=refresh_token`
      });

      if (!refreshResponse.ok) {
        throw new functions.https.HttpsError(
          "permission-denied",
          "Failed to refresh access token."
        );
      }

      const refreshData = await refreshResponse.json();
      accessToken = refreshData.access_token;

      // Atualizar tokens no Firestore
      await admin.firestore().collection("users").doc(uid).update({
        access_token: refreshData.access_token,
        token_expiry: Date.now() + refreshData.expires_in * 1000,
      });
    }

    // Buscar contas da API do cTrader
    const accountsResponse = await fetch("https://api.ctrader.com/accounts", {
      headers: { "Authorization": `Bearer ${accessToken}` },
    });

    if (!accountsResponse.ok) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Failed to fetch account data."
      );
    }

    const accounts = await accountsResponse.json();
    return { accounts: accounts.accounts };
  } catch (error) {
    console.error("Error fetching accounts", error);
    throw new functions.https.HttpsError(
      "unknown",
      "Failed to fetch accounts data."
    );
  }
});

exports.fetchTradingAccounts = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
      if (!req.headers.authorization || !req.headers.authorization.startsWith('Bearer ')) {
          return res.status(401).send('Unauthorized');
      }

      const token = req.headers.authorization.split('Bearer ')[1];
      const apiUrl = 'https://api.spotware.com/connect/tradingaccounts?access_token=' + token;

      try {
          const apiResponse = await fetch(apiUrl);
          const jsonData = await apiResponse.json();
          if (apiResponse.ok) {
              res.status(200).json(jsonData);
          } else {
              res.status(apiResponse.status).send(jsonData);
          }
      } catch (error) {
          console.error('Error fetching trading accounts:', error);
          res.status(500).send('Error fetching trading accounts');
      }
  });
});

exports.getDealList = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "The function must be called while authenticated. (getDealList)"
    );
  }
  
  const uid = context.auth.uid;
  
  try {
    // Ler tokens do Firestore
    const userDoc = await admin.firestore().collection("users").doc(uid).get();
    if (!userDoc.exists) {
      throw new functions.https.HttpsError("not-found", "User data not found.");
    }
    const userData = userDoc.data();

    // Verifica se o access token expirou; se sim, faz refresh
    let accessToken = userData.access_token;
    if (Date.now() >= userData.token_expiry) {
      const refreshResponse = await fetch("https://api.ctrader.com/token", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: `refresh_token=${userData.refresh_token}&client_id=${client_id}&client_secret=${client_secret}&grant_type=refresh_token`,
      });
      if (!refreshResponse.ok) {
        throw new functions.https.HttpsError(
          "permission-denied",
          "Failed to refresh access token."
        );
      }
      const refreshData = await refreshResponse.json();
      accessToken = refreshData.access_token;
      // Atualiza Firestore
      await admin.firestore().collection("users").doc(uid).update({
        access_token: accessToken,
        token_expiry: Date.now() + refreshData.expires_in * 1000,
      });
    }

    // Montamos o "dealListReq" em JSON
    const dealListReq = {
      payloadType: "PROTO_OA_DEAL_LIST_REQ",
      payload: {
        ctidTraderAccountId: data.ctidTraderAccountId,
        accessToken: accessToken,
        fromTimestamp: data.fromTimestamp,
        toTimestamp: data.toTimestamp,
        direction: "BACKWARD", // ou "FORWARD"
        offset: data.offset ?? 0,
        limit: data.limit ?? 100,
      },
    };

    // Se a conta é live ou demo, escolhe o endpoint certo
    const isLive = data.isLive;
    const proxyEndpoint = isLive
      ? "https://live.ctraderapi.com:5036"
      : "https://demo.ctraderapi.com:5036";
    
    // Envia o POST para o endpoint certo
    const response = await fetch(proxyEndpoint, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(dealListReq),
    });

    if (!response.ok) {
      const errorText = await response.text();
      throw new functions.https.HttpsError(
        "unknown",
        `Erro da cTrader: ${errorText}`
      );
    }

    const jsonRes = await response.json();
    return jsonRes;

  } catch (error) {
    console.error("Erro ao obter deals:", error);
    throw new functions.https.HttpsError("unknown", error.message);
  }
});

/**
 * Exemplo de função onCall que obtém todas as contas do utilizador (via Spotware),
 * verifica se cada conta é live ou demo e para cada uma faz um DealListReq.
 * Devolve tudo num array "results".
 */
exports.getAllDeals = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "Esta função requer autenticação."
    );
  }
  const uid = context.auth.uid;

  try {
    // 1) Ler tokens do Firestore
    const userDoc = await admin.firestore().collection("users").doc(uid).get();
    if (!userDoc.exists) {
      throw new functions.https.HttpsError(
        "not-found",
        "Não encontrei dados do utilizador no Firestore."
      );
    }
    const userData = userDoc.data();
    let accessToken = userData.access_token;
    let tokenExpiry = userData.token_expiry || 0;

    // 2) Se o token expirou, faz refresh
    if (Date.now() >= tokenExpiry) {
      const refreshResponse = await fetch("https://api.ctrader.com/token", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: `refresh_token=${userData.refresh_token}&client_id=${client_id}&client_secret=${client_secret}&grant_type=refresh_token`
      });
      if (!refreshResponse.ok) {
        throw new functions.https.HttpsError(
          "permission-denied",
          "Falha ao fazer refresh do token cTrader."
        );
      }
      const refreshData = await refreshResponse.json();
      accessToken = refreshData.access_token;
      tokenExpiry = Date.now() + refreshData.expires_in * 1000;

      await admin.firestore().collection("users").doc(uid).update({
        access_token: accessToken,
        token_expiry: tokenExpiry
      });
    }

    // 3) Obter as contas pela API do Spotware (que indica live: false/true)
    //    Endpoint:
    //    https://api.spotware.com/connect/tradingaccounts?access_token=...
    const accountsUrl = `https://api.spotware.com/connect/tradingaccounts?access_token=${accessToken}`;
    const accountsResp = await fetch(accountsUrl);
    if (!accountsResp.ok) {
      const errorTxt = await accountsResp.text();
      throw new functions.https.HttpsError(
        "unknown",
        `Erro ao obter lista de contas: ${errorTxt}`
      );
    }
    const accountsData = await accountsResp.json();
    if (!accountsData.data || !Array.isArray(accountsData.data)) {
      throw new Error("Formato inesperado: não existe array data[] nas contas.");
    }

    // 4) Para cada conta, decide se é Demo ou Live => chama endpoint => faz "dealListReq"
    const results = await Promise.all(
      accountsData.data.map(async (acct) => {
        const isLive = acct.live;

        // Montar o payload PROTO_OA_DEAL_LIST_REQ
        const dealListReq = {
          payloadType: "PROTO_OA_DEAL_LIST_REQ",
          payload: {
            ctidTraderAccountId: acct.accountId,
            accessToken: accessToken,
            fromTimestamp: data.fromTimestamp || 0,
            toTimestamp: data.toTimestamp || Date.now(),
            direction: "BACKWARD",
            offset: 0,
            limit: 50
          }
        };

        const endpoint = isLive
          ? "https://live.ctraderapi.com:5036"
          : "https://demo.ctraderapi.com:5036";

        const resp = await fetch(endpoint, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(dealListReq)
        });

        if (!resp.ok) {
          const errorText = await resp.text();
          throw new Error(
            `Erro do cTrader para a conta ${acct.accountId}: ${errorText}`
          );
        }

        const dealListRes = await resp.json();
        return {
          accountId: acct.accountId,
          isLive,
          dealListRes
        };
      })
    );

    // 5) Retornar tudo ao Flutter
    return { results };
  } catch (error) {
    console.error("Erro em getAllDeals:", error);
    throw new functions.https.HttpsError("unknown", error.message);
  }
});
