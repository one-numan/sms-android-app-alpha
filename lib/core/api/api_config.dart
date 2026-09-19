/// Configuration file for ONPS ERP Backend API integration.
class ApiConfig {
  /// Base URL for the running backend server.
  /// Live server running on: `http://127.0.0.1:8000/api/v1`
  /// For Android Emulator testing, use `http://10.0.2.2:8000/api/v1`.
  static String baseUrl = 'http://127.0.0.1:8000/api/v1';

  /// Connection timeout in seconds.
  static const int connectTimeoutSeconds = 15;

  /// Receive timeout in seconds.
  static const int receiveTimeoutSeconds = 15;

  /// Whether to fall back to mock data if the backend server is unreachable.
  static bool useMockFallback = true;

  /// Default headers sent with JSON API requests.
  static Map<String, String> defaultHeaders({String? token}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-App-Client': 'ONPS-Android-ERP-Alpha',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }
}
