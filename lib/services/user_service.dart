import 'package:bcrypt/bcrypt.dart'; // Library for password hashing.
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore for database interactions.
import 'dart:developer' as dev; // For debugging tools.

/// Service class to manage all user-related operations in Firebase Firestore.
class UserService {
  /// Registers a new user in Firestore.
  ///
  /// Parameters:
  /// - [username]: The username chosen by the user.
  /// - [name]: The full name of the user.
  /// - [email]: The user's email address.
  /// - [password]: The user's password.
  ///
  /// Description:
  /// - Validates that the username and email are available.
  /// - Hashes the user's password securely.
  /// - Saves the user information to Firestore.
  ///
  /// Returns:
  /// - A success message or an error message as a [String].
  Future<String> registerUser(
      String username, String name, String email, String password) async {
    try {
      // Check if the username is available.
      if (!await isUsernameAvailable(username)) {
        return 'Username already taken';
      }

      // Check if the email is valid and available.
      if (!await checkEmail(email)) {
        return 'Invalid or already registered email';
      }

      // Generate a hash for the password.
      String hashedPassword = generatePasswordHash(password);

      // Add the user to Firestore.
      await createUser(username, name, email, hashedPassword);

      return 'User registered successfully';
    } catch (e) {
      return 'Error registering user: $e';
    }
  }

  /// Adds a new user document to Firestore.
  ///
  /// Parameters:
  /// - [username]: The chosen username.
  /// - [name]: The user's full name.
  /// - [email]: The user's email address.
  /// - [hashedPassword]: The hashed password.
  /// - [access_token]: The access token, only saved when the user connects accounts
  /// - [refresh_token]: The refresh token, only saved when the user connects accounts
  /// - [toxen_expiry]: The token expiry date, default is 30 days, the server should the refresh each token every 2 weeks
  /// Description:
  /// - Saves the user's data to the `Users` collection in Firestore.
  Future<void> createUser(
      String username, String name, String email, String hashedPassword) async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('Users');

    await usersCollection.add({
      'username': username,
      'name': name,
      'email': email,
      'password': hashedPassword,
      'created_at': DateTime.now().toIso8601String(),
      'access_token': '',
      'refresh_token': '',
      'token_expiry': '',
    });

