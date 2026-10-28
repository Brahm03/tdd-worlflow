import 'dart:convert';
import 'dart:developer' as dev;

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:task_app/core/storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._dio);

  final Dio _dio;

  Future<String?>? _refreshing;
  DateTime? _lastRefreshAt;

  static const String _refreshPath = 'auth/refresh';
  static const String _retriedFlag = 'auth_retried';

  static const Duration _proactiveRefreshWindow = Duration(seconds: 60);
  static const Duration _proactiveRefreshCooldown = Duration(minutes: 10);

  // * Strapi auth endpointlari: auth/local, auth/local/register, auth/refresh ...
  bool _isAuthPath(String path) => path.contains('auth/');

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    print(
        '[AuthInterceptor] [onRequest] Start: ${options.method} ${options.path}');

    if (!_isAuthPath(options.path)) {
      print(
          '[AuthInterceptor] [onRequest] Non-auth route detected. Reading access token...');
      var token = await _readAccessToken();

      if (token != null && token.isNotEmpty) {
        print(
            '[AuthInterceptor] [onRequest] Access token found. Checking proactive expiration...');
        if (_isAboutToExpire(token)) {
          print(
              '[AuthInterceptor] [onRequest] Token expiring soon. Initiating proactive refresh...');
          final refreshed = await _refreshToken();
          if (refreshed != null && refreshed.isNotEmpty) {
            print('[AuthInterceptor] [onRequest] Proactive refresh succeeded.');
            token = refreshed;
          } else {
            print(
                '[AuthInterceptor] [onRequest] Proactive refresh failed or returned null.');
          }
        } else {
          print('[AuthInterceptor] [onRequest] Token is still valid.');
        }
      } else {
        print(
            '[AuthInterceptor] [onRequest] No access token found in storage.');
      }

      if (token != null && token.isNotEmpty) {
        print(
            '[AuthInterceptor] [onRequest] Attaching Bearer token to request headers.');
        options.headers['Authorization'] = 'Bearer $token';
      } else {
        print(
            '[AuthInterceptor] [onRequest] No token available. Clearing Authorization header.');
        options.headers.remove('Authorization');
      }
    } else {
      print(
          '[AuthInterceptor] [onRequest] Auth path detected (${options.path}). Bypassing token injection.');
    }

    print(
        '[AuthInterceptor] [onRequest] Forwarding request to next handler: ${options.path}');
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final alreadyRetried = options.extra[_retriedFlag] == true;

    print(
        '[AuthInterceptor] [onError] Caught error for ${options.path} | Status Code: ${err.response?.statusCode}');

    if (err.response?.statusCode != 401 ||
        alreadyRetried ||
        _isAuthPath(options.path)) {
      print(
          '[AuthInterceptor] [onError] Request is not eligible for 401 refresh retry. Forwarding error.');
      return handler.next(err);
    }

    

    print(
        '[AuthInterceptor] [onError] Handling 401 Unauthorized. Inspecting tokens...');
    final sentToken = _extractBearerToken(options.headers['Authorization']);
    final storedToken = await _readAccessToken();
    final String? newToken;

    if (storedToken != null &&
        storedToken.isNotEmpty &&
        sentToken != null &&
        storedToken != sentToken) {
      print(
          '[AuthInterceptor] [onError] Token in storage differs from sent token. Retrying request with stored token...');
      dev.log(
        '401 on ${options.path} with outdated token — retrying with current token',
        name: 'AuthInterceptor',
      );
      newToken = storedToken;
    } else {
      print(
          '[AuthInterceptor] [onError] Token matches stored token or was missing. Refreshing token...');
      dev.log(
        '401 on ${options.path} — attempting token refresh',
        name: 'AuthInterceptor',
      );
      newToken = await _refreshToken();
    }

    if (newToken == null || newToken.isEmpty) {
      print(
          '[AuthInterceptor] [onError] Refresh yielded no token. Returning original 401 error.');
      dev.log(
        'Refresh failed to yield token — returning original error for ${options.path}',
        name: 'AuthInterceptor',
      );
      return handler.next(err);
    }

    print(
        '[AuthInterceptor] [onError] Updating header with new token and retrying ${options.path}...');
    options.extra[_retriedFlag] = true;
    options.headers['Authorization'] = 'Bearer $newToken';

    try {
      final response = await _dio.fetch<dynamic>(options);
      print(
          '[AuthInterceptor] [onError] Retry request succeeded for ${options.path}');
      dev.log('Retry succeeded for ${options.path}', name: 'AuthInterceptor');
      return handler.resolve(response);
    } on DioException catch (retryError) {
      print(
          '[AuthInterceptor] [onError] Retry failed with DioException: ${retryError.response?.statusCode}');
      dev.log(
        'Retry with refreshed token failed for ${options.path}: ${retryError.response?.statusCode}',
        name: 'AuthInterceptor',
      );
      return handler.next(retryError);
    } catch (e) {
      print(
          '[AuthInterceptor] [onError] Retry failed with unexpected error: $e');
      return handler.next(err);
    }
  }

  Future<String?> _refreshToken() {
    if (_refreshing != null) {
      print(
          '[AuthInterceptor] [_refreshToken] Refresh already in progress. Sharing existing Future.');
    } else {
      print('[AuthInterceptor] [_refreshToken] Spawning new refresh Future.');
    }
    _refreshing ??= _doRefresh().whenComplete(() {
      print(
          '[AuthInterceptor] [_refreshToken] Refresh completed. Clearing active refresh Future.');
      _refreshing = null;
    });
    return _refreshing!;
  }

  Future<String?> _doRefresh() async {
    print(
        '[AuthInterceptor] [_doRefresh] Fetching refresh token from storage...');
    String? refreshToken;
    try {
      refreshToken = await TokenStorage.instance.refreshToken;
      print(
          '[AuthInterceptor] [_doRefresh] Refresh token retrieved: ${refreshToken != null && refreshToken.isNotEmpty ? "SUCCESS" : "EMPTY/NULL"}');
    } catch (e) {
      print('[AuthInterceptor] [_doRefresh] Error reading refresh token: $e');
      dev.log(
        'Error reading refresh_token from storage: $e',
        name: 'AuthInterceptor',
      );
      return null;
    }

    if (refreshToken == null || refreshToken.isEmpty) {
      print(
          '[AuthInterceptor] [_doRefresh] Aborting: No refresh token present.');
      dev.log(
        'Refresh aborted: no refresh_token found',
        name: 'AuthInterceptor',
      );
      if (_isInForeground) {
        print(
            '[AuthInterceptor] [_doRefresh] App in foreground. Clearing TokenStorage...');
        await TokenStorage.instance.clear();
      }
      return null;
    }

    try {
      print(
          '[AuthInterceptor] [_doRefresh] Initializing clean Dio instance for refresh request...');
      final client = Dio(
        BaseOptions(
          baseUrl: _dio.options.baseUrl,
          headers: {'Content-Type': 'application/json'},
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      print(
          '[AuthInterceptor] [_doRefresh] Posting refresh request to $_refreshPath...');
      final response = await _postRefresh(client, refreshToken);
      if (response == null) {
        print(
            '[AuthInterceptor] [_doRefresh] Post refresh returned null response.');
        return null;
      }

      print('[AuthInterceptor] [_doRefresh] Parsing token response payload...');
      final data = _extractTokenContainer(response.data);
      if (data == null) {
        print(
            '[AuthInterceptor] [_doRefresh] Response missing token container.');
        dev.log(
          'Refresh response missing token payload: ${response.data}',
          name: 'AuthInterceptor',
        );
        return null;
      }

      final access = data['jwt']?.toString();
      if (access == null || access.isEmpty) {
        print(
            '[AuthInterceptor] [_doRefresh] No access token found in response payload.');
        dev.log(
          'No access token in response body: ${response.data}',
          name: 'AuthInterceptor',
        );
        return null;
      }

      // * Strapi har refreshda refresh tokenni ham aylantiradi (rotation),
      // * eskisi endi yaroqsiz — yangisini albatta saqlash kerak
      final rotatedRefresh = data['refreshToken']?.toString();
      print(
          '[AuthInterceptor] [_doRefresh] Saving new tokens (rotated refresh: ${rotatedRefresh != null}).');
      await TokenStorage.instance
          .save(accessToken: access, refreshToken: rotatedRefresh);

      _lastRefreshAt = DateTime.now();
      print(
          '[AuthInterceptor] [_doRefresh] Token refresh successful at $_lastRefreshAt');
      dev.log('Token refresh successful', name: 'AuthInterceptor');
      return access;
    } catch (e) {
      print(
          '[AuthInterceptor] [_doRefresh] Unexpected failure during refresh: $e');
      dev.log(
        'Refresh request failed unexpectedly: $e',
        name: 'AuthInterceptor',
      );
      return null;
    }
  }

  Future<Response<dynamic>?> _postRefresh(
    Dio client,
    String refreshToken,
  ) async {
    try {
      // * Strapi: POST /api/auth/refresh  body: { refreshToken }
      final response = await client.post<dynamic>(
        _refreshPath,
        data: {'refreshToken': refreshToken},
      );
      print(
          '[AuthInterceptor] [_postRefresh] Refresh succeeded (Status: ${response.statusCode})');
      return response;
    } on DioException catch (e) {
      final status = e.response?.statusCode ?? 0;
      print(
          '[AuthInterceptor] [_postRefresh] Refresh failed with $status: ${e.response?.data}');
      dev.log('POST $_refreshPath failed: $status', name: 'AuthInterceptor');

      // * 400 = refresh token yo'q, 401 = yaroqsiz/muddati o'tgan -> sessiya tugadi
      if (status == 400 || status == 401 || status == 403) {
        print(
            '[AuthInterceptor] [_postRefresh] Refresh token rejected. Clearing session...');
        await TokenStorage.instance.clear();
      }
      return null;
    }
  }

  Map<String, dynamic>? _extractTokenContainer(dynamic payload) {
    if (payload is! Map || !payload.containsKey('jwt')) return null;
    return Map<String, dynamic>.from(payload);
  }

  Future<String?> _readAccessToken() async {
    try {
      final token = await TokenStorage.instance.accessToken;
      print(
          '[AuthInterceptor] [_readAccessToken] Successfully read token: ${token != null && token.isNotEmpty ? "PRESENT" : "NULL/EMPTY"}');
      return token;
    } catch (e) {
      print('[AuthInterceptor] [_readAccessToken] Error reading token: $e');
      dev.log('Error reading access token: $e', name: 'AuthInterceptor');
      return null;
    }
  }

  bool get _isInForeground =>
      WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;

  bool _isAboutToExpire(String token) {
    final lastRefreshAt = _lastRefreshAt;
    if (lastRefreshAt != null &&
        DateTime.now().difference(lastRefreshAt) < _proactiveRefreshCooldown) {
      print(
          '[AuthInterceptor] [_isAboutToExpire] Cooldown period active. Skipping proactive refresh.');
      return false;
    }
    final expiresAt = _jwtExpiry(token);
    if (expiresAt == null) {
      print(
          '[AuthInterceptor] [_isAboutToExpire] Unable to decode JWT expiry date.');
      return false;
    }

    final durationRemaining = expiresAt.difference(DateTime.now());
    final isExpiring = durationRemaining < _proactiveRefreshWindow;
    print(
        '[AuthInterceptor] [_isAboutToExpire] Token expires in ${durationRemaining.inSeconds}s (Expiring soon: $isExpiring)');
    return isExpiring;
  }

  DateTime? _jwtExpiry(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return null;

    try {
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      final exp = payload is Map ? payload['exp'] : null;
      if (exp is! num) return null;

      return DateTime.fromMillisecondsSinceEpoch(exp.toInt() * 1000);
    } catch (_) {
      return null;
    }
  }

  String? _extractBearerToken(Object? header) {
    final value = header?.toString() ?? '';
    const prefix = 'Bearer ';
    return value.startsWith(prefix) ? value.substring(prefix.length) : null;
  }
}
