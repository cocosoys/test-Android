// 中文：本文件封装应用更新服务，统一版本检查、更新弹窗、下载进度、安装入口和版本号比较。
// English: This file wraps app update logic for version checks, update dialogs, download progress, install entry points, and version comparison.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file/open_file.dart';

import 'package:soys_app/core/logger/app_logger.dart';
import 'package:soys_app/core/network/http_service.dart';
import 'package:soys_app/core/constants/env_config.dart';
import 'package:soys_app/models/app/app_models.dart';
import 'package:soys_app/components/toast/app_toast.dart';

/// 版本更新服务
/// 中文：封装 UpdateService 对应的跨页面服务能力，避免业务层直接依赖底层实现。
/// English: UpdateService encapsulates cross-page service capabilities so feature code does not depend on low-level details directly.
class UpdateService extends GetxService {
  final HttpService _http = Get.find<HttpService>();

  final _downloadProgress = 0.0.obs;
  final _isDownloading = false.obs;

  double get downloadProgress => _downloadProgress.value;
  bool get isDownloading => _isDownloading.value;

  /// 检查更新
  /// 中文：加载或刷新当前功能所需数据，并在失败时保留可用的兜底状态。
  /// English: Loads or refreshes data required by this feature and keeps usable fallback state when requests fail.
  Future<AppInfoModel?> checkUpdate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final response = await _http.get<AppInfoModel>(
        '/app/version/check',
        queryParameters: {
          'version': currentVersion,
          'platform': Platform.isAndroid ? 'android' : 'ios',
        },
        fromJson: (json) => AppInfoModel.fromJson(json as Map<String, dynamic>),
      );

      if (response.isSuccess && response.data != null) {
        final serverVersion = response.data!.versionName;
        if (serverVersion != null &&
            _needUpdate(currentVersion, serverVersion)) {
          return response.data;
        }
      }
      return null;
    } catch (e) {
      AppLogger.e('Check update error: $e');
      return null;
    }
  }

  /// 显示更新弹窗
  /// 中文：执行 showUpdateDialog 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the showUpdateDialog business step while keeping internal details encapsulated in this module.
  Future<void> showUpdateDialog(AppInfoModel updateInfo) async {
    final forceUpdate = updateInfo.forceUpdate ?? false;

    await Get.dialog(
      PopScope(
        canPop: !forceUpdate,
        child: AlertDialog(
          title: Text('update_title'.tr),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('v${updateInfo.versionName ?? ''}'),
              const SizedBox(height: 8),
              Text(updateInfo.updateContent ?? ''),
            ],
          ),
          actions: [
            if (!forceUpdate)
              TextButton(
                onPressed: () => Get.back(),
                child: Text('update_later'.tr),
              ),
            ElevatedButton(
              onPressed: () {
                Get.back();
                _startUpdate(updateInfo);
              },
              child: Obx(
                () => _isDownloading.value
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              value: _downloadProgress.value,
                              strokeWidth: 2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('${(_downloadProgress.value * 100).toInt()}%'),
                        ],
                      )
                    : Text('update_now'.tr),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: !forceUpdate,
    );
  }

  /// 开始更新
  /// 中文：执行 startUpdate 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the startUpdate business step while keeping internal details encapsulated in this module.
  Future<void> _startUpdate(AppInfoModel updateInfo) async {
    if (Platform.isIOS) {
      final appStoreUrl =
          updateInfo.downloadUrl ?? Environments.current.appStoreUrl;
      await launchUrl(
        Uri.parse(appStoreUrl),
        mode: LaunchMode.externalApplication,
      );
    } else {
      await _downloadAndInstall(updateInfo.downloadUrl ?? '');
    }
  }

  /// 下载并安装 APK
  /// 中文：调用系统、文件或平台能力，并向业务层返回统一的处理结果。
  /// English: Invokes system, file, or platform capabilities and returns normalized results to feature code.
  Future<void> _downloadAndInstall(String downloadUrl) async {
    if (downloadUrl.isEmpty) return;

    try {
      _isDownloading.value = true;
      _downloadProgress.value = 0;

      final dir = await getExternalStorageDirectory();
      final savePath = '${dir?.path}/soys_app_update.apk';

      await _http.download(
        downloadUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            _downloadProgress.value = received / total;
          }
        },
      );

      _isDownloading.value = false;
      AppToast.showSuccess('download_complete'.tr);

      await OpenFile.open(savePath);
    } catch (e) {
      _isDownloading.value = false;
      AppLogger.e('Download APK error: $e');
      AppToast.showError('failed'.tr);
    }
  }

  /// 版本比较
  /// 中文：执行 needUpdate 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the needUpdate business step while keeping internal details encapsulated in this module.
  bool _needUpdate(String current, String server) {
    final currentParts = current.split('.').map(int.parse).toList();
    final serverParts = server.split('.').map(int.parse).toList();

    for (var i = 0; i < serverParts.length; i++) {
      if (i >= currentParts.length) return true;
      if (serverParts[i] > currentParts[i]) return true;
      if (serverParts[i] < currentParts[i]) return false;
    }

    return false;
  }
}
