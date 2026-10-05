abstract class AppException implements Exception {
  final String message;

  final String? details;

  AppException(this.message, [this.details]);

  @override
  String toString() {
    if (details != null) {
      return '$message: $details';
    }
    return message;
  }
}

class NoInternetException extends AppException {
  NoInternetException([String? details])
      : super('No internet connection', details);
}

class TimeoutException extends AppException {
  TimeoutException([String? details])
      : super('Request timeout', details);
}

class ServerException extends AppException {
  /// HTTP status code (e.g., 404, 500)
  final int? statusCode;

  /// Creates a [ServerException] with a [message], optional [statusCode], and [details].
  ServerException(super.message, [this.statusCode, super.details]);

  @override
  String toString() {
    if (statusCode != null) {
      return 'ServerException ($statusCode): $message${details != null ? ' - $details' : ''}';
    }
    return super.toString();
  }
}

class ParsingException extends AppException {
  ParsingException([String? details])
      : super('Failed to parse data', details);
}

class CacheException extends AppException {
  CacheException([String? details])
      : super('Cache operation failed', details);
}

class NotFoundException extends AppException {
  NotFoundException([String? details])
      : super('Data not found', details);
}

class UnknownException extends AppException {
  UnknownException([String? details])
      : super('An unknown error occurred', details);
}
