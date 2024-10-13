import 'package:flutter/material.dart';
import 'package:fx_analysis/form/login.dart';
import 'package:fx_analysis/form/register.dart';
import 'package:fx_analysis/providers/account_provider.dart';
import 'package:fx_analysis/providers/trade_provider.dart';
import 'package:provider/provider.dart';

// Define color variables
const Color kTextColor = Color.fromRGBO(238, 244, 237, 1);
const Color kAppBarBackgroundColor = Color.fromRGBO(11, 37, 69, 1);
const Color kPrimaryBackgroundColor = Color.fromRGBO(19, 49, 92, 1);
const Color kButtonBackgroundColor = Color.fromARGB(141, 169, 196, 255);
const Color kButtonBorderColor = kTextColor;
const Color kCardBackgroundColor = Color.fromRGBO(238, 244, 237, 0.646);

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AccountProvider()),
        ChangeNotifierProvider(create: (_) => TradeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FX Account Monitor',
      home: const LandingPage(),
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
  Widget build(BuildContext context) {
    int selectedIndex = -1;
    final List<String> buttonLabels = ['Home', 'Pricing', 'About us', 'Contact'];

    return Scaffold(
      backgroundColor: kPrimaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: kAppBarBackgroundColor,
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
                  Text(
                    "FX Trading Monitor",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: kTextColor,
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
                            color: kTextColor,
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Log in",
                        style: TextStyle(color: kTextColor, fontSize: 16),
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
                      backgroundColor: kButtonBackgroundColor,
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(35, 0, 35, 0),
            child: SingleChildScrollView(
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
                          Text(
                            'The best way to\nanalyze and monitor\nyour trading accounts',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: kTextColor,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Easily analyze and monitor all the necessary data to be a successful trader',
                            style: TextStyle(
                              fontSize: 20,
                              color: kTextColor,
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
                                child: Text(
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
                                  side: BorderSide(color: kTextColor),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  "See how it works",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: kTextColor,
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
                    color: kCardBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(36, 72, 36, 72),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Introducing\naccurate and\ninteractive charts',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: kTextColor,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Join us and enjoy the benefits today!',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: kTextColor,
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  "Try for free",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
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
      ),
    );
  }
}
