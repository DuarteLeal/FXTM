import 'package:flutter/material.dart';
import 'package:fx_analysis/models/trade.dart';
import 'package:fx_analysis/services/trade_service.dart';
import 'package:provider/provider.dart';

class TradeProvider with ChangeNotifier {
  List<Trade> trades = [];
  final TradeService _tradeService = TradeService();

  Future<void> fetchTrades() async {
    trades = await _tradeService.loadTrades();
    notifyListeners();
  }

  double calculateTotalProfit() {
    return trades.fold(0, (sum, trade) => sum + trade.profit);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TradeProvider(),
      child: const MaterialApp(
        home: TradeScreen(),
      ),
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
        child: tradeProvider.trades.isEmpty
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
                  Text("Lucro Total: ${tradeProvider.calculateTotalProfit()}"),
                ],
              ),
      ),
    );
  }
}
