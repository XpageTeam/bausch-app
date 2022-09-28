// ignore_for_file: avoid_annotating_with_dynamic

import 'dart:async';
import 'dart:io';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:bausch/global/authentication/auth_wm.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_db_store/dio_cache_interceptor_db_store.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:provider/provider.dart';

class RequestHandler {
  static BuildContext? globalContext;

  static UserWM? _userWM;
  static CookieManager? _cookieManager;
  static CacheStore? _store;
  static bool _storeCreating = false;

  // String? _cacheStorePath;

  CacheOptions? cacheOptions;

  Dio? _dio;

  RequestHandler._init() {
    _dio = _createDio();
  }

  factory RequestHandler.setContext(BuildContext context) {
    globalContext ??= context;

    try {
      _userWM ??= Provider.of<UserWM>(context);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      debugPrint('Неудалось получить UserWM в RequestHandler');
    }

    return RequestHandler();
  }

  // ignore: member-ordering-extended
  factory RequestHandler() {
    final handler = RequestHandler._init();

    try {
      if (_store == null && !_storeCreating) {
        _storeCreating = true;

        pp.getApplicationDocumentsDirectory().then((dir) {
          _store = DbCacheStore(
            databasePath: dir.path,
            logStatements: true,
            databaseName: 'cache',
          );

          handler.cacheOptions = CacheOptions(
            store: _store,
            policy: CachePolicy.noCache,
          );

          handler._dio?.interceptors.add(
            DioCacheInterceptor(options: handler.cacheOptions!),
          );

          _cookieManager = CookieManager(
            PersistCookieJar(
              storage: FileStorage(dir.path),
            ),
          );

          handler._dio?.interceptors.add(_cookieManager!);

          _storeCreating = false;
        });
      } else if (!_storeCreating) {
        handler.cacheOptions = CacheOptions(
          store: _store,
          policy: CachePolicy.noCache,
        );

        handler._dio?.interceptors.add(
          DioCacheInterceptor(options: handler.cacheOptions!),
        );

        handler._dio?.interceptors.add(_cookieManager!);
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }

    return handler;
  }

  Future<void> cleanStore() async {
    await _store?.clean();
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
    bool withApiUrl = true,
  }) async {
    AppsflyerSdk? appsFlyer;

    if (globalContext != null) {
      appsFlyer = Provider.of<AppsflyerSdk>(globalContext!, listen: false);
    }

    late Response<T> res;

    if (_dio?.interceptors != null && _dio!.interceptors.isNotEmpty) {
      if (_cookieManager != null) {
        _dio!.interceptors.add(_cookieManager!);
      }
    }

    if (_cookieManager != null) {
      await _cookieManager!.cookieJar.loadForRequest(
        Uri.parse(
          withApiUrl ? StaticData.apiUrl + path : path,
        ),
      );
    }

    debugPrint('userToken ${_userWM?.userData.value.data?.user.token}');

    try {
      res = await _dio!.get(
        path,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: _getOptions(options),
        queryParameters: queryParameters,
      );
    } on DioError catch (e) {
      final result = e.response;

      debugPrint('statusCode get ($path): ${result?.statusCode}');

      if ((result?.statusCode == 401 || result?.statusCode == 403) &&
          globalContext != null) {
        Provider.of<AuthWM>(globalContext!, listen: false).logout();
      }

      late Map<String, dynamic> params;

      if (queryParameters != null) {
        params = queryParameters..addAll(<String, dynamic>{'url': path});
      } else {
        params = <String, dynamic>{'url': path};
      }

      if (result?.statusCode == 404) {
        unawaited(appsFlyer?.logEvent('404', params));
      }

      if (result?.statusCode.toString()[0] == '5') {
        unawaited(appsFlyer?.logEvent('serverError', params));
      }

      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.other ||
          e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.sendTimeout) {
        params.addAll(<String, dynamic>{
          'errorType': e.type.toString(),
        });

        unawaited(
          appsFlyer?.logEvent('connectionError', params),
        );
      }

      rethrow;
    }

    return res;
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    AppsflyerSdk? appsFlyer;

    if (globalContext != null) {
      appsFlyer = Provider.of<AppsflyerSdk>(globalContext!, listen: false);
    }

    late Response<T> res;

    if (_cookieManager != null) {
      await _cookieManager!.cookieJar
          .loadForRequest(Uri.parse(StaticData.apiUrl + path));
    }

