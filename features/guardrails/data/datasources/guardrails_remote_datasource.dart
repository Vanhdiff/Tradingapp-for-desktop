import '../../../../app/services/api/api_client.dart';

class GuardrailsRemoteDataSource {
  final ApiClient _apiClient;

  GuardrailsRemoteDataSource({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<Map<String, dynamic>> fetchStatus({required int accountId}) async {
    final response = await _apiClient.getJson(
      '/guardrails/status',
      queryParameters: {'account_id': '$accountId'},
    );
    return response as Map<String, dynamic>;
  }

  Future<void> saveSettings({
    required int accountId,
    required int maxTradesPerDay,
    required double maxDailyLoss,
    required double maxDailyProfit,
    required double fixedRiskPercent,
    required String tradingWindowStart,
    required String tradingWindowEnd,
    required String newsBlockMode,
    required int newsWindowMinutes,
    required bool blockHighImpactNews,
  }) async {
    await _apiClient.patchJson(
      '/guardrails/settings',
      {
        'max_trades_per_day': maxTradesPerDay,
        'max_daily_loss': maxDailyLoss,
        'block_high_impact_news': blockHighImpactNews,
        'trading_window_start': tradingWindowStart,
        'trading_window_end': tradingWindowEnd,
        'enabled': true,
        'settings': {
          'max_daily_profit': maxDailyProfit,
          'fixed_risk_percent': fixedRiskPercent,
          'news_block_mode': newsBlockMode,
          'news_window_minutes_before': newsWindowMinutes,
          'news_window_minutes_after': newsWindowMinutes,
          'risk_auto_adjust': true,
          'source': 'flutter_guardrails_dialog',
        },
      },
      queryParameters: {'account_id': '$accountId'},
    );
  }
}
