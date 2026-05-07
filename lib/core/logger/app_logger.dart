// 中文：本文件封装日志输出入口，统一调试、信息、警告、错误和详细日志的打印方式。
// English: This file wraps logging entry points and standardizes debug, info, warning, error, and verbose output.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:logger/logger.dart';

/// 日志工具
/// 中文：承载 AppLogger 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: AppLogger carries its core responsibility and supports the business or UI logic in this file.
class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  static void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  /// 上报错误到服务器
  static Future<void> reportError(
    dynamic error,
    StackTrace? stackTrace, {
    Map<String, dynamic>? extra,
  }) async {
    if (extra != null && extra.isNotEmpty) {
      _logger.e('Report Error Extra: $extra');
    }
    e('Report Error: $error', error, stackTrace);
  }
}
