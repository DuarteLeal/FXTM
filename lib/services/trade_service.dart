import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:fx_analysis/models/trade.dart';

class TradeService {
  Future<List<Trade>> loadTrades() async {
    final String response = await rootBundle.loadString('json/accounts.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Trade.fromJson(json)).toList();
  }
}
