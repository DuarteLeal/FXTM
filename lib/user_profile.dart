import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:fx_analysis/models/user.dart';
import 'dart:developer' as dev;
import 'package:fx_analysis/services/ctrader_connection.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key, required this.user});

  final User user;

  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<UserProfile> {
  String _selectedLabel = 'Dashboard';
  CTraderConnection ctraderConnection = CTraderConnection();
  String accessToken = '';
  int currentIndex = 0;
  List<dynamic> accounts = [];
  bool accountsLoaded = false; // Track if accounts are loadedbool accountsLoaded = false; // Track if accounts are loaded
  List<dynamic> deals = []; // Store fetched deals
  bool dealsLoaded = false; // Track if deals are loaded

  void _onItemSelected(String label) {
    setState(() {
      _selectedLabel = label;
      // Fetch accounts only when "My accounts" is selected and if not already loaded
      if (_selectedLabel == 'My accounts' && !accountsLoaded) {
        fetchTradingAccounts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            // Sidebar Menu
            Container(
              color: Colors.black87,
              width: 250,
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'LOGO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Main menu',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  DrawInfoCards(
                    label: 'Dashboard',
                    isSelected: _selectedLabel == 'Dashboard',
                    onTap: () => _onItemSelected('Dashboard'),
                  ),
                  DrawInfoCards(
                    label: 'My accounts',
                    isSelected: _selectedLabel == 'My accounts',
                    onTap: () => _onItemSelected('My accounts'),
                  ),
                  DrawInfoCards(
                    label: 'Performance',
                    isSelected: _selectedLabel == 'Performance',
                    onTap: () => _onItemSelected('Performance'),
                  ),
                  DrawInfoCards(
                    label: 'Reports',
                    isSelected: _selectedLabel == 'Reports',
                    onTap: () => _onItemSelected('Reports'),
                  ),
                  DrawInfoCards(
                    label: 'Market data',
                    isSelected: _selectedLabel == 'Market data',
                    onTap: () => _onItemSelected('Market data'),
                  ),
                  DrawInfoCards(
                    label: 'Notifications',
                    isSelected: _selectedLabel == 'Notifications',
                    onTap: () => _onItemSelected('Notifications'),
                  ),
                  const Spacer(),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Preferences',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  DrawInfoCards(
                    label: 'Settings',
                    isSelected: _selectedLabel == 'Settings',
                    onTap: () => _onItemSelected('Settings'),
                  ),
                  DrawInfoCards(
                    label: 'Help Center',
                    isSelected: _selectedLabel == 'Help Center',
                    onTap: () => _onItemSelected('Help Center'),
                  ),
                  DrawInfoCards(
                    label: 'Log out',
                    isSelected: _selectedLabel == 'Log out',
                    onTap: () => _onItemSelected('Log out'),
                  ),
                ],
              ),
            ),
            // Main Content Area
            Expanded(
              child: Column(
                children: [
                  const Row(
                    children: [], //Colocar link para perfil
                  ),
                  SingleChildScrollView(
                    child: getWidget(_selectedLabel),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getWidget(String selectedLabel) {
    switch (selectedLabel) {
      case 'Dashboard':
        return buildDashboard();
      case 'My accounts':
        return buildMyAccountsWidget();
      case 'Performance':
        return const Text('Performance');
      case 'Reports':
        return const Text('Reports');
      case 'Market data':
        return const Text('Market data');
      case 'Notifications':
        return const Text('Notifications');
      case 'Settings':
        return const Text('Settings');
      case 'Help Center':
        return const Text('Help Center');
      default:
        return const Text('Dashboard');
    }
  }

  // Start Dashboard
  Widget buildDashboard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First Row of Cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildInfoCard('Total accounts', '5'),
              buildInfoCard('Total Balance', '\$150k'),
              buildInfoCard('Liquid', '\$75,000'),
              buildInfoCard('Unrealised gain', '-50%', textColor: Colors.yellow),
              buildInfoCard('Monthly return', '8.5%', textColor: Colors.green),
            ],
          ),
          const SizedBox(height: 20),
          // Second Row of Cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildInfoCard('Total deposit', '\$100k'),
              buildInfoCard('Total profit', '\$50,000'),
              buildInfoCard('Performance fee', '25%'),
              buildInfoCard('Manager\'s profit', '\$12,500'),
              buildInfoCard('Total withdrawal', '\$5,000'),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildInfoCard(String title, String value, {Color textColor = Colors.white}) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  // End Dashboard

  // Start My Accounts
  Widget buildMyAccountsWidget() {
    if (accounts.isEmpty) {
      return const Center(child: CircularProgressIndicator()); // Show loading indicator
    }

    var account = accounts[currentIndex];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            width: 300,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_left, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          currentIndex = (currentIndex > 0) ? currentIndex - 1 : accounts.length - 1;
                        });
                      },
                    ),
                    Text(
                      'Account ${account['accountNumber']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_right, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          currentIndex = (currentIndex + 1) % accounts.length;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                buildInvestorInfo('Account ID:', account['accountId'].toString()),
                buildInvestorInfo('Account Number:', account['accountNumber'].toString()),
                buildInvestorInfo('Live:', account['live'] ? 'Yes' : 'No'),
                buildInvestorInfo('Broker Name:', account['brokerName']),
                buildInvestorInfo('Broker Title:', account['brokerTitle']),
                buildInvestorInfo('Deposit Currency:', account['depositCurrency']),
                buildInvestorInfo('Leverage:', account['leverage'].toString()),
                buildInvestorInfo('Balance:', (account['balance']/100).toString()),
                buildInvestorInfo('Account Status:', account['accountStatus']),
                buildInvestorInfo('Swap Free:', account['swapFree'] ? 'Yes' : 'No'),
                ElevatedButton(onPressed: (){
                  fetchDealsList(account['accountId']);
                }, child: Text("get trading deals"))
              ],
            ),
          ),
          SizedBox(
            width: 600,
            child: buildDealsList()
          )
        ],
      ),
    );
  }

  Widget buildInvestorInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Future<void> fetchTradingAccounts() async {
    try {
      accessToken = await ctraderConnection.refreshAccessToken() ?? '';
      final fetchedAccounts = await ctraderConnection.getTradingAccounts(accessToken);
      
      setState(() {
        if (fetchedAccounts is Map<String, dynamic> && fetchedAccounts.containsKey('data')) {
          accounts = fetchedAccounts['data'] as List<dynamic>;
          accountsLoaded = true; // Set to true after accounts are loaded
        } else {
          accounts = [];
        }
      });
    } catch (e) {
      dev.log('Error fetching trading accounts: $e');
      setState(() {
        accounts = [];
      });
    }
  }

  Future<void> fetchDealsList(int accountId) async {
    try {
      deals = await ctraderConnection.getTradingDeals(Int64(accountId)) ?? [];
      setState(() {
        dealsLoaded = true;
      });
    } catch (e) {
      dev.log('Error fetching deals: $e');
      setState(() {
        deals = [];
        dealsLoaded = true;
      });
    }
  }

  Widget buildDealsList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: deals.length,
      itemBuilder: (context, index) {
        var deal = deals[index];
        return ListTile(
          title: Text('Deal ID: ${deal['dealId']}'),
          subtitle: Text('Volume: ${deal['volume']} | Price: ${deal['price']}'),
        );
      },
    );
  }

  // End My Accounts
}

class DrawInfoCards extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const DrawInfoCards({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        color: isSelected ? Colors.grey[800] : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
