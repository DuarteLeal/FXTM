import 'package:flutter/material.dart';
import 'package:fx_analysis/models/trade.dart';
import 'package:fx_analysis/services/trade_service.dart';
import 'package:provider/provider.dart';

class TradeProvider with ChangeNotifier {
  List<Trade> trades = [];
  final TradeService _tradeService = TradeService();
  bool isLoading = false;
  String errorMessage = '';

  Future<void> fetchTrades() async {
    try {
      isLoading = true;
      notifyListeners();

      trades = await _tradeService.loadTrades();
      errorMessage = '';
    } catch (error) {
      errorMessage = 'Failed to load trades.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  double calculateTotalProfit() {
    return trades.fold(0, (sum, trade) => sum + trade.profit);
  }
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TradeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TradeScreen(),
    );
  }
}

class TradeScreen extends StatelessWidget {
  const TradeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tradeProvider = Provider.of<TradeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Histórico de Trades"),
      ),
      body: Center(
        child: tradeProvider.isLoading
            ? const CircularProgressIndicator()
            : tradeProvider.errorMessage.isNotEmpty
                ? Text(tradeProvider.errorMessage)
                : tradeProvider.trades.isEmpty
                    ? ElevatedButton(
                        onPressed: () {
                          tradeProvider.fetchTrades();
                        },
                        child: const Text("Carregar Trades"),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: tradeProvider.trades.length,
                              itemBuilder: (context, index) {
                                final trade = tradeProvider.trades[index];
                                return ListTile(
                                  title: Text(
                                      "${trade.pair}: ${trade.entry} -> ${trade.exit}"),
                                  subtitle: Text(
                                      "Lotes: ${trade.lots}, Lucro: ${trade.profit}"),
                                );
                              },
                            ),
                          ),
                          Text(
                              "Lucro Total: ${tradeProvider.calculateTotalProfit()}"),
                        ],
                      ),
      ),
    );
  }
}
