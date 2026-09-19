/// Custom Exception hierarchy for API interactions.
abstract class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic errorData;

  const ApiException(this.message, {this.statusCode, this.errorData});

  @override
  String toString() => 'ApiException [$statusCode]: $message';
}

/// Thrown when there is no network connection or the request times out.
class NetworkException extends ApiException {
  const NetworkException(super.message, {super.statusCode, super.errorData});
}

/// Thrown on HTTP 401 Unauthorized errors (invalid or expired token).
class UnauthorizedException extends ApiException {
  const UnauthorizedException([super.message = 'Unauthorized session. Please log in again.'])
      : super(statusCode: 401);
}

/// Thrown on HTTP 403 Forbidden errors.
class ForbiddenException extends ApiException {
  const ForbiddenException([super.message = 'Access denied for this resource.'])
      : super(statusCode: 403);
}

/// Thrown on HTTP 404 Resource Not Found errors.
class NotFoundException extends ApiException {
  const NotFoundException([super.message = 'The requested resource was not found.'])
      : super(statusCode: 404);
}

/// Thrown on HTTP 422 / 400 Validation errors.
class BadRequestException extends ApiException {
  const BadRequestException(super.message, {super.errorData})
      : super(statusCode: 400);
}

/// Thrown on HTTP 500 Server errors.
class ServerErrorException extends ApiException {
  const ServerErrorException([super.message = 'An internal server error occurred.'])
      : super(statusCode: 500);
}
