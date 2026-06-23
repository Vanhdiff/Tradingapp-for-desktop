import '../../../../app/services/api/api_client.dart';
import '../../domain/entities/mt5_account.dart';
import '../../domain/entities/mt5_candle.dart';
import '../../domain/entities/mt5_performance_summary.dart';
import '../../domain/entities/mt5_position.dart';

class Mt5RemoteDataSource {
  final ApiClient _apiClient;

  Mt5RemoteDataSource({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<bool> isConnected() async {
    final response =
        await _apiClient.getJson('/mt5/status') as Map<String, dynamic>;
    return response['connected'] as bool? ?? false;
  }

  Future<Mt5Account> fetchAccount() async {
    final response =
        await _apiClient.getJson('/mt5/account') as Map<String, dynamic>;
    return Mt5Account.fromJson(response);
  }

  Future<List<Mt5Position>> fetchPositions() async {
    final response =
        await _apiClient.getJson('/mt5/positions') as List<dynamic>;
    return response
        .map((item) => Mt5Position.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<Mt5Candle>> fetchCandles({
    required String symbol,
    String timeframe = 'M15',
    int limit = 100,
  }) async {
    final response =
        await _apiClient.getJson(
              '/mt5/candles',
              queryParameters: {
                'symbol': symbol,
                'timeframe': timeframe,
                'limit': '$limit',
              },
            )
            as List<dynamic>;

    return response
        .map((item) => Mt5Candle.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Mt5PerformanceSummary> fetchPerformanceSummary({
    String period = 'month',
  }) async {
    final response =
        await _apiClient.getJson(
              '/mt5/analytics/summary',
              queryParameters: {'period': period},
            )
            as Map<String, dynamic>;
    return Mt5PerformanceSummary.fromJson(response);
  }
}
