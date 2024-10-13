import 'package:flutter/material.dart';
import 'package:fx_analysis/models/trading_account.dart';

class CurrentAccountDetails extends StatelessWidget {
  const CurrentAccountDetails({super.key, required this.account});

  final TradingAccount account;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildRow("Account Name:", account.accountName),
              buildRow("Gain:", "${account.gain.toStringAsFixed(2)}%"),
              buildRow("Daily:", "${account.daily.toStringAsFixed(2)}%"),
              buildRow("Monthly:", "${account.monthly.toStringAsFixed(2)}%"),
              buildRow("Drawdown:", "${account.drawdown.toStringAsFixed(2)}%"),
              buildRow("Balance:", "\$${account.balance.toStringAsFixed(2)}"),
              buildRow("Equity:", "\$${account.equity.toStringAsFixed(2)}"),
              buildRow("Highest:", "\$${account.highest.toStringAsFixed(2)}"),
              buildRow("Profit:", "\$${account.profit.toStringAsFixed(2)}"),
              buildRow("Deposits:", "\$${account.deposit.toStringAsFixed(2)}"),
              buildRow("Withdrawals:", "\$${account.withdrawals.toStringAsFixed(2)}"),
            ],
          ),
        ),
      ),
    );
  }
    
  Widget buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label),
          const Spacer(),
          Text(value),
        ],
      ),
    );
  }
}
