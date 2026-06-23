class Mt5Position {
  final int ticket;
  final String symbol;
  final String direction;
  final double volume;
  final double openPrice;
  final double currentPrice;
  final double? stopLoss;
  final double? takeProfit;
  final double profit;
  final double swap;
  final double commission;
  final DateTime openedAt;
  final String comment;

  const Mt5Position({
    required this.ticket,
    required this.symbol,
    required this.direction,
    required this.volume,
    required this.openPrice,
    required this.currentPrice,
    required this.stopLoss,
    required this.takeProfit,
    required this.profit,
    required this.swap,
    required this.commission,
    required this.openedAt,
    required this.comment,
  });

  factory Mt5Position.fromJson(Map<String, dynamic> json) {
    return Mt5Position(
      ticket: json['ticket'] as int,
      symbol: json['symbol'] as String,
      direction: json['direction'] as String,
      volume: (json['volume'] as num).toDouble(),
      openPrice: (json['open_price'] as num).toDouble(),
      currentPrice: (json['current_price'] as num).toDouble(),
      stopLoss: (json['stop_loss'] as num?)?.toDouble(),
      takeProfit: (json['take_profit'] as num?)?.toDouble(),
      profit: (json['profit'] as num).toDouble(),
      swap: (json['swap'] as num).toDouble(),
      commission: (json['commission'] as num).toDouble(),
      openedAt: DateTime.parse(json['opened_at'] as String),
      comment: json['comment'] as String? ?? '',
    );
  }
}
