import 'package:flutter/material.dart';
import 'package:fx_analysis/models/trading_account.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/account_provider.dart';

class CurrentAccountCharts extends StatefulWidget {
  const CurrentAccountCharts({super.key, required this.account, required this.filter});

  final TradingAccount account;
  final String filter;

  @override
  CurrentAccountChartsState createState() => CurrentAccountChartsState();
}

class CurrentAccountChartsState extends State<CurrentAccountCharts> {
  late TradingAccount account;
  late String filter;

  @override
  void initState() {
    super.initState();
    
    account = widget.account;
    filter = widget.filter;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAccountData();
    });
  }

  void _loadAccountData() async {
    final accountProvider = Provider.of<AccountProvider>(context, listen: false);

    accountProvider.setAccount(account);

    if (accountProvider.account != null && accountProvider.account!.trades.isNotEmpty) {
      accountProvider.calculateWeeklyBalancesAndGains();
    }
    
    setState(() {
    });
  }

  double calculatePercentageGain(double initialValue, double currentValue) {
    if (initialValue == 0) return 0.0;
    return ((currentValue - initialValue) / initialValue) * 100;
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: accountProvider.weeklyBalance.isEmpty
            ? const Text("No data available for weekly balances.")
            : LineChart(
                LineChartData(
                  minY: -20,
                  maxY: 20,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 80,
                        getTitlesWidget: (value, meta) {
                          return Text(value < 0 ? '${value.toStringAsFixed(2)}%' : ' ${value.toStringAsFixed(2)}%');
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          return Text('Week ${value.toInt()}');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  gridData: const FlGridData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      color: Colors.green,
                      spots: accountProvider.weeklyGain.asMap().entries.map((entry) {
                        int weekIndex = entry.key;
                        double initialBalance = accountProvider.account!.deposit;
                        double currentGain = initialBalance + accountProvider.weeklyGain[weekIndex];
                        double gainPercentage = double.parse((calculatePercentageGain(initialBalance, currentGain) * 100).toStringAsFixed(2));
                        
                        return FlSpot(weekIndex.toDouble(), gainPercentage);
                      }).toList(),
                      isCurved: true,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
        ),
      );
  } 
}
