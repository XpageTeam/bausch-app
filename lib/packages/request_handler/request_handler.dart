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
  static CookieManager? cookieManager;
  static CacheStore? store;
  static bool storeCreating = false;

  static BuildContext? globalContext;

  String? cacheStorePath;

  Dio? dio;

  CacheOptions? cacheOptions;

  RequestHandler._init() {
    dio = Dio(
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
      if (store == null && !storeCreating) {
        storeCreating = true;

        pp.getApplicationDocumentsDirectory().then((dir) {
          store = DbCacheStore(
            databasePath: dir.path,
            logStatements: true,
            databaseName: 'cache',
          );

          handler.cacheOptions = CacheOptions(
            store: store,
            policy: CachePolicy.noCache,
          );

          handler.dio?.interceptors.add(
            DioCacheInterceptor(options: handler.cacheOptions!),
          );

          cookieManager = CookieManager(
            PersistCookieJar(
              storage: FileStorage(dir.path),
            ),
          );

          handler.dio?.interceptors.add(cookieManager!);

          storeCreating = false;
        });
      } else if (!storeCreating) {
        handler.cacheOptions = CacheOptions(
          store: store,
          policy: CachePolicy.noCache,
        );

        handler.dio?.interceptors.add(
          DioCacheInterceptor(options: handler.cacheOptions!),
        );

        handler.dio?.interceptors.add(cookieManager!);
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
    }

    return handler;
  }

  Future<void> cleanStore() async {
    await store?.clean();
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

    if (dio?.interceptors != null && dio!.interceptors.isNotEmpty) {
      if (cookieManager != null) {
        dio!.interceptors.add(cookieManager!);
      }
    }

    if (cookieManager != null) {
      await cookieManager!.cookieJar
          .loadForRequest(Uri.parse(StaticData.apiUrl + path));
    }

    try {
      res = await dio!.get(
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

    if (cookieManager != null) {
      await cookieManager!.cookieJar
          .loadForRequest(Uri.parse(StaticData.apiUrl + path));
    }

    try {
      res = await dio!.post(
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
    if (cookieManager != null) {
      await cookieManager!.cookieJar
          .loadForRequest(Uri.parse(StaticData.apiUrl + path));
    }

    try {
      return dio!.put(
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
    if (cookieManager != null) {
      await cookieManager!.cookieJar
          .loadForRequest(Uri.parse(StaticData.apiUrl + path));
    }

    try {
      return dio!.delete(
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
