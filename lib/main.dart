import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fx_analysis/form/login.dart';
import 'package:fx_analysis/form/register.dart';
import 'package:fx_analysis/pages/compound_interest.dart';
import 'package:fx_analysis/pages/dashboard.dart';
import 'package:fx_analysis/pages/my_accounts.dart';
import 'package:fx_analysis/services/account_service.dart';
import 'package:fx_analysis/sidebar_button.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDgh_5hkrsqEJn3C6IHM17IknoGkMmmxTc",
      authDomain: "fxtm-68226.firebaseapp.com",
      projectId: "fxtm-68226",
      storageBucket: "fxtm-68226.firebasestorage.app",
      messagingSenderId: "628437121585",
      appId: "1:628437121585:web:ca5820cfdfe61875493310",
      measurementId: "G-75WKH6L7DW",
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'FX Analysis',
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  String userID = '';
  String _selectedLabel = 'Dashboard';
  AccountsService accountsService = AccountsService();
  User? _user;

  @override
  void initState() {
    super.initState();

    // Listen to authentication state changes
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        _user = user;
        userID = user?.uid ?? ''; // Update userID
      });
    });
  }

  void _onItemSelected(String label) {
    setState(() {
      _selectedLabel = label;
    });
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const LoginForm(); // Using LoginForm from login.dart
      },
    );
  }

  void _showRegisterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const RegisterForm(); // Using RegisterForm from register.dart
      },
    );
  }

  // Sign out logic
  void _signOut() async {
    await FirebaseAuth.instance.signOut();
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
          // "My Accounts" - Show login if user is not logged in
          SidebarButton(
            label: 'My accounts',
            isSelected: _selectedLabel == 'My accounts',
            onTap: () {
              if (_user == null) {
                _showLoginDialog();
              } else {
                _onItemSelected('My accounts');
              }
            },
          ),
          SidebarButton(
            label: 'Calculators',
            isSelected: _selectedLabel == 'Calculators',
            onTap: () => _onItemSelected('Calculators'),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // If user is logged in, show Sign Out button
                if (_user != null) ...[
                  TextButton(
                    onPressed: _signOut,
                    child: const Text('Sign Out',
                        style: TextStyle(color: Colors.white)),
                  ),
                ] else ...[
                  // If user is not logged in, show Log In and Sign Up buttons
                  TextButton(
                    onPressed: _showLoginDialog,
                    child: const Text('Log In',
                        style: TextStyle(color: Colors.white)),
                  ),
                  TextButton(
                    onPressed: _showRegisterDialog,
                    child: const Text('Sign Up',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getWidget(String selectedLabel) {
    switch (selectedLabel) {
      case 'Dashboard':
        return Dashboard(userDocument: userID);
      case 'My accounts':
        return MyAccounts(
            userDocument: userID, accountsService: accountsService);
      case 'Calculators':
        return CompoundInterestCalculator();
      default:
        return Dashboard(userDocument: userID);
    }
  }
}
