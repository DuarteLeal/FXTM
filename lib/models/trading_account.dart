class TradingAccount {
  final int id;
  final double balance;
  final String currency;
  final int leverage;
  final double equity;

  // Constructor
  TradingAccount({
    required this.id,
    required this.balance,
    required this.currency,
    required this.leverage,
    required this.equity,
  });

  // Factory method to create an instance from JSON
  factory TradingAccount.fromJson(Map<String, dynamic> json) {
    return TradingAccount(
      id: json['id'],
      balance: json['balance'].toDouble(),
      currency: json['currency'],
      leverage: json['leverage'],
      equity: json['equity'].toDouble(),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'balance': balance,
      'currency': currency,
      'leverage': leverage,
      'equity': equity,
    };
  }
}