    dev.log("User created successfully!");
  }

  /// Checks if a username is available in Firestore.
  ///
  /// Parameters:
  /// - [username]: The username to check.
  ///
  /// Description:
  /// - Queries the `Users` collection in Firestore to see if the username exists.
  ///
  /// Returns:
  /// - `true` if the username is available, `false` otherwise.
  Future<bool> isUsernameAvailable(String username) async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('Users');

    QuerySnapshot querySnapshot =
        await usersCollection.where('username', isEqualTo: username).get();

    return querySnapshot.docs.isEmpty;
  }

  /// Validates and checks the availability of an email.
  ///
  /// Parameters:
  /// - [email]: The email to validate and check.
  ///
  /// Description:
  /// - Uses a regular expression to validate the email format.
  /// - Queries Firestore to check if the email already exists.
  ///
  /// Returns:
  /// - `true` if the email is valid and available, `false` otherwise.
  Future<bool> checkEmail(String email) async {
    if (!isEmailValid(email)) {
      dev.log("Invalid email format.");
      return false;
    }

    bool available = await isEmailAvailable(email);
    if (!available) {
      dev.log("Email is already in use.");
      return false;
    }

    return true;
  }

  /// Validates the format of an email.
  ///
  /// Parameters:
  /// - [email]: The email to validate.
  ///
  /// Description:
  /// - Uses a regular expression to check if the email format is valid.
  ///
  /// Returns:
  /// - `true` if the email format is valid, `false` otherwise.
  bool isEmailValid(String email) {
    final emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return emailRegex.hasMatch(email);
  }

  /// Checks if an email is already registered in Firestore.
  ///
  /// Parameters:
  /// - [email]: The email to check.
  ///
  /// Description:
  /// - Queries the `Users` collection in Firestore to check if the email exists.
  ///
  /// Returns:
  /// - `true` if the email is available, `false` otherwise.
  Future<bool> isEmailAvailable(String email) async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('Users');

    QuerySnapshot querySnapshot =
        await usersCollection.where('email', isEqualTo: email).get();

    return querySnapshot.docs.isEmpty;
  }

  /// Generates a secure hash for a password.
  ///
  /// Parameters:
  /// - [password]: The original password.
  ///
  /// Description:
  /// - Uses the bcrypt algorithm to generate a secure hash for the password.
  ///
  /// Returns:
  /// - The hashed password as a [String].
  String generatePasswordHash(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  /// Retrieves a user document by username from Firestore.
  ///
  /// Parameters:
  /// - [username]: The username to search for.
  ///
  /// Description:
  /// - Queries the `Users` collection in Firestore to find a user with the specified username.
  ///
  /// Returns:
  /// - A `Map<String, dynamic>` containing user data if found, or `null` if no match is found.
  Future<Map<String, dynamic>?> getUserByUsername(String username) async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('Users');

    QuerySnapshot querySnapshot =
        await usersCollection.where('username', isEqualTo: username).get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      final userData = doc.data() as Map<String, dynamic>;
      userData['id'] = doc.id;
      return userData;
    }

    return null;
  }

  /// Verifies if the provided password matches the stored hashed password.
  ///
  /// Parameters:
  /// - [password]: The plain-text password entered by the user.
  /// - [hashedPassword]: The hashed password stored in the database.
  ///
  /// Description:
  /// - Compares the plain-text password with the hashed password using bcrypt.
  ///
  /// Returns:
  /// - `true` if the passwords match, `false` otherwise.
  bool verifyPassword(String password, String hashedPassword) {
    return BCrypt.checkpw(password, hashedPassword);
  }

  /// Updates a user's password in Firestore.
  ///
  /// Parameters:
  /// - [userId]: The document ID of the user to update.
  /// - [newPassword]: The new plain-text password.
  ///
  /// Description:
  /// - Validates the new password for strength.
  /// - Hashes the new password.
  /// - Updates the `password` field in the Firestore `Users` document.
  ///
  /// Returns:
  /// - A message indicating success or failure.
  Future<String> updatePassword(String userId, String newPassword) async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('Users');

    // Validate password strength
    if (!isPasswordStrong(newPassword)) {
      return "The new password does not meet strength criteria.";
    }

    // Hash the new password
    String hashedPassword = generatePasswordHash(newPassword);

    // Update the Firestore document
    await usersCollection.doc(userId).update({'password': hashedPassword});
    return "Password updated successfully.";
  }

  /// Validates the strength of a password.
  ///
  /// Parameters:
  /// - [password]: The password to validate.
  ///
  /// Description:
  /// - Ensures the password meets the following criteria:
  ///   - At least 8 characters long.
  ///   - Includes one uppercase letter, one lowercase letter, one number, and one special character.
  ///
  /// Returns:
  /// - `true` if the password meets the criteria, `false` otherwise.
  bool isPasswordStrong(String password) {
    final passwordRegex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    return passwordRegex.hasMatch(password);
  }

  /// Updates a user's username in Firestore.
  ///
  /// Parameters:
  /// - [userId]: The document ID of the user to update.
  /// - [newUsername]: The new username to set.
  ///
  /// Description:
  /// - Checks if the new username is available.
  /// - Updates the `username` field in the Firestore `Users` document.
  ///
  /// Returns:
  /// - A message indicating success or
  /// failure.

  /// Updates a user's username in Firestore.
  ///
  /// Parameters:
  /// - [userId]: The document ID of the user to update.
  /// - [newUsername]: The new username to set.
  ///
  /// Description:
  /// - Checks if the new username is available.
  /// - Updates the `username` field in the Firestore `Users` document.
  ///
  /// Returns:
  /// - A message indicating success or failure.
  Future<String> updateUsername(String userId, String newUsername) async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('Users');

    // Check if the new username is available
    if (!await isUsernameAvailable(newUsername)) {
      return "The username is already in use.";
    }

    // Update the username in Firestore
    await usersCollection.doc(userId).update({'username': newUsername});
    return "Username updated successfully.";
  }

  /// Deletes a user document from Firestore.
  ///
  /// Parameters:
  /// - [userId]: The document ID of the user to delete.
  ///
  /// Description:
  /// - Removes the user document from the `Users` collection.
  ///
  /// Returns:
  /// - A message indicating success or failure.
  Future<String> deleteUser(String userId) async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('Users');

    try {
      await usersCollection.doc(userId).delete();
      return "User deleted successfully.";
    } catch (e) {
      return "Error deleting user: $e";
    }
  }

  /// Checks if a username and password combination is valid.
  ///
  /// Parameters:
  /// - [username]: The username entered by the user.
  /// - [password]: The password entered by the user.
  ///
  /// Description:
  /// - Retrieves the user document by username.
  /// - Verifies the provided password against the hashed password in Firestore.
  ///
  /// Returns:
  /// - `true` if the username and password are valid, `false` otherwise.
  Future<bool> validateLogin(String username, String password) async {
    final userData = await getUserByUsername(username);

    if (userData != null) {
      final String storedHashedPassword = userData['password'];
      return verifyPassword(password, storedHashedPassword);
    }

    return false; // User not found or password mismatch
  }
}