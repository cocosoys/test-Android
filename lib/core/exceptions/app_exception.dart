// 中文：本文件定义业务异常类型，统一网络、认证、服务端、缓存、参数和超时错误的表达方式。
// English: This file defines domain exception types and standardizes network, auth, server, cache, parameter, and timeout errors.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

/// 自定义异常类
/// 中文：表示 AppException 异常类型，帮助上层代码按业务语义处理错误。
/// English: AppException represents an exception type so upper layers can handle errors by business meaning.
class AppException implements Exception {
  final int? code;
  final String message;
  final dynamic originalError;

  AppException({this.code, required this.message, this.originalError});

  /// 中文：执行 toString 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the toString business step while keeping internal details encapsulated in this module.
  @override
  String toString() => 'AppException(code: $code, message: $message)';
}

/// 网络异常
/// 中文：表示 NetworkException 异常类型，帮助上层代码按业务语义处理错误。
/// English: NetworkException represents an exception type so upper layers can handle errors by business meaning.
class NetworkException extends AppException {
  NetworkException({super.code, super.message = '网络连接失败', super.originalError});
}

/// 认证异常
/// 中文：表示 AuthException 异常类型，帮助上层代码按业务语义处理错误。
/// English: AuthException represents an exception type so upper layers can handle errors by business meaning.
class AuthException extends AppException {
  AuthException({super.code, super.message = '认证失败', super.originalError});
}

/// 服务器异常
/// 中文：表示 ServerException 异常类型，帮助上层代码按业务语义处理错误。
/// English: ServerException represents an exception type so upper layers can handle errors by business meaning.
class ServerException extends AppException {
  ServerException({super.code, super.message = '服务器错误', super.originalError});
}

/// 缓存异常
/// 中文：表示 CacheException 异常类型，帮助上层代码按业务语义处理错误。
/// English: CacheException represents an exception type so upper layers can handle errors by business meaning.
class CacheException extends AppException {
  CacheException({super.code, super.message = '缓存错误', super.originalError});
}

/// 参数异常
/// 中文：表示 ParamsException 异常类型，帮助上层代码按业务语义处理错误。
/// English: ParamsException represents an exception type so upper layers can handle errors by business meaning.
class ParamsException extends AppException {
  ParamsException({super.code, super.message = '参数错误', super.originalError});
}

/// 超时异常
/// 中文：表示 TimeoutException 异常类型，帮助上层代码按业务语义处理错误。
/// English: TimeoutException represents an exception type so upper layers can handle errors by business meaning.
class TimeoutException extends AppException {
  TimeoutException({super.code, super.message = '请求超时', super.originalError});
}
