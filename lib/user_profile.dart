import 'package:flutter/material.dart';
import 'package:fx_analysis/models/user.dart';
import 'package:fx_analysis/services/ctrader_connection.dart';
import 'dart:developer' as dev;

class UserProfile extends StatefulWidget {
  const UserProfile({super.key, required this.user});
  
  final User user;

  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  
  CTraderConnection ctraderConnection = CTraderConnection();
  String accessToken = '';
  String tradingAccountData = '';

  Future<void> fetchTradingAccounts() async {
    try {
      await ctraderConnection.fetchTradingAccounts();
      String? token = await ctraderConnection.getAccessToken();

      setState(() {
        accessToken = token ?? 'No token available';
        tradingAccountData = 'Trading accounts data fetched! Check logs for details.';
      });
    } catch (e) {
      dev.log('Error: $e');
      setState(() {
        tradingAccountData = 'Failed to fetch trading accounts.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: fetchTradingAccounts,
              child: const Text('Fetch Trading Accounts'),
            ),
            if (accessToken.isNotEmpty) Text('Access Token: $accessToken'),
            if (tradingAccountData.isNotEmpty) Text(tradingAccountData),
          ],
        ),
      ),
    );
  }
}
