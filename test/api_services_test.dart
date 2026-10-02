import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_android_app_alpha/data/services/api_services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('ApiConfig Tests', () {
    test('default headers include JSON and App Client header', () {
      final headers = ApiConfig.defaultHeaders();
      expect(headers['Content-Type'], equals('application/json'));
      expect(headers['X-App-Client'], equals('ONPS-Android-ERP-Alpha'));
      expect(headers.containsKey('Authorization'), isFalse);
    });

    test('default headers include Bearer token when provided', () {
      final headers = ApiConfig.defaultHeaders(token: 'mock_jwt_token_123');
      expect(headers['Authorization'], equals('Bearer mock_jwt_token_123'));
    });
  });

  group('TokenStorage Tests', () {
    test('saves and retrieves access token', () async {
      await TokenStorage.saveToken('test_access_token');
      final token = await TokenStorage.getToken();
      expect(token, equals('test_access_token'));
    });

    test('saves and retrieves refresh token', () async {
      await TokenStorage.saveRefreshToken('test_refresh_token');
      final refreshToken = await TokenStorage.getRefreshToken();
      expect(refreshToken, equals('test_refresh_token'));
    });

    test('clears session tokens', () async {
      await TokenStorage.saveToken('test_access_token');
      await TokenStorage.saveRefreshToken('test_refresh_token');
      await TokenStorage.clearSession();

      final token = await TokenStorage.getToken();
      final refreshToken = await TokenStorage.getRefreshToken();
      expect(token, isNull);
      expect(refreshToken, isNull);
    });
  });

  group('ApiException Tests', () {
    test('UnauthorizedException has status code 401', () {
      const ex = UnauthorizedException('Session expired');
      expect(ex.statusCode, equals(401));
      expect(ex.message, equals('Session expired'));
    });

    test('BadRequestException formats message properly', () {
      const ex = BadRequestException('Invalid email');
      expect(ex.statusCode, equals(400));
      expect(ex.message, equals('Invalid email'));
    });
  });

  group('AuthApiService Refresh Tests', () {
    test('refreshToken throws UnauthorizedException if no refresh token exists', () async {
      await TokenStorage.clearSession();
      final service = AuthApiService();
      expect(() => service.refreshToken(), throwsA(isA<UnauthorizedException>()));
    });
  });

  group('AttendanceApiService Roll Call Tests', () {
    test('getClassAttendance handles parameters and returns empty map on offline/error', () async {
      final service = AttendanceApiService();
      final result = await service.getClassAttendance(classId: 'CLS-1', date: '2026-09-29');
      expect(result, isA<Map<String, dynamic>>());
    });
  });
}

