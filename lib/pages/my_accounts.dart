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
      // Handle errors or empty data
    }
  }

  Future<void> _addAccount() async {
    await widget.accountsService.addAccounts();
    _fetchAccounts();
  }

  Widget accountCard(dynamic account) {
    return SizedBox(
      width: 350, // Fixed width for the card
      height: 350, // Fixed height for the card
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: const Color(0xFF121B33), // Background color of the card
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Account Number: ${account['accountNumber']}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    account['brokerTitle'], // Broker title
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Balance',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${account['balance']}\$',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        'Leverage',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${account['leverage']}x',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Type',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${account['traderAccountType']}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Currency',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${account['depositCurrency']}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Open',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Add Account Button
          Row(
            children: [
              ElevatedButton(
                onPressed: _addAccount,
                child: const Text("Add Account"),
              ),
              const Spacer(),
            ],
          ),
          SizedBox(
              height: 16), // Space between the button and the account cards
          // Dynamically generated account cards
          Wrap(
            spacing: 16.0, // Horizontal spacing between cards
            runSpacing: 16.0, // Vertical spacing between rows
            children: [
              if (accounts != null)
                ...List.generate(
                  accounts!.length,
                  (index) => accountCard(accounts![index]),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
