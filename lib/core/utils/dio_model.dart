import 'dart:developer' as dev;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:task_app/core/utils/auth_interceptor.dart';

class DioModule {
  // * Bitta umumiy Dio — aks holda har so'rovda yangi AuthInterceptor yaratilib,
  // * parallel so'rovlar bir vaqtda refresh qiladi va rotation sabab sessiya o'chadi
  static final Dio _instance = _create();

  Dio dio() => _instance;

  static Dio _create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'http://localhost:1337/api/',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(AuthInterceptor(dio));

    if (kDebugMode) {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            dev.log(
              '➡️ [${options.method}] ${options.uri}\n'
              'Headers: ${options.headers}\n'
              'Query: ${options.queryParameters}\n'
              'Body: ${options.data}',
              name: 'Network.Request',
            );
            return handler.next(options);
          },
          onResponse: (response, handler) {
            dev.log(
              '⬅️ [${response.statusCode}] ${response.requestOptions.uri}\n'
              'Response: ${response.data}',
              name: 'Network.Response',
            );
            return handler.next(response);
          },
          onError: (error, handler) {
            dev.log(
              '❌ [${error.response?.statusCode ?? 'NO STATUS'}] ${error.requestOptions.uri}\n'
              'Message: ${error.message}\n'
              'Response: ${error.response?.data}',
              name: 'Network.Error',
              error: error,
            );
            return handler.next(error);
          },
        ),
      );
    }

    return dio;
  }
}

/// Utility class for resolving backend media & avatar relative paths into valid URLs.
abstract final class MediaUrlResolver {
  static const String baseMediaUrl = 'https://api-v2.wordmate.uz/';
  static const String baseImageUrl = '${baseMediaUrl}media/avatars/';

  /// Resolves word/quiz content images against the media host.
  static String? resolveContentImageUrl(String? url) {
    final value = url?.trim() ?? '';
    if (value.isEmpty) return null;
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }

    final filename = value.split('/').last;
    return '${baseMediaUrl}media/$filename';
  }

  /// Resolves audio assets to full valid URLs.
  static String? resolveContentAudioUrl(String? url) {
    final value = url?.trim() ?? '';
    if (value.isEmpty) return null;
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }

    final normalized = value.startsWith('/') ? value.substring(1) : value;
    return '$baseMediaUrl$normalized';
  }

  /// Resolves user profile avatar paths and strips default avatar placeholders.
  static String? resolveAvatarUrl(String? rawAvatar) {
    final avatar = rawAvatar?.trim() ?? '';
    if (avatar.isEmpty || _isDefaultAvatarPath(avatar)) {
      return null;
    }

    if (avatar.startsWith('http://') || avatar.startsWith('https://')) {
      return avatar;
    }

    var normalized = avatar.replaceFirst(RegExp(r'^/+'), '');
    if (normalized.startsWith('media/avatars/')) {
      normalized = normalized.substring('media/avatars/'.length);
    } else if (normalized.startsWith('avatars/')) {
      normalized = normalized.substring('avatars/'.length);
    } else if (normalized.startsWith('media/')) {
      return Uri.parse(baseMediaUrl).resolve(normalized).toString();
    }

    return Uri.parse(baseImageUrl).resolve(normalized).toString();
  }

  static bool _isDefaultAvatarPath(String avatar) {
    final normalized = avatar.toLowerCase().replaceAll('\\', '/');
    return normalized.endsWith('/images/default.png') ||
        normalized.endsWith('images/default.png');
  }
}
