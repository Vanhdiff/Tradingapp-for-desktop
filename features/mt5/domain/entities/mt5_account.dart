class Mt5Account {
  final int login;
  final String server;
  final String currency;
  final double balance;
  final double equity;
  final double margin;
  final double freeMargin;
  final double marginLevel;
  final int leverage;
  final double profit;

  const Mt5Account({
    required this.login,
    required this.server,
    required this.currency,
    required this.balance,
    required this.equity,
    required this.margin,
    required this.freeMargin,
    required this.marginLevel,
    required this.leverage,
    required this.profit,
  });

  factory Mt5Account.fromJson(Map<String, dynamic> json) {
    return Mt5Account(
      login: json['login'] as int,
      server: json['server'] as String,
      currency: json['currency'] as String,
      balance: (json['balance'] as num).toDouble(),
      equity: (json['equity'] as num).toDouble(),
      margin: (json['margin'] as num).toDouble(),
      freeMargin: (json['free_margin'] as num).toDouble(),
      marginLevel: (json['margin_level'] as num).toDouble(),
      leverage: json['leverage'] as int,
      profit: (json['profit'] as num).toDouble(),
    );
  }
}
