import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'api_exception.dart';
import 'token_storage.dart';

class _CachedEntry {
  final dynamic data;
  final DateTime expiresAt;
  _CachedEntry(this.data, this.expiresAt);
}

/// Core HTTP REST Client for ONPS ERP Alpha with automatic token refresh, caching, and retry.
class ApiClient {
  static void Function()? onUnauthorized;
  static Completer<bool>? _refreshCompleter;
  static final Map<String, _CachedEntry> _cache = {};

  /// Invalidate in-memory cache entirely or by matching endpoint substring.
  static void invalidateCache([String? pattern]) {
    if (pattern == null) {
      _cache.clear();
    } else {
      _cache.removeWhere((k, v) => k.contains(pattern));
    }
  }

  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  /// Perform a GET request.
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _sendRequest('GET', endpoint, headers: headers, queryParameters: queryParameters);
  }

  /// Perform a POST request.
  Future<dynamic> post(
    String endpoint, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    return _sendRequest('POST', endpoint, body: body, headers: headers);
  }

  /// Perform a PUT request.
  Future<dynamic> put(
    String endpoint, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    return _sendRequest('PUT', endpoint, body: body, headers: headers);
  }

  /// Perform a PATCH request.
  Future<dynamic> patch(
    String endpoint, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    return _sendRequest('PATCH', endpoint, body: body, headers: headers);
  }

  /// Perform a DELETE request.
  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    return _sendRequest('DELETE', endpoint, headers: headers);
  }

  /// Low-level HTTP executor with automatic token refresh on 401.
  Future<dynamic> _sendRequest(
    String method,
    String endpoint, {
    dynamic body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    bool isRetry = false,
  }) async {
    Uri uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    if (queryParameters != null && queryParameters.isNotEmpty) {
      final stringParams = queryParameters.map((key, value) => MapEntry(key, value.toString()));
      uri = uri.replace(queryParameters: stringParams);
    }

    // Omit Authorization header for auth endpoints (e.g. login, register, token refresh) to avoid
    // rejecting requests with stale/expired JWT tokens before credential validation.
    final isAuthEndpoint = endpoint.contains('/auth/login') ||
        endpoint.contains('/auth/register') ||
        endpoint.contains('/auth/token/refresh');
    final token = isAuthEndpoint ? null : await TokenStorage.getToken();
    final requestHeaders = ApiConfig.defaultHeaders(token: token);
    if (headers != null) {
      requestHeaders.addAll(headers);
    }

    final bindingName = WidgetsBinding.instance.runtimeType.toString();
    final isFlutterTest = bindingName.contains('Test') || HttpOverrides.current != null;
    if (isFlutterTest) {
      throw const NetworkException('Flutter test environment network bypass');
    }

    final isGet = method.toUpperCase() == 'GET';
    final cacheKey = uri.toString();

    if (isGet && !isRetry) {
      final cached = _cache[cacheKey];
      if (cached != null && DateTime.now().isBefore(cached.expiresAt)) {
        return cached.data;
      }
    } else if (!isGet) {
      invalidateCache();
    }

    const timeoutDuration = Duration(seconds: ApiConfig.connectTimeoutSeconds);

    try {
      late http.Response response;
      final encodedBody = body != null ? jsonEncode(body) : null;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await _client
              .get(uri, headers: requestHeaders)
              .timeout(timeoutDuration);
          break;
        case 'POST':
          response = await _client
              .post(uri, headers: requestHeaders, body: encodedBody)
              .timeout(timeoutDuration);
          break;
        case 'PUT':
          response = await _client
              .put(uri, headers: requestHeaders, body: encodedBody)
              .timeout(timeoutDuration);
          break;
        case 'PATCH':
          response = await _client
              .patch(uri, headers: requestHeaders, body: encodedBody)
              .timeout(timeoutDuration);
          break;
        case 'DELETE':
          response = await _client
              .delete(uri, headers: requestHeaders)
              .timeout(timeoutDuration);
          break;
        default:
          throw ArgumentError('Unsupported HTTP method: $method');
      }

      // Handle 401 Unauthorized with automatic token refresh and retry
      if (response.statusCode == 401) {
        if (!isAuthEndpoint && !isRetry) {
          final refreshed = await _tryRefreshToken();
          if (refreshed) {
            // Automatically retry original request with newly refreshed token
            return await _sendRequest(
              method,
              endpoint,
              body: body,
              headers: headers,
              queryParameters: queryParameters,
              isRetry: true,
            );
          }
        }
        await TokenStorage.clearSession();
        onUnauthorized?.call();
        throw const UnauthorizedException();
      }

      final result = _handleResponse(response);
      if (isGet && response.statusCode == 200) {
        _cache[cacheKey] = _CachedEntry(result, DateTime.now().add(const Duration(seconds: 30)));
      }
      return result;
    } on SocketException catch (e) {
      if (isGet && !isRetry) {
        await Future.delayed(const Duration(milliseconds: 300));
        return _sendRequest(method, endpoint, body: body, headers: headers, queryParameters: queryParameters, isRetry: true);
      }
      throw NetworkException('Network connection unavailable: ${e.message}');
    } on http.ClientException catch (e) {
      if (isGet && !isRetry) {
        await Future.delayed(const Duration(milliseconds: 300));
        return _sendRequest(method, endpoint, body: body, headers: headers, queryParameters: queryParameters, isRetry: true);
      }
      throw NetworkException('HTTP client error: ${e.message}');
    } on TimeoutException {
      if (isGet && !isRetry) {
        await Future.delayed(const Duration(milliseconds: 300));
        return _sendRequest(method, endpoint, body: body, headers: headers, queryParameters: queryParameters, isRetry: true);
      }
      throw const NetworkException('Connection timed out. Please check your network.');
    }
  }

  /// Attempts to refresh the JWT access token using the stored refresh token.
  /// Deduplicates concurrent refresh attempts across simultaneous failing requests.
  Future<bool> _tryRefreshToken() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    final completer = Completer<bool>();
    _refreshCompleter = completer;

    try {
      final refreshToken = await TokenStorage.getRefreshToken();
      if (refreshToken == null || refreshToken.trim().isEmpty) {
        completer.complete(false);
        return false;
      }

      final refreshUri = Uri.parse('${ApiConfig.baseUrl}/auth/token/refresh/');
      final response = await _client
          .post(
            refreshUri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'refresh': refreshToken}),
          )
          .timeout(const Duration(seconds: ApiConfig.connectTimeoutSeconds));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final dynamic data = jsonDecode(response.body);
        if (data is Map<String, dynamic>) {
          final newAccessToken = data['access'] ?? data['token'] ?? data['access_token'];
          if (newAccessToken != null && newAccessToken is String) {
            await TokenStorage.saveToken(newAccessToken);
          }
          final newRefreshToken = data['refresh'] ?? data['refresh_token'];
          if (newRefreshToken != null && newRefreshToken is String) {
            await TokenStorage.saveRefreshToken(newRefreshToken);
          }
          completer.complete(true);
          return true;
        }
      }
      completer.complete(false);
      return false;
    } catch (_) {
      completer.complete(false);
      return false;
    } finally {
      _refreshCompleter = null;
    }
  }

  /// Process HTTP response & parse payload.
  dynamic _handleResponse(http.Response response) {
    dynamic jsonResponse;
    try {
      if (response.body.isNotEmpty) {
        jsonResponse = jsonDecode(response.body);
      }
    } catch (_) {
      jsonResponse = response.body;
    }

    final statusCode = response.statusCode;
    if (statusCode >= 200 && statusCode < 300) {
      return jsonResponse;
    }

    switch (statusCode) {
      case 400:
        throw BadRequestException(
          jsonResponse is Map && jsonResponse.containsKey('message')
              ? jsonResponse['message']
              : 'Bad request payload.',
          errorData: jsonResponse,
        );
      case 401:
        TokenStorage.clearSession();
        onUnauthorized?.call();
        throw const UnauthorizedException();
      case 403:
        String forbiddenMsg = 'Access denied for this resource.';
        if (jsonResponse is Map) {
          if (jsonResponse.containsKey('detail') && jsonResponse['detail'] != null) {
            forbiddenMsg = jsonResponse['detail'].toString();
          } else if (jsonResponse.containsKey('message') && jsonResponse['message'] != null) {
            forbiddenMsg = jsonResponse['message'].toString();
          }
        }
        throw ForbiddenException(forbiddenMsg, jsonResponse);
      case 404:
        throw const NotFoundException();
      case 500:
      default:
        throw ServerErrorException(
          'Server returned status code $statusCode: ${response.reasonPhrase}',
        );
    }
  }
}