    try {
      res = await _dio!.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _getOptions(options),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioError catch (e) {
      final result = e.response;

      debugPrint('statusCode post ($path): ${result?.statusCode}');

      if ((result?.statusCode == 401 || result?.statusCode == 403) &&
          globalContext != null) {
        Provider.of<AuthWM>(globalContext!, listen: false).logout();
      }

      late Map<String, dynamic> params;

      if (queryParameters != null) {
        params = queryParameters..addAll(<String, dynamic>{'url': path});
      } else {
        params = <String, dynamic>{'url': path};
      }

      if (result?.statusCode == 404) {
        unawaited(appsFlyer?.logEvent('404', params));
      }

      if (result?.statusCode.toString()[0] == '5') {
        unawaited(appsFlyer?.logEvent('serverError', params));
      }

      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.other ||
          e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.sendTimeout) {
        params.addAll(<String, dynamic>{
          'errorType': e.type.toString(),
        });

        unawaited(
          appsFlyer?.logEvent('connectionError', params),
        );
      }

      rethrow;
    }

    return res;
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    if (_cookieManager != null) {
      await _cookieManager!.cookieJar
          .loadForRequest(Uri.parse(StaticData.apiUrl + path));
    }

    AppsflyerSdk? appsFlyer;

    if (globalContext != null) {
      appsFlyer = Provider.of<AppsflyerSdk>(globalContext!, listen: false);
    }

    try {
      return _dio!.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _getOptions(options),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioError catch (e) {
      final result = e.response;

      debugPrint('statusCode put ($path): ${result?.statusCode}');

      if ((result?.statusCode == 401 || result?.statusCode == 403) &&
          globalContext != null) {
        Provider.of<AuthWM>(globalContext!, listen: false).logout();
      }

      late Map<String, dynamic> params;

      if (queryParameters != null) {
        params = queryParameters..addAll(<String, dynamic>{'url': path});
      } else {
        params = <String, dynamic>{'url': path};
      }

      if (result?.statusCode == 404) {
        unawaited(appsFlyer?.logEvent('404', params));
      }

      if (result?.statusCode.toString()[0] == '5') {
        unawaited(appsFlyer?.logEvent('serverError', params));
      }

      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.other ||
          e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.sendTimeout) {
        params.addAll(<String, dynamic>{
          'errorType': e.type.toString(),
        });

        unawaited(
          appsFlyer?.logEvent('connectionError', params),
        );
      }

      rethrow;
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    if (_cookieManager != null) {
      await _cookieManager!.cookieJar
          .loadForRequest(Uri.parse(StaticData.apiUrl + path));
    }

    AppsflyerSdk? appsFlyer;

    if (globalContext != null) {
      appsFlyer = Provider.of<AppsflyerSdk>(globalContext!, listen: false);
    }

    try {
      return _dio!.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _getOptions(options),
        cancelToken: cancelToken,
      );
    } on DioError catch (e) {
      final result = e.response;

      debugPrint('statusCode delete ($path): ${result?.statusCode}');

      if ((result?.statusCode == 401 || result?.statusCode == 403) &&
          globalContext != null) {
        Provider.of<AuthWM>(globalContext!, listen: false).logout();
      }

      late Map<String, dynamic> params;

      if (queryParameters != null) {
        params = queryParameters..addAll(<String, dynamic>{'url': path});
      } else {
        params = <String, dynamic>{'url': path};
      }

      if (result?.statusCode == 404) {
        unawaited(appsFlyer?.logEvent('404', params));
      }

      if (result?.statusCode.toString()[0] == '5') {
        unawaited(appsFlyer?.logEvent('serverError', params));
      }

      if (e.type == DioErrorType.connectTimeout ||
          e.type == DioErrorType.other ||
          e.type == DioErrorType.receiveTimeout ||
          e.type == DioErrorType.sendTimeout) {
        params.addAll(<String, dynamic>{
          'errorType': e.type.toString(),
        });

        unawaited(
          appsFlyer?.logEvent('connectionError', params),
        );
      }

      rethrow;
    }
  }

  Options? _getOptions(Options? options) {
    return options != null
        ? options.copyWith(
            headers: options.headers != null
                ? (options.headers!
                  ..addAll(
                    <String, dynamic>{
                      'x-api-key': options.headers!.containsKey('x-api-key')
                          ? options.headers!['x-api-key']
                          : _userWM?.userData.value.data?.user.token ?? '',
                      'is-ios': options.headers!.containsKey('is-ios')
                          ? options.headers!['is-ios']
                          : Platform.isIOS.toString(),
                    },
                  ))
                : <String, dynamic>{
                    'x-api-key': _userWM?.userData.value.data?.user.token ?? '',
                    'is-ios': Platform.isIOS.toString(),
                  },
          )
        : Options(
            headers: <String, dynamic>{
              if (_userWM?.userData.value.data?.user.token != null)
                'x-api-key': _userWM?.userData.value.data?.user.token,
              'is-ios': Platform.isIOS.toString(),
            },
          );
  }

  Dio _createDio() {
    return Dio(
      BaseOptions(
        baseUrl: StaticData.apiUrl,
        connectTimeout: 20000,
        receiveTimeout: 40000,
      ),
    );
  }
}
