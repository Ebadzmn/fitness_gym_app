import 'dart:developer';
import 'package:dio/dio.dart';
import '../storage/token_storage.dart';
import 'api_exception.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;

  AuthInterceptor(this._tokenStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('--> ${options.method} ${options.uri}');
    log('Headers: ${options.headers}');
    if (options.data != null) {
      log('Body: ${options.data}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('<-- ${response.statusCode} ${response.requestOptions.uri}');
    log('Response: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('<-- ERROR ${err.response?.statusCode} ${err.requestOptions.uri}');
    log('Message: ${err.message}');
    if (err.response?.data != null) {
      log('Error Data: ${err.response?.data}');
    }
    super.onError(err, handler);
  }
}

class TokenRefreshInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final Dio _dio;
  final Future<String?> Function()? onRefreshToken;

  TokenRefreshInterceptor({
    required TokenStorage tokenStorage,
    required Dio dio,
    this.onRefreshToken,
  })  : _tokenStorage = tokenStorage,
        _dio = dio;

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      if (onRefreshToken != null) {
        try {
          final newToken = await onRefreshToken!();
          if (newToken != null) {
            // Retry the original request with the new token
            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $newToken';
            
            final response = await _dio.fetch(options);
            return handler.resolve(response);
          }
        } catch (e) {
          return handler.next(err);
        }
      }
    }
    super.onError(err, handler);
  }
}
