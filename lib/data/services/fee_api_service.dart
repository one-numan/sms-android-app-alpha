import '../../core/api/api_client.dart';
import '../../models/models.dart';

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

  /// Get detailed fee receipt (`GET /api/v1/fees/receipt/<id>/` or `/fees/receipts/<id>/`).
  Future<FeePayment?> getFeeReceipt(String receiptId) async {
    try {
      dynamic response;
      try {
        response = await _apiClient.get('/fees/receipt/$receiptId/');
      } catch (_) {
        response = await _apiClient.get('/fees/receipts/$receiptId/');
      }
      if (response == null || (response is Map && response.isEmpty)) {
        try {
          response = await _apiClient.get('/fees/receipts/$receiptId/');
        } catch (_) {}
      }
      if (response is Map<String, dynamic>) {
        final data = response.containsKey('data') && response['data'] is Map<String, dynamic>
            ? response['data'] as Map<String, dynamic>
            : response;
        if (data.isNotEmpty) {
          return FeePayment.fromJson(data);
        }
      }
    } catch (_) {}
    return null;
  }
}

