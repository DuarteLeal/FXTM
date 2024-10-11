import 'package:flutter/material.dart';
import 'package:fx_analysis/providers/trade_provider.dart';
import 'package:provider/provider.dart';

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
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Lotes: ${trade.lots}, Lucro: ${trade.profit}"),
                              Text(
                                  "Abertura: ${trade.openDate} às ${trade.openTime}"),
                              Text(
                                  "Fechamento: ${trade.closeDate} às ${trade.closeTime}"),
                            ],
                          ),
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
