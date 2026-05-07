// 中文：本文件封装通用工具函数，统一时间、金额、手机号、邮箱、URL 和剪贴板等基础能力。
// English: This file wraps general utilities for time, money, phone numbers, email, URLs, clipboard, and other base features.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'package:soys_app/core/constants/app_constants.dart';

/// 通用工具类
/// 中文：承载 AppUtils 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: AppUtils carries its core responsibility and supports the business or UI logic in this file.
class AppUtils {
  AppUtils._();

  /// MD5加密
  static String md5Encrypt(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  /// SHA256加密
  static String sha256Encrypt(String input) {
    return sha256.convert(utf8.encode(input)).toString();
  }

  /// 手机号脱敏 138****1234
  static String phoneMask(String phone) {
    if (phone.length != 11) return phone;
    return '${phone.substring(0, 3)}****${phone.substring(7)}';
  }

  /// 邮箱脱敏 t***@example.com
  static String emailMask(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final maskedName = name.length > 1 ? '${name[0]}***' : name;
    return '$maskedName@${parts[1]}';
  }

  /// 格式化日期
  static String formatDate(
    DateTime date, {
    String format = 'yyyy-MM-dd HH:mm:ss',
  }) {
    return DateFormat(format).format(date);
  }

  /// 友好时间显示
  static String friendlyTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) return '刚刚';
    if (diff.inMinutes < 60) return '${diff.inMinutes}分钟前';
    if (diff.inHours < 24) return '${diff.inHours}小时前';
    if (diff.inDays < 7) return '${diff.inDays}天前';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}周前';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}个月前';
    return '${(diff.inDays / 365).floor()}年前';
  }

  /// 获取缓存大小
  static Future<String> getCacheSize() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final size = await _getDirSize(tempDir);
      return _formatFileSize(size);
    } catch (_) {
      return '0B';
    }
  }

  /// 清除缓存
  static Future<void> clearCache() async {
    try {
      final tempDir = await getTemporaryDirectory();
      if (tempDir.existsSync()) {
        await _deleteDir(tempDir);
      }
    } catch (_) {}
  }

  static Future<int> _getDirSize(Directory dir) async {
    int size = 0;
    try {
      await for (final entity in dir.list(
        recursive: true,
        followLinks: false,
      )) {
        if (entity is File) {
          size += await entity.length();
        }
      }
    } catch (_) {}
    return size;
  }

  static Future<void> _deleteDir(Directory dir) async {
    await for (final entity in dir.list()) {
      if (entity is File) {
        await entity.delete();
      } else if (entity is Directory) {
        await _deleteDir(entity);
      }
    }
  }

  static String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// 判断是否是手机号
  static bool isPhone(String input) {
    return RegExp(AppConstants.phoneRegex).hasMatch(input);
  }

  /// 判断是否是邮箱
  static bool isEmail(String input) {
    return RegExp(AppConstants.emailRegex).hasMatch(input);
  }

  /// 判断密码强度
  static bool isValidPassword(String input) {
    return RegExp(AppConstants.passwordRegex).hasMatch(input);
  }
}
