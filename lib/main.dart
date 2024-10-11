import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'providers/account_provider.dart';
import 'dart:developer' as dev; //ignore:unused_import

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AccountProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'cTrader Tracking',
      home: AccountScreen(),
    );
  }
}

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  AccountScreenState createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen> {
  int _selectedIndex = 0; // Índice do painel selecionado
  bool _isLoading = true; // Variável para controlar o estado de carregamento

  @override
  void initState() {
    super.initState();
    // Adiciona um callback para rodar após o build estar completo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAccountData(); // Carrega os dados automaticamente ao iniciar a tela
    });
  }

  void _loadAccountData() async {
    final accountProvider =
        Provider.of<AccountProvider>(context, listen: false);
    await accountProvider.fetchAccountData();
    setState(() {
      _isLoading =
          false; // Atualiza o estado para indicar que o carregamento terminou
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);

    if (accountProvider.account != null &&
        accountProvider.account!.trades.isNotEmpty) {
      accountProvider.calculateWeeklyBalances();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Account nº ${accountProvider.account?.accountId}"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                Container(
                  width: 250,
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.grey[200],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Account Stats:",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      //Account info
                      ...[
                        {
                          "label": "Gain:",
                          "value":
                              "${accountProvider.account!.gain.toStringAsFixed(2)}%"
                        },
                        {
                          "label": "Daily:",
                          "value":
                              "${accountProvider.account!.daily.toStringAsFixed(2)}%"
                        },
                        {
                          "label": "Monthly:",
                          "value":
                              "${accountProvider.account!.monthly.toStringAsFixed(2)}%"
                        },
                        {
                          "label": "Drawdown:",
                          "value":
                              "${accountProvider.account!.drawdown.toStringAsFixed(2)}%"
                        },
                        {
                          "label": "Balance:",
                          "value":
                              "\$${accountProvider.account!.balance.toStringAsFixed(2)}"
                        },
                        {
                          "label": "Equity:",
                          "value":
                              "\$${accountProvider.account!.equity.toStringAsFixed(2)}"
                        },
                        {
                          "label": "Highest:",
                          "value":
                              "\$${accountProvider.account!.highest.toStringAsFixed(2)}"
                        },
                        {
                          "label": "Deposit:",
                          "value":
                              "\$${accountProvider.account!.deposit.toStringAsFixed(2)}"
                        },
                        {
                          "label": "Withdrawals:",
                          "value":
                              "\$${accountProvider.account!.withdrawals.toStringAsFixed(2)}"
                        },
                      ].map(
                        (item) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item["label"]!),
                            Text(item["value"]!),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _loadAccountData,
                        child: const Text("Refresh"),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: LineChart(
                      LineChartData(
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, meta) {
                                return Text('${value.toInt()}');
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                return Text('Semana ${value.toInt()}');
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: true),
                        gridData: const FlGridData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            spots: accountProvider.weeklyBalances
                                .asMap()
                                .entries
                                .map((entry) {
                              int weekIndex = entry.key;
                              double balance =
                                  entry.value; // saldo da conta em cada semana
                              return FlSpot(weekIndex.toDouble(), balance);
                            }).toList(),
                            isCurved: true,
                            dotData: const FlDotData(show: false),
                            belowBarData: BarAreaData(show: false),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Account info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
