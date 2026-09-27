/// Configuration file for ONPS ERP Backend API integration.
class ApiConfig {
  /// Base URL for the running backend server.
  /// Local backend running on: `http://127.0.0.1:8000/api/v1` via adb reverse
  static String baseUrl = 'http://127.0.0.1:8000/api/v1';

  /// Connection timeout in seconds.
  static const int connectTimeoutSeconds = 45;

  /// Receive timeout in seconds.
  static const int receiveTimeoutSeconds = 45;

  /// Whether to fall back to mock data if the backend server is unreachable.
  /// Set to false in production mode to prevent mock data leakage.
  static bool useMockFallback = false;

  /// Default headers sent with JSON API requests.
  static Map<String, String> defaultHeaders({String? token}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-App-Client': 'ONPS-Android-ERP-Alpha',
      'User-Agent': 'ONPS-Android-ERP-Alpha/1.0.0 (Android 16; RMX5004)',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }
}
