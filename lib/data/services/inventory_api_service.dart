import '../../core/api/api_client.dart';

/// Inventory Desk API Service.
class InventoryApiService {
  final ApiClient _apiClient;

  InventoryApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Get inventory catalog items.
  Future<List<dynamic>> getInventoryItems({bool? lowStockOnly}) async {
    try {
      final response = await _apiClient.get(
        '/inventory/desk/',
        queryParameters: {
          if (lowStockOnly == true) 'low_stock_only': 'true',
        },
      );

      if (response is List) return response;
      if (response is Map && response.containsKey('results') && response['results'] is List) {
        return response['results'];
      }
      if (response is Map && response.containsKey('data') && response['data'] is List) {
        return response['data'];
      }
    } catch (_) {
      try {
        final response = await _apiClient.get(
          '/inventory/items',
          queryParameters: {
            if (lowStockOnly == true) 'low_stock': 'true',
          },
        );

        if (response is List) return response;
        if (response is Map && response.containsKey('results') && response['results'] is List) {
          return response['results'];
        }
        if (response is Map && response.containsKey('data') && response['data'] is List) {
          return response['data'];
        }
      } catch (_) {
        return [];
      }
    }
    return [];
  }

  /// Update item stock quantity.
  Future<Map<String, dynamic>> updateStockQuantity(String itemId, int delta) async {
    final response = await _apiClient.patch(
      '/inventory/items/$itemId/stock',
      body: {'delta': delta},
    );
    return response is Map<String, dynamic> ? response : {'status': 'updated'};
  }
}
