import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:fixnum/fixnum.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fx_analysis/protos/lib/protos/ctrader.pb.dart';
import 'package:fx_analysis/protos/lib/protos/ctrader.pbserver.dart';

class CTraderConnection {
  static const String clientId = '12024_bxiGH3cXhx2XMCYvwr4DOlIet2RypA1pPkhZMr1FYXxFnsjuZC';
  static const String clientSecret = 'nScgvXBTiQcLozMDb1KO1rpqexpCtHOzr5oPVvncyFTsrq05WT';
  static const String redirectUri = 'https://openapi.ctrader.com/apps/12024/playground';
  static const String tokenUrl = 'https://connect.spotware.com/apps/token';
  static const String accountsUrl = 'https://api.spotware.com/connect/tradingaccounts';
  static const String dealsUrl = 'https://api.spotware.com/connect/deals';
  static const String initialRefreshToken = 'LTrbcyFwi54FBMMp9J1-3H4CMryJd8y9x1yWYdaqrj4';
  String? refreshToken;

  Future<File> get _localFile async {
    const directory = 'C:/Users/donzd/Documents/flutter projects/fx_analysis/lib/assets';
    return File('$directory/refresh_token.txt');
  }

  Future<void> loadRefreshToken() async {
    final file = await _localFile;
    if (await file.exists()) {
      refreshToken = await file.readAsString();
    } else {
      dev.log('Refresh token file not found, creating new one with initial token.');
      refreshToken = initialRefreshToken;
      await saveRefreshToken(refreshToken!);
    }
  }

  Future<void> saveRefreshToken(String token) async {
    final file = await _localFile;
    await file.writeAsString(token);
  }

  Future<String?> refreshAccessToken() async {
    if (refreshToken == null) {
      await loadRefreshToken();
    }
    var response = await http.post(Uri.parse(tokenUrl), body: {
      'grant_type': 'refresh_token',
      'refresh_token': refreshToken,
      'client_id': clientId,
      'client_secret': clientSecret,
      'redirect_uri': redirectUri,
    });

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['access_token'] != null) {
        refreshToken = data['refresh_token'];
        await saveRefreshToken(refreshToken!);
        return data['access_token'];
      } else {
        dev.log('Error: "access_token" not found in the response.');
      }
    } else {
      dev.log('Failed to refresh token: ${response.statusCode}, ${response.body}');
    }
    return null;
  }

  Future<dynamic> getTradingAccounts(String accessToken) async {
    var response = await http.get(Uri.parse('$accountsUrl?access_token=$accessToken'));

    if (response.statusCode == 200) {
      var accounts = jsonDecode(response.body);
      return accounts;
    } else {
      dev.log('Failed to retrieve trading accounts: ${response.statusCode}, ${response.body}');
      return null;
    }
  }

  Future<List<ProtoOADeal>?> getTradingDeals(Int64 accountId) async {
    dev.log('Fetching all trading deals for account ID: $accountId');

    List<ProtoOADeal> allDeals = [];
    bool hasMore = true;
    Int64 currentFromTimestamp = Int64(0); // Start from the beginning
    Int64 currentToTimestamp = Int64(DateTime.now().millisecondsSinceEpoch); // Until now
    int maxRows = 100; // Adjust as needed

    while (hasMore) {
      var request = ProtoOADealListReq(
        ctidTraderAccountId: accountId,
        fromTimestamp: currentFromTimestamp,
        toTimestamp: currentToTimestamp,
        maxRows: maxRows,
      );

      Socket? socket;
      try {
        socket = await Socket.connect('demo.ctraderapi.com', 5035, timeout: Duration(seconds: 60));
        dev.log('Socket connected.');

        socket.add(request.writeToBuffer());
        await socket.flush();
        dev.log('Request sent.');

        List<int> receivedData = [];
        await for (var data in socket) {
          receivedData.addAll(data);
        }

        if (receivedData.isNotEmpty) {
          var response = ProtoOADealListRes.fromBuffer(receivedData);
          dev.log('Deals retrieved: ${response.deal.length}');
          allDeals.addAll(response.deal);

          // Check if there are more records
          hasMore = response.hasMore;

          if (hasMore) {
            // Update currentFromTimestamp to continue from the last deal's timestamp
            currentFromTimestamp = Int64(response.deal.last.timestamp.toInt() + 1);
          }
        } else {
          dev.log('No data received from the server.');
          hasMore = false;
        }
      } catch (e) {
        dev.log('Error fetching trading deals: $e');
        hasMore = false;
      } finally {
        await socket?.close();
        dev.log('Socket closed.');
      }
    }

    return allDeals;
  }

  Future<void> run() async {
    await loadRefreshToken();
    String? accessToken = await refreshAccessToken();

    if (accessToken != null) {
      var accounts = await getTradingAccounts(accessToken);
      if (accounts != null) {
        dev.log('Successfully retrieved trading accounts: $accounts');

        var deals = await getTradingDeals(Int64(5058754));
        if (deals != null) {
          dev.log('Successfully retrieved trading deals: $deals');
        } else {
          dev.log('Could not retrieve trading deals.');
        }
      } else {
        dev.log('Could not retrieve trading accounts.');
      }
    } else {
      dev.log('Failed to get access token.');
    }
  }
}
