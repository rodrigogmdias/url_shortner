import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:network/src/dio_provider.dart';
import 'package:network/src/enums/content_encoding.dart';
import 'package:network/src/enums/http_method.dart';

import 'endpoint.dart';
import 'environment.dart';
import 'network_error.dart';
import 'network_request.dart';
import 'network_response.dart';

abstract class NetworkService {
  Future<NetworkResponse<T>> send<T>(
    Endpoint endpoint, {
    T Function(dynamic data)? decoder,
    CancelToken? cancelToken,
    Map<String, String>? extraHeaders,
    Duration? timeout,
  });
}

@LazySingleton(as: NetworkService)
class NetworkServiceImpl implements NetworkService {
  NetworkServiceImpl(this.environment, this._dioProvider);

  final NetworkEnvironment environment;
  final DioProvider _dioProvider;

  @override
  Future<NetworkResponse<T>> send<T>(
    Endpoint endpoint, {
    T Function(dynamic data)? decoder,
    CancelToken? cancelToken,
    Map<String, String>? extraHeaders,
    Duration? timeout,
  }) async {
    final request = NetworkRequest(
      path: endpoint.path,
      method: endpoint.method,
      queryParameters: endpoint.queryParameters,
      body: endpoint.bodyParameters,
      headers: {
        if (endpoint.headers != null) ...endpoint.headers!,
        if (extraHeaders != null) ...extraHeaders,
      },
      contentEncoding: endpoint.contentEncoding,
    );

    try {
      final response = await _performRequest(
        request,
        cancelToken: cancelToken,
        timeout: timeout,
      );

      final decoded = (decoder != null)
          ? decoder(response.data)
          : response.data as T;

      return NetworkResponse<T>(
        data: decoded,
        statusCode: response.statusCode ?? 0,
        headers: response.headers.map.map(
          (key, value) => MapEntry(key, List<String>.from(value)),
        ),
        original: response,
      );
    } on TypeError catch (e) {
      throw NetworkParsingError(endpoint.path, message: e.toString());
    } on DioException catch (e) {
      throw NetworkError.fromDioError(e);
    }
  }

  Future<Response<dynamic>> _performRequest(
    NetworkRequest request, {
    CancelToken? cancelToken,
    Duration? timeout,
  }) async {
    final options = Options(
      method: request.method.name,
      headers: request.headers,
      contentType: _contentType(request.contentEncoding),
    );

    final future = _dioProvider.dio.request<dynamic>(
      request.path,
      data: _encodeBody(request),
      queryParameters: request.queryParameters,
      options: options,
      cancelToken: cancelToken,
    );

    if (timeout != null) {
      return future.timeout(
        timeout,
        onTimeout: () {
          throw NetworkTimeoutError(request.path);
        },
      );
    }
    return future;
  }

  Object? _encodeBody(NetworkRequest request) {
    if (request.method == HttpMethod.get) return null;
    switch (request.contentEncoding) {
      case ContentEncoding.json:
        return request.body;
      case ContentEncoding.formUrlEncoded:
        return FormData.fromMap(request.body ?? <String, dynamic>{});
      case ContentEncoding.none:
        return request.body;
    }
  }

  String? _contentType(ContentEncoding encoding) {
    switch (encoding) {
      case ContentEncoding.json:
        return Headers.jsonContentType;
      case ContentEncoding.formUrlEncoded:
        return Headers.formUrlEncodedContentType;
      case ContentEncoding.none:
        return null;
    }
  }
}
