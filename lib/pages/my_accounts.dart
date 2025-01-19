import 'package:flutter/material.dart';
import 'package:fx_analysis/services/account_service.dart';
import 'dart:developer' as dev;

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
      // Tratar erro ou ausência de dados
    }
  }

  Future<void> _addAccount() async {
    await widget.accountsService.addAccounts();
    _fetchAccounts();
  }

  // Método para ir buscar os deals daquela conta
  Future<void> _fetchDealsForAccount(Map<String, dynamic> account) async {
    try {
      final ctidTraderAccountId = account['accountId'];
      final isLive = account['live'];

      final dealListResponse = await widget.accountsService.getDealList(
        ctidTraderAccountId: ctidTraderAccountId,
        isLive: isLive,
      );

      dev.log("Deals para a conta ${account['accountNumber']}: $dealListResponse");

    } catch (e) {
      dev.log("Erro ao buscar deals para a conta ${account['accountNumber']}: $e");
    }
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
              const Spacer()
            ],
          ),
          if (accounts != null)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: accounts!.length,
              itemBuilder: (context, index) {
                final account = accounts![index];
                return SizedBox(
                  height: 320,
                  width: 300,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text("Account Number: ${account['accountNumber']}"),
                          Text("Live: ${account['live']}"),
                          Text("Broker: ${account['brokerTitle']}"),
                          Text("Currency: ${account['depositCurrency']}"),
                          Text("Type: ${account['traderAccountType']}"),
                          Text("Leverage: ${account['leverage']}"),
                          Text("Balance: ${account['balance']}"),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => _fetchDealsForAccount(account),
                            child: const Text("Performance"),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
