import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fx_analysis/form/login.dart';
import 'package:fx_analysis/form/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:developer' as dev;

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

  // For Firebase JS SDK v7.20.0 and later, measurementId is optional

  runApp(MyApp());
  testFirebaseAuthConnection();
}

void testFirebaseAuthConnection() async {
  final user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    dev.log("Firebase Auth connection successful. User is authenticated:");
    dev.log("UID: ${user.uid}");
    dev.log("Email: ${user.email}");
  } else {
    dev.log("Main: No user is currently authenticated.");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'FX Account Monitor',
      home: LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  LandingPageState createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int selectedIndex = -1;
    final List<String> buttonLabels = ['Home', 'Pricing', 'About us', 'Contact'];

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 35),
                  const Text(
                    "FX Trading Monitor",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 35),
                  for (int i = 0; i < buttonLabels.length; i++)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectedIndex = i;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          buttonLabels[i],
                          style: TextStyle(
                            color: selectedIndex == i ? Colors.blue : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 50),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const LoginForm(),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Log in",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const RegisterForm(),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 14, 147, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Sign up",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 35),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
        child: Center(
          child: 
          SingleChildScrollView(
            child: Column(
              verticalDirection: VerticalDirection.down,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 150),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'The best way to\nanalyze and monitor\nyour trading accounts',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Easily analyze and monitor all the necessary data to be a successful trader',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => const RegisterForm(),
                                );
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                "Try for free",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                                side: const BorderSide(color: Colors.black),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                "See how it works",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 150),
                Card(
                  color: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(36, 72, 36, 72),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Introducing\naccurate and\ninteractive charts',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Join us and enjoy the benefits today!',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    "Try for free",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: Image.asset("lib/assets/chart.png"),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 150),
              ],  
            ),
          ),
        ),
      ),
    );
  }
}
