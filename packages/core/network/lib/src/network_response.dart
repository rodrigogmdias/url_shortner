import 'package:dio/dio.dart';

class NetworkResponse<T> {
  NetworkResponse({
    required this.data,
    required this.statusCode,
    required this.headers,
    required this.original,
  });

  final T data;
  final int statusCode;
  final Map<String, List<String>> headers;
  final Response original; // underlying Dio response (for advanced cases)
  bool get isSuccess => statusCode >= 200 && statusCode < 300;
}
