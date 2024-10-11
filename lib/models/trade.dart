class Trade {
  final int tradeId;
  final String pair;
  final double entry;
  final double exit;
  final double lots;
  final double profit;
  final String openDate;
  final String openTime;
  final String closeDate;
  final String closeTime;

  Trade({
    required this.tradeId,
    required this.pair,
    required this.entry,
    required this.exit,
    required this.lots,
    required this.profit,
    required this.openDate,
    required this.openTime,
    required this.closeDate,
    required this.closeTime,
  });

  DateTime get openDateTime {
    return DateTime.parse('$openDate $openTime');
  }

  DateTime get closeDateTime {
    return DateTime.parse('$closeDate $closeTime');
  }

  factory Trade.fromJson(Map<String, dynamic> json) {
    return Trade(
      tradeId: json['tradeId'],
      pair: json['pair'],
      entry: json['entry'],
      exit: json['exit'],
      lots: json['lots'],
      profit: json['profit'],
      openDate: json['openDate'],
      openTime: json['openTime'],
      closeDate: json['closeDate'],
      closeTime: json['closeTime'],
    );
  }
}
