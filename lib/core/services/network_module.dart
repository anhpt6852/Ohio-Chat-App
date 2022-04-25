import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ohio_templates/core/commons/presentation/snack_bar.dart';
import 'package:ohio_templates/core/constant/networks.dart';

final networkModuleProvider =
    Provider.autoDispose<NetworkModule>((ref) => NetworkModule());

class NetworkModule {
  late BaseOptions _baseOptions;

  // dio instance
  Dio get _dio => _initDio();

  NetworkModule() {
    _baseOptions = BaseOptions(
      baseUrl: NetworkConstants.baseUrl,
      connectTimeout: NetworkConstants.connectionTimeout,
      receiveTimeout: NetworkConstants.receiveTimeout,
      contentType: 'application/json',
    );
  }

  void lock() {
    _dio.lock();
  }

  void unlock() {
    _dio.unlock();
  }

  void clearTask() {
    _dio.clear();
  }

  Dio _initDio() {
    final dio = Dio(_baseOptions);

    dio
      // ..interceptors.add(LogInterceptor(
      //   request: true,
      //   responseBody: true,
      //   requestBody: true,
      //   requestHeader: true,
      // ))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (RequestOptions options,
              RequestInterceptorHandler requestInterceptorHandler) async {
            requestInterceptorHandler.next(options);
          },
        ),
      )
      ..interceptors.add(RetryInterceptor(
        dio: dio,
        retries: 3,
        // Number of retries before a failure
        retryDelays: const [
          Duration(seconds: 5),
          Duration(seconds: 5),
          Duration(seconds: 5)
        ],
        // Interval between each retry
        retryEvaluator: (error, int) =>
            error.type != DioErrorType.cancel &&
            error.type !=
                DioErrorType
                    .response, // Evaluating if a retry is necessary regarding the error. It is a good candidate for updating authentication token in case of a unauthorized error (be careful with concurrency though)
      ))
      ..interceptors.add(
        InterceptorsWrapper(onError: (DioError e,
            ErrorInterceptorHandler errorInterceptorHandler) async {
          errorInterceptorHandler.next(e);
        }),
      );

    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        request: true,
        responseBody: true,
        requestBody: true,
        requestHeader: true,
      ));
    }
    if (Platform.isAndroid) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }

    return dio;
  }

  // Get:-----------------------------------------------------------------------
  Future<dynamic> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      print('err Get ${e.toString()}');
      throw e;
    }
  }

  // Post:----------------------------------------------------------------------
  Future<dynamic> post(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      throw e;
    }
  }

  // Put:----------------------------------------------------------------------
  Future<dynamic> put(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      throw e;
    }
  }

  // Put:----------------------------------------------------------------------
  Future<dynamic> delete(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      throw e;
    }
  }
}
