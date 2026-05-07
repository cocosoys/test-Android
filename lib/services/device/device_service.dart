// 中文：本文件封装设备能力服务，统一设备信息、应用信息、网络状态、系统设置、电话、URL 和邮件调用。
// English: This file wraps device capabilities for device info, app info, connectivity, settings, calls, URLs, and email actions.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'dart:io';

import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart' as permissions;
import 'package:url_launcher/url_launcher.dart';

import 'package:soys_app/core/logger/app_logger.dart';

/// 设备信息服务
/// 中文：封装 DeviceService 对应的跨页面服务能力，避免业务层直接依赖底层实现。
/// English: DeviceService encapsulates cross-page service capabilities so feature code does not depend on low-level details directly.
class DeviceService extends GetxService {
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// 获取设备信息
  Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        final info = await _deviceInfo.androidInfo;
        return {
          'brand': info.brand,
          'model': info.model,
          'manufacturer': info.manufacturer,
          'sdkVersion': info.version.sdkInt.toString(),
          'release': info.version.release,
          'deviceId': info.id,
        };
      } else if (Platform.isIOS) {
        final info = await _deviceInfo.iosInfo;
        return {
          'model': info.utsname.machine,
          'systemName': info.systemName,
          'systemVersion': info.systemVersion,
          'deviceId': info.identifierForVendor ?? '',
        };
      }
    } catch (e) {
      AppLogger.e('Get device info error: $e');
    }
    return {};
  }

  /// 获取应用信息
  Future<Map<String, dynamic>> getAppInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return {
        'appName': info.appName,
        'packageName': info.packageName,
        'version': info.version,
        'buildNumber': info.buildNumber,
      };
    } catch (e) {
      AppLogger.e('Get app info error: $e');
    }
    return {};
  }

  /// 获取版本号
  /// 中文：根据当前输入计算并返回调用方需要的派生值。
  /// English: Computes and returns the derived value required by the caller from the current input.
  Future<String> getVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  /// 获取构建号
  /// 中文：根据当前输入计算并返回调用方需要的派生值。
  /// English: Computes and returns the derived value required by the caller from the current input.
  Future<String> getBuildNumber() async {
    final info = await PackageInfo.fromPlatform();
    return info.buildNumber;
  }

  /// 检查网络连接
  /// 中文：执行 isConnected 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the isConnected business step while keeping internal details encapsulated in this module.
  Future<bool> isConnected() async {
    final result = await Connectivity().checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  /// 获取网络类型
  /// 中文：根据当前输入计算并返回调用方需要的派生值。
  /// English: Computes and returns the derived value required by the caller from the current input.
  Future<String> getNetworkType() async {
    final result = await Connectivity().checkConnectivity();
    if (result.contains(ConnectivityResult.wifi)) return 'wifi';
    if (result.contains(ConnectivityResult.mobile)) return 'mobile';
    if (result.contains(ConnectivityResult.ethernet)) return 'ethernet';
    return 'none';
  }

  /// 打开应用设置
  /// 中文：处理导航、桥接或事件分发动作，统一外部交互入口。
  /// English: Handles navigation, bridge, or event-dispatch actions through a single interaction entry point.
  Future<bool> openAppSettings() async {
    return permissions.openAppSettings();
  }

  /// 拨打电话
  /// 中文：调用系统、文件或平台能力，并向业务层返回统一的处理结果。
  /// English: Invokes system, file, or platform capabilities and returns normalized results to feature code.
  Future<void> makePhoneCall(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  /// 打开URL
  /// 中文：处理导航、桥接或事件分发动作，统一外部交互入口。
  /// English: Handles navigation, bridge, or event-dispatch actions through a single interaction entry point.
  Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  /// 发送邮件
  /// 中文：调用系统、文件或平台能力，并向业务层返回统一的处理结果。
  /// English: Invokes system, file, or platform capabilities and returns normalized results to feature code.
  Future<void> sendEmail(String email, {String? subject, String? body}) async {
    final queryParameters = <String, String>{};
    if (subject != null) {
      queryParameters['subject'] = subject;
    }
    if (body != null) {
      queryParameters['body'] = body;
    }

    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
