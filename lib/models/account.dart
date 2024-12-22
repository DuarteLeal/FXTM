class Account {
  final int accountId;
  final int accountNumber;
  final bool live;
  final String brokerName;
  final String brokerTitle;
  final String depositCurrency;
  final int traderRegistrationTimestamp;
  final String traderAccountType;
  final int leverage;
  final int balance;
  final bool deleted;
  final String accountStatus;

  Account({
    required this.accountId,
    required this.accountNumber,
    required this.live,
    required this.brokerName,
    required this.brokerTitle,
    required this.depositCurrency,
    required this.traderRegistrationTimestamp,
    required this.traderAccountType,
    required this.leverage,
    required this.balance,
    required this.deleted,
    required this.accountStatus,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountId: json['accountId'],
      accountNumber: json['accountNumber'],
      live: json['live'],
      brokerName: json['brokerName'],
      brokerTitle: json['brokerTitle'],
      depositCurrency: json['depositCurrency'],
      traderRegistrationTimestamp: json['traderRegistrationTimestamp'],
      traderAccountType: json['traderAccountType'],
      leverage: json['leverage'],
      balance: json['balance'],
      deleted: json['deleted'],
      accountStatus: json['accountStatus'],
    );
  }
}
