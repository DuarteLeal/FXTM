// ignore_for_file: unused_element

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fx_analysis/widgets/current_trading_account/info.dart';
import 'package:fx_analysis/widgets/current_trading_account/chart.dart';
import 'package:fx_analysis/models/user.dart';
import 'package:fx_analysis/models/trading_account.dart';

class UserProfile extends StatefulWidget {
  final User user;

  const UserProfile({super.key, required this.user});

  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  List<TradingAccount> userAccounts = [];
  int currentIndex = 0;
  String filter = 'Growth'; // Filter for charts

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    String jsonString = await rootBundle.loadString('lib/json/accounts.json');
    List<dynamic> jsonData = jsonDecode(jsonString);

    List<TradingAccount> allAccounts = jsonData.map((accountJson) {
      return TradingAccount.fromJson(accountJson);
    }).toList();

    setState(() {
      userAccounts = allAccounts
          .where((account) => account.userId == widget.user.id)
          .toList();
      if (userAccounts.isEmpty) {
        currentIndex = -1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.grey[200],
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text('Welcome, ${widget.user.username}'),
      centerTitle: true,
    );
  }

  Widget _buildBody() {
  if (userAccounts.isEmpty || currentIndex == -1) {
    return const Center(
      child: Text("No accounts available"),
    );
  }

  TradingAccount currentAccount = userAccounts[currentIndex];

  return Row(
    children: [
      // Account Selector and SideBar wrapped in Expanded to maintain equal height
      Expanded(
        child: Column(
          children: [
            SizedBox(
              height: 200, // Limite manual de altura
              width: double.infinity, // Ensure it stretches across
              child: _buildAccountSelector(currentAccount),
            ),
          ],
        ),
      ),
      // ScrollView adjusted to fit the available width
      Flexible(
        flex: 3, // Adjusts to 3x of other flex areas
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity, // Make it fit to available width
                child: _buildChartSelector(currentAccount),
              ),
              SizedBox(
                width: double.infinity, // Make it fit to available width
                child: _buildTradingStats(currentAccount),
              ),
            ],
          ),
        ),
      ),
      // Sidebar has fixed width but will match the height of other elements
      SizedBox(
        width: 200,
        child: _buildSideBar(currentAccount),
      )
    ],
  );
}

  Widget _buildAccountSelector(TradingAccount currentAccount) {
    return Column(
      children: [
        _buildNavigationRow(currentAccount),
        Expanded(
          child: CurrentAccountDetails(account: currentAccount),
        ),
      ],
    );
  }

  Widget _buildNavigationRow(TradingAccount currentAccount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: currentIndex > 0
              ? () {
                  setState(() {
                    currentIndex--;
                  });
                }
              : null,
        ),
        Text(
          currentAccount.accountName,
          style: const TextStyle(fontSize: 18),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: currentIndex < userAccounts.length - 1
              ? () {
                  setState(() {
                    currentIndex++;
                  });
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildChartSelector(TradingAccount currentAccount) {
    return Column(
      children: [
        SizedBox(
          height: 400,
          width: double.infinity,
          child: CurrentAccountCharts(account: currentAccount, filter: filter),
        ),
      ],
    );
  }

  Widget _buildTradingStats(TradingAccount currentAccount) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: SizedBox(
          height: 400,
          width: double.infinity,
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FixedColumnWidth(300), // ajustado para evitar overflow
              2: FlexColumnWidth(2),
              3: FixedColumnWidth(300), // ajustado para evitar overflow
              4: FlexColumnWidth(2),
              5: FixedColumnWidth(320), // ajustado para evitar overflow
            },
            children: [
              _buildTableRow('Trades:', '${currentAccount.trades.length}', 'Longs Won:', 'valor', 'Profit Factor:', 'valor'),
              _buildTableRow('Profitability:', 'valor', 'Shorts Won:', 'valor', 'Standard Deviation:', 'valor'),
              _buildTableRow('Pips:', 'valor', 'Best Trade (ZAR):', 'valor', 'Sharpe Ratio:', 'valor'),
              _buildTableRow('Average Win:', 'valor', 'Worst Trade (ZAR):', 'valor', 'Z-Score (Probability):', 'valor'),
              _buildTableRow('Average Loss:', 'valor', 'Best Trade (Pips):', 'valor', 'Expectancy:', 'valor'),
              _buildTableRow('Lots:', 'valor', 'Worst Trade (Pips):', 'valor', 'AHPR:', 'valor'),
              _buildTableRow('Commissions:', 'valor', 'Avg. Trade Length:', 'valor', 'GHPR:', 'valor'),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label1, String value1, String label2, String value2, String label3, String value3) {
    return TableRow(
      children: [
        Column(
          children: [
            Row(
              children: [
                Text(label1, style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                Text(value1),
                const SizedBox(width: 10)
              ],
            ),
            const Divider(),
          ],
        ),
        Column(
          children: [
            Row(
              children: [
                Text(label2, style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                Text(value2),
                const SizedBox(width: 10)
              ],
            ),
            const Divider(),
          ],
        ),
        Column(
          children: [
            Row(
              children: [
                Text(label3, style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                Text(value3),
                const SizedBox(width: 10)
              ],
            ),
            const Divider(),
          ],
        ),
      ]
    );
  }

  Widget _buildSideBar(TradingAccount currentAccount) {
  return Container(
    width: 200, // Width of the sidebar
    color: const Color.fromARGB(255, 14, 147, 255), // Background color of the sidebar
    child: Column(
      children: [
        _buildSideBarButton(Icons.account_balance, 'Account Info', () {}),
        _buildSideBarButton(Icons.show_chart, 'Chart Overview', () {}),
        _buildSideBarButton(Icons.trending_up, 'Performance Stats', () {}),
        _buildSideBarButton(Icons.settings, 'Settings', () {}),
        _buildSideBarButton(Icons.logout, 'Log Out', () {}),
      ],
    ),
  );
}

Widget _buildSideBarButton(IconData icon, String label, VoidCallback onPressed) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
    child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 14, 147, 255), // Button color
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        minimumSize: const Size(double.infinity, 50), // Button fills sidebar width
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      label: Text(
        label,
        style: const TextStyle(fontSize: 16),
      ),
    ),
  );
}

}
