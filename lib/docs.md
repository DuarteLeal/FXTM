# Flutter Application Documentation

## User Registration

The application uses Firebase Authentication for user registration and Cloud Firestore to store user details. Below is the explanation of how the registration process works:

### Registration Workflow

1. **Input Fields**: The registration form includes fields for:
   - Name
   - Email
   - Password
   - Password Confirmation

2. **Terms of Service Agreement**:
   - The user must check a box agreeing to the Terms of Service and Privacy Policy before proceeding.

3. **Validation Checks**:
   - The app validates that:
     - The password and confirmation password match.
     - The user has accepted the terms.

4. **Firebase Authentication**:
   - If validation passes, the app creates a new user using Firebase Authentication. 

5. **Firestore Integration**:
   - The user data (name, email, registration date) is stored in the Firestore `users` collection under a document identified by the user’s UID.


**Note: After the registration the user should be automatically logged-in**

### Error Handling

- Weak Password: Displays "The password is too weak."
- Email Already Registered: Displays "The email is already registered."
- Terms Not Accepted: Displays "You must accept the terms to continue."

### Example Code Snippet for Registration (Flutter):

```dart
await FirebaseAuth.instance.createUserWithEmailAndPassword(
  email: _emailController.text.trim(),
  password: _passwordController.text.trim(),
);
await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
  'name': _nameController.text.trim(),
  'email': _emailController.text.trim(),
  'createdAt': DateTime.now(),
});
```

---

## User Login

The login process allows registered users to access their accounts. Below is the explanation of how it works:

### Login Workflow

1. **Input Fields**: The login form includes fields for:
   - Email
   - Password

2. **Firebase Authentication**:
   - The app verifies the credentials using Firebase Authentication.

3. **Error Handling**:
   - Displays appropriate error messages for invalid credentials or unregistered emails.

4. **Session Management**:
   - Once logged in, the app maintains the session using Firebase's built-in authentication state management.

### Example Code Snippet for Login (Flutter):

```dart
await FirebaseAuth.instance.signInWithEmailAndPassword(
  email: _emailController.text.trim(),
  password: _passwordController.text.trim(),
);
```

---

## Database Structure

### Collection: `users`
- **Document ID**: UID (User ID)
- **Fields**:
  - `name`: User's full name.
  - `email`: User's email address.
  - `createdAt`: Timestamp of registration.
  - `access_token`: Access token for cTrader integration.
  - `refresh_token`: Refresh token for cTrader integration.
  - `token_expiry`: Expiration time of the access token.
  (the tokens/expiry time are added when the user adds and account with the CTrader API)
---

This documentation explains the flow of user registration and login, ensuring proper integration with Firebase Authentication and Firestore.

## Menu Pages Overview

### Dashboard
- Displays an overview of:
  - Total number of accounts.
  - Total balance across all accounts.
  - Net balance and floating balance.
  - Average monthly return.
  - Total deposits and total profit.

### My Accounts
- **Dropdown Menu**: Hovering over this menu displays a list of the user's accounts.
- **Account Details**: Clicking on an account shows:
  - Balance.
  - Trade history.
  - Relevant charts and metrics.

### Calculators
- **Dropdown Menu**: Displays available financial calculators, including:
  - Compound Interest.
  - Average Price.
  - Hedge Calculator.

## Deep Dive: My Accounts

### Overview
The **My Accounts** page serves as a central hub for managing trading accounts. It allows users to view account details, authorize new accounts, and assign custom names to their accounts.

### Workflow

