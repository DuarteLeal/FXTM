import 'package:flutter/material.dart';
import 'package:fx_analysis/services/account_service.dart';

class MyAccounts extends StatefulWidget {
  final String userDocument;
  final AccountsService accountsService;

  const MyAccounts({
    super.key,
    required this.userDocument,
    required this.accountsService,
  });

  @override
  State<MyAccounts> createState() => _MyAccountsState();
}

class _MyAccountsState extends State<MyAccounts> {
  List<dynamic>? accounts;

  @override
  void initState() {
    super.initState();
    _fetchAccounts();
  }

  Future<void> _fetchAccounts() async {
    var fetchedAccounts = await widget.accountsService.fetchTradingAccounts();
    if (fetchedAccounts != null && fetchedAccounts['data'] != null) {
      setState(() {
        accounts = fetchedAccounts['data'];
      });
    } else {
    }
  }

  Future<void> _addAccount() async {
    await widget.accountsService.addAccounts();
    _fetchAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: _addAccount,
                  child: const Text("Add Account"),
                ),
                Spacer()
              ],
            ),
            accounts == null
                ? const SizedBox.shrink()
                : ListView.builder(
                    shrinkWrap: true, // Prevent ListView from occupying infinite height
                    physics: NeverScrollableScrollPhysics(), // Disable scrolling within the ListView
                    itemCount: accounts!.length,
                    itemBuilder: (context, index) {
                      var account = accounts![index];
                      return SizedBox(
                        height: 300,
                        width: 300,
                        child: Column(
                          children: [
                            Text("Account Number: ${account['accountNumber']}"),
                            Text("Live: ${account['live']}"),
                            Text("Broker: ${account['brokerTitle']}"),
                            Text("Currency: ${account['depositCurrency']}"),
                            Text("Type: ${account['traderAccountType']}"),
                            Text("Leverage: ${account['leverage']}"),
                            Text("Balance: ${account['balance']}"),
                          ],
                        ),
                      );
                    },
                  ),
          ],
        ),
    );
  }
}
