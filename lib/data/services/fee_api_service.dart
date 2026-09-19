import '../../core/api/api_client.dart';

/// Fee Collection & Ledger API Service.
class FeeApiService {
  final ApiClient _apiClient;

  FeeApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Get student fee ledger balance and transaction history (`GET /api/v1/fees/ledger/`).
  Future<Map<String, dynamic>> getFeeLedger({String? studentId}) async {
    final response = await _apiClient.get(
      '/fees/ledger/',
      queryParameters: {
        if (studentId != null) 'student_id': studentId,
      },
    );
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      return response['data'] is Map<String, dynamic> ? response['data'] : response;
    }
    return response is Map<String, dynamic> ? response : {};
  }

  /// Get detailed fee receipt (`GET /api/v1/fees/receipt/<id>/`).
  Future<Map<String, dynamic>> getFeeReceipt(String receiptId) async {
    final response = await _apiClient.get('/fees/receipt/$receiptId/');
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      return response['data'] is Map<String, dynamic> ? response['data'] : response;
    }
    return response is Map<String, dynamic> ? response : {};
  }
}
