import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'api_exception.dart';
import 'token_storage.dart';

/// Core HTTP REST Client for ONPS ERP Alpha.
class ApiClient {
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

  /// Low-level HTTP executor.
  Future<dynamic> _sendRequest(
    String method,
    String endpoint, {
    dynamic body,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    Uri uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
    if (queryParameters != null && queryParameters.isNotEmpty) {
      final stringParams = queryParameters.map((key, value) => MapEntry(key, value.toString()));
      uri = uri.replace(queryParameters: stringParams);
    }

    final token = await TokenStorage.getToken();
    final requestHeaders = ApiConfig.defaultHeaders(token: token);
    if (headers != null) {
      requestHeaders.addAll(headers);
    }

    try {
      late http.Response response;
      final encodedBody = body != null ? jsonEncode(body) : null;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await _client
              .get(uri, headers: requestHeaders)
              .timeout(const Duration(seconds: ApiConfig.connectTimeoutSeconds));
          break;
        case 'POST':
          response = await _client
              .post(uri, headers: requestHeaders, body: encodedBody)
              .timeout(const Duration(seconds: ApiConfig.connectTimeoutSeconds));
          break;
        case 'PUT':
          response = await _client
              .put(uri, headers: requestHeaders, body: encodedBody)
              .timeout(const Duration(seconds: ApiConfig.connectTimeoutSeconds));
          break;
        case 'PATCH':
          response = await _client
              .patch(uri, headers: requestHeaders, body: encodedBody)
              .timeout(const Duration(seconds: ApiConfig.connectTimeoutSeconds));
          break;
        case 'DELETE':
          response = await _client
              .delete(uri, headers: requestHeaders)
              .timeout(const Duration(seconds: ApiConfig.connectTimeoutSeconds));
          break;
        default:
          throw ArgumentError('Unsupported HTTP method: $method');
      }

      return _handleResponse(response);
    } on SocketException catch (e) {
      throw NetworkException('Network connection unavailable: ${e.message}');
    } on http.ClientException catch (e) {
      throw NetworkException('HTTP client error: ${e.message}');
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
        throw const UnauthorizedException();
      case 403:
        throw const ForbiddenException();
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
