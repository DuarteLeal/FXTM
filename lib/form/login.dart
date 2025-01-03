import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fx_analysis/main.dart';
import 'dart:html' as html; // ignore: avoid_web_libraries_in_flutter
import 'dart:developer' as dev;

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _emailError = '';
  String _passwordError = '';
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  void _loadSavedCredentials() {
    final cookies = html.document.cookie?.split('; ') ?? [];
    final emailCookie = cookies.firstWhere(
      (cookie) => cookie.startsWith('email='),
      orElse: () => '',
    );
    final passwordCookie = cookies.firstWhere(
      (cookie) => cookie.startsWith('password='),
      orElse: () => '',
    );

    if (emailCookie.isNotEmpty && passwordCookie.isNotEmpty) {
      final savedEmail = emailCookie.split('=')[1];
      final savedPassword = passwordCookie.split('=')[1];

      _emailController.text = savedEmail;
      _passwordController.text = savedPassword;

      setState(() {
        _rememberMe = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Login'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              errorText: _emailError.isEmpty ? null : _emailError,
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              errorText: _passwordError.isEmpty ? null : _passwordError,
            ),
            obscureText: true,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Checkbox(
                value: _rememberMe,
                onChanged: (bool? value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
              ),
              const Text('Remember Me'),
            ],
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: _loginUser,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
          ),
          child: const Text('Login'),
        ),
      ],
    );
  }

  void _loginUser() async {
    setState(() {
      // Reset error messages before login attempt
      _emailError = '';
      _passwordError = '';
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      final User? user = userCredential.user;

      if (user != null) {
        dev.log("Login: Firebase Authenticated user: ${user.uid}");

        if (_rememberMe) {
          _saveCredentials();
        } else {
          _clearCredentials();
        }

        if (mounted) {
          // Navigate to the MainPage after successful login
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MainPage(),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      dev.log("Firebase login error: $e");
      setState(() {
        if (e.code == 'user-not-found') {
          _emailError = 'No user found for this email.';
        } else if (e.code == 'wrong-password') {
          _passwordError = 'Incorrect password.';
        } else {
          _emailError = 'An error occurred. Please try again.';
        }
      });
    } catch (e) {
      dev.log("Unexpected error: $e");
      setState(() {
        _emailError = 'An unexpected error occurred.';
      });
    }
  }

  void _saveCredentials() {
    final cookieExpiryDate = DateTime.now().add(const Duration(days: 30));
    final cookieExpiry =
        'expires=${cookieExpiryDate.toUtc().toIso8601String()}';

    html.document.cookie =
        'email=${_emailController.text}; $cookieExpiry; path=/';
    html.document.cookie =
        'password=${_passwordController.text}; $cookieExpiry; path=/';
  }

  void _clearCredentials() {
    html.document.cookie =
        'email=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/';
    html.document.cookie =
        'password=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
