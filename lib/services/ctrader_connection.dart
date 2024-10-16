import 'dart:convert';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;

class CTraderConnection {
  String? accessToken;
  String? refreshToken = "rFEG4A1dTXA4cZmoPS-wy6bhH2NJQaLClJRGR7zFcOU";
  DateTime accessTokenExpiration = DateTime.now();
  final String clientId = "12024_bxiGH3cXhx2XMCYvwr4DOlIet2RypA1pPkhZMr1FYXxFnsjuZC";
  final String clientSecret = "nScgvXBTiQcLozMDb1KO1rpqexpCtHOzr5oPVvncyFTsrq05WT";
  final String tokenUrl = "https://connect.spotware.com/apps/token";

  void saveTokens(String newAccessToken,String newRefreshToken, DateTime expiration) {
    accessToken = newAccessToken;
    refreshToken = newRefreshToken;
    accessTokenExpiration = expiration;
    dev.log("Tokens saved: Access Token - $accessToken, Refresh Token - $refreshToken");
  }

  bool isAccessTokenExpired() {
    return DateTime.now().isAfter(accessTokenExpiration);
  }

  Future<void> refreshAccessToken() async {
    if (refreshToken == null) {
      throw Exception("No refresh token available.");
    }

    final response = await http.post(
      Uri.parse(tokenUrl),
      body: {
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken!,
        'client_id': clientId,
        'client_secret': clientSecret,
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      accessToken = data['access_token'];
      refreshToken = data['refresh_token']; // Atualize sempre o refreshToken
      int expiresIn = data['expires_in'];
      accessTokenExpiration = DateTime.now().add(Duration(seconds: expiresIn));

      saveTokens(accessToken!, refreshToken!, accessTokenExpiration);
      dev.log("Access token refreshed successfully.");
    } else {
      dev.log("Failed to refresh access token: ${response.statusCode}");
    }
  }



  Future<String?> getAccessToken() async {
    if (accessToken == null || isAccessTokenExpired()) {
      await refreshAccessToken();
    }

    return accessToken;
  }

  Future<Map<String, dynamic>?> fetchTradingAccounts() async {
    String? token = await getAccessToken();

    if (token != null) {
      final url = 'https://api.spotware.com/connect/tradingaccounts?access_token=$token';
      try {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          var jsonData = json.decode(response.body);  // Parse response as JSON
          dev.log("Trading Accounts Data: $jsonData");
          return jsonData; // Return JSON data
        } else {
          dev.log("Error fetching trading accounts: ${response.statusCode}");
          return null;
        }
      } catch (e) {
        dev.log("Exception: $e");
        return null;
      }
    } else {
      dev.log("Unable to fetch trading accounts. Access token is missing.");
      return null;
    }
  }
}
