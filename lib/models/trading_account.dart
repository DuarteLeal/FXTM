import 'package:fx_analysis/models/trade.dart';

class TradingAccount {
  final String accountId;
  final String accountName;
  final double gain;
  final double daily;
  final double monthly;
  final double drawdown;
  final double balance;
  final double equity;
  final double highest;
  final double deposit;
  final double withdrawals;
  final List<Trade> trades;

  TradingAccount({
    required this.accountId,
    required this.accountName,
    required this.gain,
    required this.daily,
    required this.monthly,
    required this.drawdown,
    required this.balance,
    required this.equity,
    required this.highest,
    required this.deposit,
    required this.withdrawals,
    required this.trades,
  });
}