1. **Fetching Accounts**:
   - When the user navigates to the **My Accounts** page, the application fetches the list of accounts linked to their profile using the `fetchTradingAccounts` method in the `AccountsService` class.
   - The accounts are displayed in a scrollable list showing key details such as:
     - Account Number
     - Live/Practice Status
     - Broker Title
     - Deposit Currency
     - Account Type
     - Leverage
     - Balance
   - Sketch of what the account card could look like [example](https://imgur.com/a/GeCa1CH). After the design improvement there should be a copy of the code/example here.
      - note: all the data that does not come with the fetchtradingaccounts function will be fetched with protobufs
      - source code
        ```dart
          Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text("Conta teste 1"),
                        const Spacer(),
                        IconButton(onPressed: (){}, icon: const Icon(Icons.settings)),
                      ],
                    ),
                    const Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Gain: 33.34%"),
                            Text("Montlhy return: 11.11%"),
                            Text("Floating: -5.000,00 \$ (-50%)"),
                            Text("Balance: 10.000,00 \$"),
                            Text("Equity: 5.000,00 \$"),
                            Text("Total deposited: 7.500,00 \$"),
                            Text("Total Withdrawn: 0,00 \$"),
                            Text("Total profit: 2.500,00 \$"),
                            Text("Account age: 3 months")
                          ],
                        ),
                        Spacer(),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Spacer(),
                        TextButton(onPressed: (){}, child: const Text("Open with ctrader"))
                      ],
                    )
                  ],
                ),
              ),
            ),
        ``` 

2. **Adding Accounts**:
   - The user can add accounts by clicking the **Add Account** button. This triggers the backend [OAuth process](https://help.ctrader.com/open-api/account-authentication/?h=oauth#authentication-flow) to authorize accounts from cTrader.
   - After authorization, the user is redirected back to the **My Accounts** page.

3. **Post-Authorization Menu**:
   - Upon returning, a menu appears showing the accounts selected during the cTrader authorization process.
   [Example with myfxbook](https://imgur.com/a/R5dCBi1)
   - The user can assign a custom name to each account.

4. **Saving Account Details**:
   - Once the user assigns custom names, a document is created in the `accounts` collection with the following fields:
     - `user_id`: The ID of the user who owns the account.
     - `account_id`: The unique ID of the account from cTrader.
     - `account_name`: The custom name assigned by the user.

5. **Editing Account Details**:
    - Just like myfxbook, there should be an option called settings that allows the user to edit the details of his account. [Example](https://imgur.com/a/0et1X3M)
    - In the settings menu, should exist the following options:
        - Account Name
        - Trading type (manual, automated, both)
        - Add a manager (There will be created documentation regarding account managers, if you still see this message its because there isn't, so you can skip this step)

### Frontend Implementation

#### Fetching Accounts
```dart
Future<void> _fetchAccounts() async {
  var fetchedAccounts = await widget.accountsService.fetchTradingAccounts();
  if (fetchedAccounts != null && fetchedAccounts['data'] != null) {
    setState(() {
      accounts = fetchedAccounts['data'];
    });
  }
}
```

#### Adding Accounts
```dart
Future<void> _addAccount() async {
  await widget.accountsService.addAccounts();
  _fetchAccounts();
}
```

#### Post-Authorization Menu
- The menu appears dynamically after account authorization, allowing users to input custom names for their accounts.
- A form or dialog box can be used to capture the custom names.

### Backend Implementation

#### Fetching Accounts
```javascript
exports.getAccounts = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "The function must be called while authenticated."
    );
  }

  const uid = context.auth.uid;

  try {
    const userDoc = await admin.firestore().collection("users").doc(uid).get();
    if (!userDoc.exists) {
      throw new functions.https.HttpsError(
        "not-found",
        "User data not found."
      );
    }

    const userData = userDoc.data();
    let accessToken = userData.access_token;

    if (Date.now() >= userData.token_expiry) {
      const refreshResponse = await fetch("https://api.ctrader.com/token", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: `refresh_token=${userData.refresh_token}&client_id=${client_id}&client_secret=${client_secret}&grant_type=refresh_token`
      });

      if (!refreshResponse.ok) {
        throw new functions.https.HttpsError(
          "permission-denied",
          "Failed to refresh access token."
        );
      }

      const refreshData = await refreshResponse.json();
      accessToken = refreshData.access_token;

      await admin.firestore().collection("users").doc(uid).update({
        access_token: refreshData.access_token,
        token_expiry: Date.now() + refreshData.expires_in * 1000,
      });
    }

    const accountsResponse = await fetch("https://api.ctrader.com/accounts", {
      headers: { "Authorization": `Bearer ${accessToken}` },
    });

    if (!accountsResponse.ok) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Failed to fetch account data."
      );
    }

    const accounts = await accountsResponse.json();
    return { accounts: accounts.accounts };
  } catch (error) {
    console.error("Error fetching accounts", error);
    throw new functions.https.HttpsError(
      "unknown",
      "Failed to fetch accounts data."
    );
  }
});
```

#### Saving Account Details
```javascript
exports.saveAccountDetails = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "The function must be called while authenticated."
    );
  }

  const { accountId, accountName } = data;
  const uid = context.auth.uid;

  if (!accountId || !accountName) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Account ID and Account Name are required."
    );
  }

  try {
    await admin.firestore().collection("accounts").doc(accountId).set({
      user_id: uid,
      account_id: accountId,
      account_name: accountName,
    });

    return { message: "Account details saved successfully." };
  } catch (error) {
    console.error("Error saving account details", error);
    throw new functions.https.HttpsError(
      "internal",
      "Failed to save account details."
    );
  }
});
```

---

This expanded section provides a comprehensive explanation of the **My Accounts** workflow, covering both frontend and backend implementations for managing and saving account details.

## Deep Dive: Dashboard

### Overview
The **Dashboard** serves as the main summary page for the application, providing users with key insights into their trading performance and account statistics. It is designed to display a collection of cards with real-time and cumulative data, making it easy for users to monitor their overall progress.

### Current Features

1. **Cards Overview**:
   - **Number of Accounts**: Displays the total number of accounts linked to the user's profile.
   - **Total Balance**: Shows the combined balance across all accounts.
   - **Total Floating Balance**: Displays the sum of floating profits/losses from all accounts.
   - **Net Balance**: Indicates the net balance after factoring in floating profits/losses.
   - **Total Profit**: Highlights the cumulative profit made by the user over time.

2. **Real-Time Updates**:
   - Data displayed on the dashboard is fetched in real-time or periodically updated to reflect changes in account performance.

### Future Enhancements

1. **Account Selection**:
   - Users will be able to select specific accounts to include in the dashboard calculations.

2. **Date Filters**:
   - Allow filtering of displayed data by date ranges (e.g., last 7 days, month-to-date, year-to-date).

3. **Detailed Statistics and Graphs**:
   - Growth Analysis: Display account growth over time using interactive line graphs, one line for each account selected.
   - Floating Balance Trends: Visualize fluctuations in floating balance.
   - Profit Analysis: Highlight monthly, quarterly, and yearly profits.

4. **Customizable Layout**:
   - Users can rearrange or hide cards based on their preferences.

### Frontend Implementation

#### Example Code for Displaying Cards
```dart
class DashboardCard extends StatelessWidget {
  final String title;
  final String value;

  const DashboardCard({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 24, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}
```

#### Example Dashboard Layout
```dart
class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      children: [
        DashboardCard(title: "Number of Accounts", value: "5"),
        DashboardCard(title: "Total Balance", value: "\$25,000"),
        DashboardCard(title: "Floating Balance", value: "\$1,500"),
        DashboardCard(title: "Net Balance", value: "\$23,500"),
        DashboardCard(title: "Total Profit", value: "\$8,000"),
      ],
    );
  }
}
```

### Backend Implementation

#### Example Function for Fetching Dashboard Data
```javascript
exports.getDashboardData = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "The function must be called while authenticated."
    );
  }

  const uid = context.auth.uid;

  try {
    const accountsSnapshot = await admin.firestore().collection("accounts")
      .where("user_id", "==", uid)
      .get();

    if (accountsSnapshot.empty) {
      return {
        numberOfAccounts: 0,
        totalBalance: 0,
        floatingBalance: 0,
        netBalance: 0,
        totalProfit: 0,
      };
    }

    let totalBalance = 0;
    let floatingBalance = 0;
    let totalProfit = 0;

    accountsSnapshot.forEach((doc) => {
      const accountData = doc.data();
      totalBalance += accountData.balance || 0;
      floatingBalance += accountData.floating || 0;
      totalProfit += accountData.profit || 0;
    });

    const netBalance = totalBalance + floatingBalance;

    return {
      numberOfAccounts: accountsSnapshot.size,
      totalBalance,
      floatingBalance,
      netBalance,
      totalProfit,
    };
  } catch (error) {
    console.error("Error fetching dashboard data", error);
    throw new functions.https.HttpsError(
      "internal",
      "Failed to fetch dashboard data."
    );
  }
});
```

---

This section outlines the current functionality of the dashboard and potential future enhancements. It provides example implementations for both frontend and backend components to support the described features.

