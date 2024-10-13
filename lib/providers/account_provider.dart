import 'package:flutter/material.dart';
import '../models/trading_account.dart';
import 'dart:developer' as dev;

class AccountProvider with ChangeNotifier {
  TradingAccount? account;
  
  List<double> weeklyBalance = [];
  List<double> weeklyGain = [];
  double totalProfit = 0;  // Atributo para armazenar o lucro total

  int totalWeeks = 0;

  DateTime? firstTrade;
  DateTime? lastTrade;

  void setAccount(TradingAccount newAccount) {
    account = newAccount;
    notifyListeners();
  }

  Future<void> calculateWeeklyBalancesAndGains() async {
    weeklyBalance.clear();
    weeklyGain.clear();
    totalProfit = 0; // Reset do lucro total para novo cálculo

    if (account == null || account!.trades.isEmpty) {
      notifyListeners();
      return;
    }

    firstTrade = account!.trades.first.openDateTime;
    lastTrade = account!.trades.last.closeDateTime;

    totalWeeks = (lastTrade!.difference(firstTrade!).inDays / 7).ceil();
    double initialDeposit = account!.deposit;
    double totalBalance = initialDeposit;

    DateTime startOfWeek = firstTrade!;
    for (int i = 0; i < totalWeeks; i++) {
      DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
      double weeklyProfit = 0;

      for (var trade in account!.trades) {
        if (trade.openDateTime.isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
            trade.openDateTime.isBefore(endOfWeek.add(const Duration(days: 1)))) {
          weeklyProfit += trade.profit;
        }
      }

      totalProfit += weeklyProfit; // Adicionando o lucro semanal ao lucro total
      totalBalance += weeklyProfit;
      weeklyBalance.add(totalBalance);

      double weeklyGainPercentage = (weeklyProfit / initialDeposit) * 100;
      weeklyGain.add(weeklyGainPercentage);

      startOfWeek = endOfWeek.add(const Duration(days: 1));
    }

    dev.log("Total de semanas: $totalWeeks");
    dev.log("Lucro Total: $totalProfit"); // Logging do lucro total
    notifyListeners();
  }
}
