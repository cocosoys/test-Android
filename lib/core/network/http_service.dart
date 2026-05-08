// 中文：本文件封装 Dio 网络层，统一请求配置、缓存、Token 注入、错误处理、重试和响应解析。
// English: This file wraps the Dio network layer and standardizes request config, caching, token injection, error handling, retry, and response parsing.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:path_provider/path_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:soys_app/core/constants/env_config.dart';
import 'package:soys_app/core/logger/app_logger.dart';
import 'package:soys_app/models/network/api_response.dart';
import 'package:soys_app/services/storage/storage_service.dart';
import 'package:soys_app/components/toast/app_toast.dart';

/// Token拦截器
/// 中文：承载 TokenInterceptor 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: TokenInterceptor carries its core responsibility and supports the business or UI logic in this file.
class _TokenInterceptor extends Interceptor {
  /// 中文：执行 onRequest 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the onRequest business step while keeping internal details encapsulated in this module.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final storage = Get.find<StorageService>();
    final token = storage.token;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  /// 中文：执行 onResponse 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the onResponse business step while keeping internal details encapsulated in this module.
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  /// 中文：执行 onError 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the onError business step while keeping internal details encapsulated in this module.
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}

/// 错误处理拦截器
/// 中文：承载 ErrorInterceptor 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: ErrorInterceptor carries its core responsibility and supports the business or UI logic in this file.
class _ErrorInterceptor extends Interceptor {
  /// 中文：执行 onError 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the onError business step while keeping internal details encapsulated in this module.
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 可在此处统一上报错误到服务器
    AppLogger.e('HTTP Error: ${err.type} - ${err.message}');
    handler.next(err);
  }
}

/// 网络请求服务
/// 中文：封装 HttpService 对应的跨页面服务能力，避免业务层直接依赖底层实现。
/// English: HttpService encapsulates cross-page service capabilities so feature code does not depend on low-level details directly.
class HttpService extends GetxService {
  late Dio _dio;

  Dio get dio => _dio;

