import 'package:fx_analysis/models/trade.dart';

class TradingAccount {
  final String accountId;
  final String userId;
  final String accountName;
  final double gain;
  final double daily;
  final double monthly;
  final double drawdown;
  final double balance;
  final double equity;
  final double highest;
  final double profit;
  final double deposit;
  final double withdrawals;
  final List<Trade> trades;

  TradingAccount({
    required this.userId,
    required this.accountId,
    required this.accountName,
    required this.gain,
    required this.daily,
    required this.monthly,
    required this.drawdown,
    required this.balance,
    required this.equity,
    required this.highest,
    required this.profit,
    required this.deposit,
    required this.withdrawals,
    required this.trades,
  });

  // Método fromJson para desserializar o JSON
  factory TradingAccount.fromJson(Map<String, dynamic> json) {
    return TradingAccount(
      userId: json['userId'],
      accountId: json['accountId'],
      accountName: json['accountName'],
      gain: (json['gain'] as num).toDouble(),
      daily: (json['daily'] as num).toDouble(),
      monthly: (json['monthly'] as num).toDouble(),
      drawdown: (json['drawdown'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
      equity: (json['equity'] as num).toDouble(),
      highest: (json['highest'] as num).toDouble(),
      profit: (json['profit'] as num).toDouble(),
      deposit: (json['deposit'] as num).toDouble(),
      withdrawals: (json['withdrawals'] as num).toDouble(),
      trades: (json['trades'] as List<dynamic>).map((tradeJson) {
        return Trade.fromJson(tradeJson);
      }).toList(),
    );
  }
}
