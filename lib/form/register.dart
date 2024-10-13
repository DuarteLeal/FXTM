import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fx_analysis/form/login.dart'; // ignore: unused_import
import 'package:uuid/uuid.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  RegisterFormState createState() => RegisterFormState();
}

class RegisterFormState extends State<RegisterForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final Uuid uuid = const Uuid();
  String _usernameError = '';
  String _emailError = '';
  String _passwordError = '';
  String _confirmPasswordError = '';
  bool _termsAccepted = false; // Track checkbox state
  // ignore: unused_field
  String _termsError = ''; // Error message for terms

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[200],
      content: SizedBox(
        height: 400,
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(
              child: Text("Sign Up", style: TextStyle(color: Colors.blue, fontSize: 25))
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                errorText: _usernameError.isEmpty ? null : _usernameError,
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: _emailError.isEmpty ? null : _emailError,
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: _passwordError.isEmpty ? null : _passwordError,
              ),
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                errorText: _confirmPasswordError.isEmpty ? null : _confirmPasswordError,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Checkbox(
                  value: _termsAccepted,
                  onChanged: (bool? value) {
                    setState(() {
                      _termsAccepted = value ?? false;
                    });
                  },
                ),
                const Expanded(child: Text('I agree to the Terms of Service & Privacy Policy')),
              ],
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text("Already a member? "),
                GestureDetector(
                  onTap: () {},
                  child: const Text("Log in", style: TextStyle(decoration: TextDecoration.underline)),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (!_termsAccepted) {
                    _termsError = 'You must accept the terms to continue.';
                  } else {
                    _termsError = '';
                    if (_validateForm()) {
                      _registerUser();
                    }
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ],
    );
  }

  bool _validateForm() {
    bool isValid = true;
    setState(() {
      if (_usernameController.text.isEmpty) {
        _usernameError = 'Username cannot be empty';
        isValid = false;
      } else {
        _usernameError = '';
      }

      if (!_emailController.text.contains('@')) {
        _emailError = 'Enter a valid email';
        isValid = false;
      } else {
        _emailError = '';
      }

      if (!_validatePassword(_passwordController.text)) {
        _passwordError = 'Password must be at least 8 characters, include an uppercase letter, a lowercase letter, a number, and a special character.';
        isValid = false;
      } else {
        _passwordError = '';
      }

      if (_passwordController.text != _confirmPasswordController.text) {
        _confirmPasswordError = 'Passwords do not match';
        isValid = false;
      } else {
        _confirmPasswordError = '';
      }
    });
    return isValid;
  }

  bool _validatePassword(String password) {
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasSpecialCharacters = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool hasMinLength = password.length >= 8;
    return hasUppercase && hasDigits && hasLowercase && hasSpecialCharacters && hasMinLength;
  }

  void _registerUser() async {
    final file = File('C:/Users/donzd/Documents/flutter projects/fx_analysis/lib/json/user_data.json');
    List<dynamic> users = [];

    if (await file.exists()) {
      final String contents = await file.readAsString();
      users = jsonDecode(contents);
    }

    users.add({
      'id': uuid.v4(),
      'username': _usernameController.text,
      'email': _emailController.text,
      'password': _passwordController.text.codeUnits.toString(),
    });

    await file.writeAsString(jsonEncode(users));
    
    Navigator.of(context).pop(); // ignore: use_build_context_synchronously
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