  /// 中文：完成当前对象的初始化流程，确保依赖、监听器或初始数据在使用前准备好。
  /// English: Initializes the current object so dependencies, listeners, or initial data are ready before use.
  Future<HttpService> init() async {
    final baseUrl = Environments.current.baseUrl;

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: Duration(
          milliseconds: Environments.current.connectTimeout,
        ),
        receiveTimeout: Duration(
          milliseconds: Environments.current.receiveTimeout,
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // 缓存拦截器
    if (Environments.current.enableCache) {
      final cacheDir = await getTemporaryDirectory();
      _dio.interceptors.add(
        DioCacheInterceptor(
          options: CacheOptions(
            store: HiveCacheStore(cacheDir.path),
            policy: CachePolicy.refreshForceCache,
            hitCacheOnErrorExcept: [401, 403],
            maxStale: const Duration(days: 7),
            priority: CachePriority.normal,
            cipher: null,
            keyBuilder: CacheOptions.defaultCacheKeyBuilder,
            allowPostMethod: false,
          ),
        ),
      );
    }

    // Token 拦截器
    _dio.interceptors.add(_TokenInterceptor());

    // 日志拦截器
    if (Environments.current.enableLog) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          logPrint: (obj) => AppLogger.d(obj),
        ),
      );
    }

    // 错误处理拦截器
    _dio.interceptors.add(_ErrorInterceptor());

    return this;
  }

  // ========== GET ==========
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    Options? options,
    CancelToken? cancelToken,
    bool showErrorToast = true,
  }) async {
    return _request(
      () => _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      fromJson: fromJson,
      showErrorToast: showErrorToast,
    );
  }

  // ========== POST ==========
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    Options? options,
    CancelToken? cancelToken,
    bool showErrorToast = true,
  }) async {
    return _request(
      () => _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      fromJson: fromJson,
      showErrorToast: showErrorToast,
    );
  }

  // ========== PUT ==========
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    Options? options,
    CancelToken? cancelToken,
    bool showErrorToast = true,
  }) async {
    return _request(
      () => _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      fromJson: fromJson,
      showErrorToast: showErrorToast,
    );
  }

  // ========== DELETE ==========
  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
    Options? options,
    CancelToken? cancelToken,
    bool showErrorToast = true,
  }) async {
    return _request(
      () => _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      fromJson: fromJson,
      showErrorToast: showErrorToast,
    );
  }

  // ========== 上传文件 ==========
  Future<ApiResponse<T>> upload<T>(
    String path, {
    required FormData formData,
    T Function(dynamic)? fromJson,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
    bool showErrorToast = true,
  }) async {
    return _request(
      () => _dio.post(
        path,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      ),
      fromJson: fromJson,
      showErrorToast: showErrorToast,
    );
  }

  // ========== 下载文件 ==========
  /// 中文：调用系统、文件或平台能力，并向业务层返回统一的处理结果。
  /// English: Invokes system, file, or platform capabilities and returns normalized results to feature code.
  Future<String> download(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParameters,
  }) async {
    await _dio.download(
      urlPath,
      savePath,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
      queryParameters: queryParameters,
    );
    return savePath;
  }

  // ========== 核心请求方法 ==========
  Future<ApiResponse<T>> _request<T>(
    /// 中文：执行 Function 对应的业务步骤，并把内部细节封装在当前模块内。
    /// English: Executes the Function business step while keeping internal details encapsulated in this module.
    Future<Response> Function() request, {
    T Function(dynamic)? fromJson,
    bool showErrorToast = true,
  }) async {
    if (Environments.current.useLocalContent) {
      return ApiResponse(
        code: ErrorCode.localOnly,
        message: 'local_environment_no_remote_request',
      );
    }

    try {
      // 网络检测
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity.contains(ConnectivityResult.none)) {
        if (showErrorToast) {
          _showErrorToast('network_error');
        }
        return ApiResponse(
          code: ErrorCode.networkError,
          message: 'network_error'.tr,
        );
      }

      final response = await request();
      final data = response.data;

      if (data is Map<String, dynamic>) {
        final apiResponse = ApiResponse<T>.fromJson(data, fromJson);

        // Token 过期处理
        if (apiResponse.code == ErrorCode.tokenExpired) {
          final refreshed = await _refreshToken();
          if (refreshed) {
            return _request(
              request,
              fromJson: fromJson,
              showErrorToast: showErrorToast,
            );
          } else {
            _handleTokenExpired();
            return ApiResponse(
              code: ErrorCode.tokenExpired,
              message: 'Token expired',
            );
          }
        }

        if (!apiResponse.isSuccess && showErrorToast) {
          _showErrorToast(apiResponse.message);
        }

        return apiResponse;
      }

      return ApiResponse(
        code: ErrorCode.unknown,
        message: 'Invalid response format',
      );
    } on DioException catch (e) {
      final message = _handleDioError(e);
      if (showErrorToast) {
        _showErrorToast(message);
      }
      return ApiResponse(code: _getErrorCode(e), message: message);
    } catch (e) {
      AppLogger.e('Unknown error: $e');
      if (showErrorToast) {
        _showErrorToast('error');
      }
      return ApiResponse(code: ErrorCode.unknown, message: e.toString());
    }
  }

  /// Token 刷新
  /// 中文：加载或刷新当前功能所需数据，并在失败时保留可用的兜底状态。
  /// English: Loads or refreshes data required by this feature and keeps usable fallback state when requests fail.
  Future<bool> _refreshToken() async {
    try {
      final storage = Get.find<StorageService>();
      final refreshToken = storage.refreshToken;
      if (refreshToken == null) return false;

      final response = await _dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
      );

      if (response.data?['code'] == 0) {
        final newToken = response.data['data']['token'] as String?;
        final newRefreshToken =
            response.data['data']['refreshToken'] as String?;
        if (newToken != null) {
          await storage.setToken(newToken);
          if (newRefreshToken != null) {
            await storage.setRefreshToken(newRefreshToken);
          }
          return true;
        }
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Token过期处理
  /// 中文：处理导航、桥接或事件分发动作，统一外部交互入口。
  /// English: Handles navigation, bridge, or event-dispatch actions through a single interaction entry point.
  void _handleTokenExpired() {
    final storage = Get.find<StorageService>();
    storage.clearUserData();
    Get.offAllNamed('/login');
  }

  /// 处理Dio错误
  /// 中文：处理导航、桥接或事件分发动作，统一外部交互入口。
  /// English: Handles navigation, bridge, or event-dispatch actions through a single interaction entry point.
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'timeout';
      case DioExceptionType.connectionError:
        return 'network_error';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        switch (statusCode) {
          case 400:
            return 'params_error';
          case 401:
            return 'Token expired';
          case 403:
            return 'Access denied';
          case 404:
            return 'Resource not found';
          case 500:
            return 'server_error';
          default:
            return 'server_error';
        }
      case DioExceptionType.cancel:
        return 'Request cancelled';
      default:
        return 'error';
    }
  }

  /// 中文：根据当前输入计算并返回调用方需要的派生值。
  /// English: Computes and returns the derived value required by the caller from the current input.
  int _getErrorCode(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ErrorCode.timeout;
      case DioExceptionType.connectionError:
        return ErrorCode.networkError;
      case DioExceptionType.cancel:
        return ErrorCode.cancel;
      default:
        return ErrorCode.unknown;
    }
  }

  /// 中文：执行 showErrorToast 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the showErrorToast business step while keeping internal details encapsulated in this module.
  void _showErrorToast(String message) {
    try {
      AppToast.showError(message.tr);
    } catch (_) {
      // Toast may not be ready during init
    }
  }
}
