import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../storage/token_storage.dart';
import '../session/session_manager.dart';
import 'api_exception.dart';

final Logger _networkLogger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 5,
    lineLength: 90,
    colors: true,
    printEmojis: true,
    printTime: true,
  ),
);

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
    _networkLogger.i('➡️  ${options.method} ${options.uri}');
    _networkLogger.d('Headers: ${options.headers}');
    if (options.data != null) {
      _networkLogger.d('Body: ${options.data}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _networkLogger.i(
      '⬅️  ${response.statusCode} ${response.requestOptions.uri}',
    );
    _networkLogger.d('Response: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _networkLogger.e(
      '⛔ ERROR ${err.response?.statusCode} ${err.requestOptions.uri}',
      error: err,
      stackTrace: err.stackTrace,
    );
    if (err.response?.data != null) {
      _networkLogger.e('Error Data: ${err.response?.data}');
    }
    super.onError(err, handler);
  }
}

class TokenRefreshInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final Dio _dio;
  final SessionManager? _sessionManager;
  final Future<String?> Function()? onRefreshToken;

  TokenRefreshInterceptor({
    required TokenStorage tokenStorage,
    required Dio dio,
    SessionManager? sessionManager,
    this.onRefreshToken,
  }) : _tokenStorage = tokenStorage,
       _dio = dio,
       _sessionManager = sessionManager;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
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
          // Token refresh failed, force logout
          await _sessionManager?.forceLogout();
          return handler.next(err);
        }
      }
      // No refresh callback or refresh returned null, force logout
      await _sessionManager?.forceLogout();
    }
    super.onError(err, handler);
  }
}
