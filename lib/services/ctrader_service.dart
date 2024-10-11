// ignore_for_file: unused_import

import 'dart:convert';
import 'package:fx_analysis/models/trading_account.dart';
import 'package:http/http.dart' as http;

/*
class CTraderService {
  final String _baseUrl = "https://api.spotware.com";
  final String _apiKey = "SUA_CHAVE_DE_API";

  Future<TradingAccount> getAccountData(String accountId) async {
    final url = '$_baseUrl/accounts/$accountId';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $_apiKey'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return TradingAccount.fromJson(data);
    } else {
      throw Exception("Erro ao carregar dados da conta");
    }
  }
}
*/