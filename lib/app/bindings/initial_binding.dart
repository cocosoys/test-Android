// 中文：本文件负责 GetX 依赖注入，把启动期和页面期需要的服务注册到统一容器中。
// English: This file handles GetX dependency injection by registering startup and page-scoped services in the shared container.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:get/get.dart';

import 'package:soys_app/core/logger/app_logger.dart';
import 'package:soys_app/core/network/http_service.dart';
import 'package:soys_app/core/permission/permission_service.dart';
import 'package:soys_app/services/analytics/analytics_service.dart';
import 'package:soys_app/services/auth/auth_service.dart';
import 'package:soys_app/services/crash/crash_service.dart';
import 'package:soys_app/services/device/device_service.dart';
import 'package:soys_app/services/push/push_service.dart';
import 'package:soys_app/services/scanner/scanner_service.dart';
import 'package:soys_app/services/share/share_service.dart';
import 'package:soys_app/services/storage/storage_service.dart';
import 'package:soys_app/services/update/update_service.dart';
import 'package:soys_app/services/webview/webview_service.dart';

/// 中文：注册 InitialBinding 对应路由需要的控制器或服务依赖。
/// English: InitialBinding registers the controllers or services required by its route.
class InitialBinding extends Bindings {
  /// 中文：注册当前路由或模块需要的 GetX 依赖，保证页面创建前控制器已经可用。
  /// English: Registers the GetX dependencies required by the current route or module before the page is created.
  @override
  void dependencies() {
    _putSyncServices();
  }

  static Future<void> ensureInitialized() async {
    await InitialBinding()._initServices();
  }

  /// 中文：执行 initServices 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the initServices business step while keeping internal details encapsulated in this module.
  Future<void> _initServices() async {
    if (!Get.isRegistered<StorageService>()) {
      await Get.putAsync<StorageService>(() => StorageService().init());
      AppLogger.i('StorageService initialized');
    }

    if (!Get.isRegistered<HttpService>()) {
      await Get.putAsync<HttpService>(() => HttpService().init());
      AppLogger.i('HttpService initialized');
    }

    if (!Get.isRegistered<AuthService>()) {
      await Get.putAsync<AuthService>(() => AuthService().init());
      AppLogger.i('AuthService initialized');
    }

    _putSyncServices();

    if (!Get.isRegistered<CrashService>()) {
      await Get.putAsync<CrashService>(() => CrashService().init());
      AppLogger.i('CrashService initialized');
    }

    if (!Get.isRegistered<AnalyticsService>()) {
      await Get.putAsync<AnalyticsService>(() => AnalyticsService().init());
    }

    if (!Get.isRegistered<PushService>()) {
      await Get.putAsync<PushService>(() => PushService().init());
    }

    AppLogger.i('All global services initialized');
  }

  /// 中文：执行 putSyncServices 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the putSyncServices business step while keeping internal details encapsulated in this module.
  void _putSyncServices() {
    if (!Get.isRegistered<PermissionService>()) {
      Get.put<PermissionService>(PermissionService());
    }
    if (!Get.isRegistered<WebViewService>()) {
      Get.put<WebViewService>(WebViewService());
    }
    if (!Get.isRegistered<DeviceService>()) {
      Get.put<DeviceService>(DeviceService());
    }
    if (!Get.isRegistered<UpdateService>() && Get.isRegistered<HttpService>()) {
      Get.put<UpdateService>(UpdateService());
    }
    if (!Get.isRegistered<ScannerService>()) {
      Get.put<ScannerService>(ScannerService());
    }
    if (!Get.isRegistered<ShareService>()) {
      Get.put<ShareService>(ShareService());
    }
  }
}
