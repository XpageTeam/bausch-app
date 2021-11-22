// ignore_for_file: avoid_annotating_with_dynamic

import 'package:bausch/static/static_data.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_db_store/dio_cache_interceptor_db_store.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as pp;

class RequestHandler {
  static CookieManager? _cookieManager;
  static CacheStore? _store;
  static bool _storeCreating = false;

  static BuildContext? globalContext;

  // String? _cacheStorePath;

  CacheOptions? cacheOptions;

  Dio? _dio;

  RequestHandler._init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: StaticData.apiUrl,
        connectTimeout: 20000,
        receiveTimeout: 40000,
        // headers: <String, dynamic>{
        // 	if (UserRepository.currentUser != null)
        // 		'token': UserRepository.currentUser!.token,
        // },
      ),
    );

    // ! debugPrint('userToken2: ${UserRepository.currentUser?.token}');
    // print("store: $store");
  }

  factory RequestHandler.setContext(BuildContext context) {
    globalContext ??= context;

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
  }) async {
    //! debugPrint('userToken1: ${UserRepository.currentUser?.token}');

    late Response<T> res;

    if (_dio?.interceptors != null && _dio!.interceptors.isNotEmpty) {
      if (_cookieManager != null) {
        _dio!.interceptors.add(_cookieManager!);
      }
    }

    if (_cookieManager != null) {
      await _cookieManager!.cookieJar
          .loadForRequest(Uri.parse(StaticData.apiUrl + path));
    }

    try {
      res = await _dio!.get(
        path,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
        options: options != null
            ? options.copyWith(
                // headers: <String, dynamic>{
                // 	if (UserRepository.currentUser != null)
                // 		'token': UserRepository.currentUser!.token,
                // },
                )
            : Options(
                // headers: <String, dynamic>{
                // 	if (UserRepository.currentUser != null)
                // 		'token': UserRepository.currentUser!.token,
                // },
                ),
        queryParameters: queryParameters,
      );
    } on DioError catch (e) {
      final result = e.response;

      debugPrint('statusCode: ${result?.statusCode}');

      // TODO(Danil): реализовать логаут пользователя.

      // if (result?.statusCode == 401 && globalContext != null)
      // 	BlocProvider.of<AuthBloc>(globalContext!)
      // 		.add(AuthLogoutRequested("Необходима авторизация"));

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
    //debugPrint(UserRepository.currentUser?.token);

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
        options: options != null
            ? options.copyWith(
                // headers: <String, dynamic>{
                // 	if (UserRepository.currentUser != null)
                // 		'token': UserRepository.currentUser!.token,
                // },
                )
            : Options(
                // headers: <String, dynamic>{
                // 	if (UserRepository.currentUser != null)
                // 		'token': UserRepository.currentUser!.token,
                // },
                ),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioError catch (e) {
      final result = e.response;

      debugPrint('statusCode: ${result?.statusCode}');

      // TODO(Danil): реализовать логаут пользователя.

      // if (result?.statusCode == 401 && globalContext != null)
      // 	BlocProvider.of<AuthBloc>(globalContext!)
      // 		.add(AuthLogoutRequested("Необходима авторизация"));

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

    try {
      return _dio!.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options != null
            ? options.copyWith(
                // headers: <String, dynamic>{
                // 	if (UserRepository.currentUser != null)
                // 		'token': UserRepository.currentUser!.token,
                // },
                )
            : Options(
                // headers: <String, dynamic>{
                // 	if (UserRepository.currentUser != null)
                // 		'token': UserRepository.currentUser!.token,
                // },
                ),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioError catch (e) {
      final result = e.response;

      debugPrint('statusCode: ${result?.statusCode}');

      // TODO(Danil): реализовать логаут пользователя.

      // if (result?.statusCode == 401 && globalContext != null)
      // 	BlocProvider.of<AuthBloc>(globalContext!)
      // 		.add(AuthLogoutRequested("Необходима авторизация"));

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

    try {
      return _dio!.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options != null
            ? options.copyWith(
                // headers: <String, dynamic>{
                // 	if (UserRepository.currentUser != null)
                // 		'token': UserRepository.currentUser!.token,
                // },
                )
            : Options(
                // headers: <String, dynamic>{
                // 	if (UserRepository.currentUser != null)
                // 		'token': UserRepository.currentUser!.token,
                // },
                ),
        cancelToken: cancelToken,
      );
    } on DioError catch (e) {
      final result = e.response;

      debugPrint('statusCode: ${result?.statusCode}');

      // TODO(Danil): реализовать логаут пользователя.

      // if (result?.statusCode == 401 && globalContext != null)
      // 	BlocProvider.of<AuthBloc>(globalContext!)
      // 		.add(AuthLogoutRequested("Необходима авторизация"));

      rethrow;
    }
  }
}
