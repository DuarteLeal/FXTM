import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;
import 'package:url_launcher/url_launcher.dart';

class AccountsService {
  final user = FirebaseAuth.instance.currentUser;

  Future<String?> getAuthToken() async {
    if (user != null) {
      final idToken = await user!.getIdToken();
      return idToken;
    }
    return null;
  }

  Future<void> addAccounts() async {
    try {
      // Obtain Firebase authentication token
      final token = await getAuthToken();
      if (token == null) {
        dev.log("User is not authenticated");
        return;
      }
      dev.log("Firebase Authenticated user token: $token");

      // HTTP request with Bearer token in header
      final response = await http.post(
          Uri.parse("https://us-central1-fxtm-68226.cloudfunctions.net/startAuth"),
          headers: {
            'Authorization': 'Bearer $token',
          },
      );

      // Check if the response was successful
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final authUrl = data['url'];
        dev.log("Authorization URL: $authUrl");

        // Launch the URL in the browser
        if (!await launchUrl(Uri.parse(authUrl))) {
          throw "Could not launch URL";
        }
      } else {
        dev.log("Failed to start authorization: ${response.body}");
      }
    } catch (e) {
      dev.log("Failed to start authorization: $e");
    }
  }

  Future<String?> getAccessToken() async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(user!.uid);
    final doc = await docRef.get();
    return doc.data()!['access_token'] as String;
  }

  Future<Map<String, dynamic>?> fetchTradingAccounts() async {
    String? token = await getAccessToken();

    if (token != null) {
        const url = 'https://us-central1-fxtm-68226.cloudfunctions.net/fetchTradingAccounts';
        try {
            final response = await http.get(
                Uri.parse(url),
                headers: {
                    'Authorization': 'Bearer $token',
                }
            );

            if (response.statusCode == 200) {
                var jsonData = json.decode(response.body);
                dev.log("Trading Accounts Data: $jsonData");
                return jsonData;
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

  Future<Map<String, dynamic>?> getDealList({
    required int ctidTraderAccountId,
    required bool isLive,
  }) async {
    try {
      // Verificar se o usuário está autenticado
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Verificar se o token está válido
      final token = await user!.getIdToken();
      if (token == null) {
        throw Exception('Unable to get authentication token');
      }

      final callable = FirebaseFunctions.instance.httpsCallable('getDealList');
      dev.log('Calling getDealList with account: $ctidTraderAccountId, isLive: $isLive');
      
      final response = await callable.call({
        "ctidTraderAccountId": ctidTraderAccountId,
        "isLive": isLive,
        "fromTimestamp": 1700000000000, 
        "toTimestamp": 1730000000000, 
      });

      dev.log('getDealList response: ${response.data}');
      return response.data as Map<String, dynamic>?;
    } catch (e) {
      dev.log('Error in getDealList: $e');
      rethrow;
    }
  }
}
