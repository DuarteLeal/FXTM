import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  RegisterFormState createState() => RegisterFormState();
}

class RegisterFormState extends State<RegisterForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String _errorMessage = '';
  bool _termsAccepted = false; // Track checkbox state
  bool _isLoading = false; // Loading indicator

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[200],
      content: SizedBox(
        height: 500,
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(
              child: Text("Sign Up", style: TextStyle(color: Colors.blue, fontSize: 25)),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
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
                const Expanded(
                  child: Text('I agree to the Terms of Service & Privacy Policy'),
                ),
              ],
            ),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
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
                  onTap: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text(
                    "Log in",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _isLoading ? null : _registerUser,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Sign Up'),
            ),
          ],
        ),
      ],
    );
  }

  /// Handles user registration.
  Future<void> _registerUser() async {
    setState(() {
      _errorMessage = '';
      _isLoading = true;
    });

    // Validate inputs
    if (!_termsAccepted) {
      setState(() {
        _errorMessage = 'You must accept the terms to continue.';
        _isLoading = false;
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match.';
        _isLoading = false;
      });
      return;
    }

    try {
      // Create user with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Store additional user data in Firestore
      User? user = userCredential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'createdAt': DateTime.now(),
        });

        // Navigate or close the dialog on success
        if (mounted) {
          Navigator.of(context).pop(); // Close the dialog after successful registration
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'weak-password') {
          _errorMessage = 'The password is too weak.';
        } else if (e.code == 'email-already-in-use') {
          _errorMessage = 'The email is already registered.';
        } else {
          _errorMessage = 'An error occurred. Please try again.';
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Unexpected error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
