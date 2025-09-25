import 'package:dio/dio.dart';

sealed class NetworkError implements Exception {
  NetworkError(this.path, {this.message});
  final String path;
  final String? message;

  @override
  String toString() =>
      '${runtimeType.toString()}(path: $path, message: $message)';

  factory NetworkError.fromDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkTimeoutError(e.requestOptions.path);
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        return HttpStatusError(
          path: e.requestOptions.path,
          statusCode: statusCode,
          message: 'HTTP $statusCode',
          body: e.response?.data,
        );
      case DioExceptionType.cancel:
        return RequestCancelledError(e.requestOptions.path);
      case DioExceptionType.unknown:
      case DioExceptionType.badCertificate:
      case DioExceptionType.connectionError:
        return NetworkConnectionError(
          e.requestOptions.path,
          message: e.message,
        );
    }
  }
}

class NetworkParsingError extends NetworkError {
  NetworkParsingError(super.path, {String? message})
    : super(message: message ?? 'Parsing error');
}

class NetworkTimeoutError extends NetworkError {
  NetworkTimeoutError(super.path) : super(message: 'Request timeout');
}

class NetworkConnectionError extends NetworkError {
  NetworkConnectionError(super.path, {String? message})
    : super(message: message ?? 'Connection error');
}

class RequestCancelledError extends NetworkError {
  RequestCancelledError(super.path) : super(message: 'Request cancelled');
}

class HttpStatusError extends NetworkError {
  HttpStatusError({
    required String path,
    required this.statusCode,
    this.body,
    String? message,
  }) : super(path, message: message ?? 'HTTP status $statusCode');

  final int statusCode;
  final dynamic body;
  bool get isClientError => statusCode >= 400 && statusCode < 500;
  bool get isServerError => statusCode >= 500;
}
