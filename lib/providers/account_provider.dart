import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:fx_analysis/models/trade.dart';
import '../models/trading_account.dart';
import 'dart:developer' as dev;

class AccountProvider with ChangeNotifier {
  TradingAccount? account;
  List<Trade> trades = [];
  List<double> weeklyBalances = [];
  int totalWeeks = 0;

  DateTime? firstTrade;
  DateTime? lastTrade;

  void calculateWeeklyBalances() {
    weeklyBalances.clear();

    if (trades.isEmpty) return;

    firstTrade = trades.first.openDateTime;
    lastTrade = trades.last.closeDateTime;

    double totalBalance = 0;

    totalWeeks = (lastTrade!.difference(firstTrade!).inDays / 7).ceil();

    for (DateTime weekDate = firstTrade!;
        weekDate.isBefore(lastTrade!.add(const Duration(days: 7)));
        weekDate = weekDate.add(const Duration(days: 7))) {
      double weeklyProfit = trades
          .where((trade) =>
              trade.openDateTime
                  .isAfter(weekDate.subtract(const Duration(days: 7))) &&
              trade.openDateTime.isBefore(weekDate))
          .fold(0, (sum, trade) => sum + trade.profit);

      totalBalance += weeklyProfit;

      weeklyBalances.add(totalBalance);
    }

    dev.log("Total de semanas: $totalWeeks");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> fetchAccountData() async {
    try {
      final String response =
          await rootBundle.loadString('lib/json/account_data.json');
      final data = jsonDecode(response);

      account = TradingAccount(
        accountId: data['accountId'],
        accountName: data['accountName'],
        gain: data['gain'],
        daily: data['daily'],
        monthly: data['monthly'],
        drawdown: data['drawdown'],
        balance: data['balance'],
        equity: data['equity'],
        highest: data['highest'],
        deposit: data['deposit'],
        withdrawals: data['withdrawals'],
        trades: List<Trade>.from(
            data['trades'].map((trade) => Trade.fromJson(trade))),
      );

      notifyListeners();
    } catch (e) {
      dev.log("Erro ao carregar dados da conta: $e");
    }
  }
}
