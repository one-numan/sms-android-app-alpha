import '../../core/api/api_client.dart';

/// Fee Collection & Ledger API Service.
class FeeApiService {
  final ApiClient _apiClient;

  FeeApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Get student fee ledger balance and transaction history.
  Future<Map<String, dynamic>> getFeeLedger(String studentId) async {
    final response = await _apiClient.get('/fees/ledger/$studentId');
    return response is Map<String, dynamic> ? response : {};
  }

  /// Process fee collection payment.
  Future<Map<String, dynamic>> collectFeePayment({
    required String studentId,
    required double amount,
    required String paymentMode,
    String? remark,
  }) async {
    final response = await _apiClient.post(
      '/fees/collect',
      body: {
        'student_id': studentId,
        'amount': amount,
        'payment_mode': paymentMode,
        if (remark != null) 'remark': remark,
      },
    );
    return response is Map<String, dynamic> ? response : {'status': 'success'};
  }
}
