import 'package:flutter/material.dart';
import 'package:fx_analysis/pages/compound_interest.dart';
import 'package:fx_analysis/pages/dashboard.dart';
import 'package:fx_analysis/pages/my_accounts.dart';
import 'package:fx_analysis/services/account_service.dart';
import 'package:fx_analysis/sidebar_button.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.userID});

  final String userID;

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  late String userID;
  String accessToken = '';
  int currentIndex = 0;
  List<dynamic> accounts = [];
  bool accountsLoaded = false;
  List<dynamic> deals = [];
  bool dealsLoaded = false;
  String _selectedLabel = 'Dashboard';
  AccountsService accountsService = AccountsService(); // Instance of AccountsService

  @override
  void initState() {
    super.initState();
    userID = widget.userID; // Initialize userID from widget
  }

  void _onItemSelected(String label) {
    setState(() {
      _selectedLabel = label;
      // Load accounts only if 'My accounts' is selected and accounts are not yet loaded
      if (_selectedLabel == 'My accounts' && !accountsLoaded) {
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            _buildSidebar(),
            Expanded(
              child: SingleChildScrollView(
                child: _getWidget(_selectedLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      color: Colors.black87,
      width: 250,
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          SidebarButton(
            label: 'Dashboard',
            isSelected: _selectedLabel == 'Dashboard',
            onTap: () => _onItemSelected('Dashboard'),
          ),
          SidebarButton(
            label: 'My accounts',
            isSelected: _selectedLabel == 'My accounts',
            onTap: () => _onItemSelected('My accounts'),
          ),
          SidebarButton(
            label: 'Performance',
            isSelected: _selectedLabel == 'Performance',
            onTap: () => _onItemSelected('Performance'),
          ),
          SidebarButton(
            label: 'Reports',
            isSelected: _selectedLabel == 'Reports',
            onTap: () => _onItemSelected('Reports'),
          ),
          SidebarButton(
            label: 'Market data',
            isSelected: _selectedLabel == 'Market data',
            onTap: () => _onItemSelected('Market data'),
          ),
          SidebarButton(
            label: 'News',
            isSelected: _selectedLabel == 'News',
            onTap: () => _onItemSelected('News'),
          ),
          SidebarButton(
            label: 'Calculators',
            isSelected: _selectedLabel == 'Calculators',
            onTap: () => _onItemSelected('Calculators'),
          ),
          const Spacer(),
          SidebarButton(
            label: 'Settings',
            isSelected: _selectedLabel == 'Settings',
            onTap: () => _onItemSelected('Settings'),
          ),
          SidebarButton(
            label: 'Help Center',
            isSelected: _selectedLabel == 'Help Center',
            onTap: () => _onItemSelected('Help Center'),
          ),
          SidebarButton(
            label: 'Log out',
            isSelected: _selectedLabel == 'Log out',
            onTap: () => _onItemSelected('Log out'),
          ),
        ],
      ),
    );
  }

  Widget _getWidget(String selectedLabel) {
    switch (selectedLabel) {
      case 'Dashboard':
        return Dashboard(userDocument: userID,);
      case 'My accounts':
        return MyAccounts(userDocument: userID, accountsService: accountsService);
      case 'Performance':
        return const Text('Performance data will be shown here.');
      case 'Reports':
        return const Text('Reports data will be shown here.');
      case 'Market data':
        return const Text('Market data will be shown here.');
      case 'News':
        return const Text('News will be shown here.');
        case 'Calculators':
        return CompoundInterestCalculator();
      case 'Settings':
        return const Text('Settings adjustments will be shown here.');
      case 'Help Center':
        return const Text('Help Center info will be shown here.');
      default:
        return const Text('Select an option from the sidebar.');
    }
  }
}
