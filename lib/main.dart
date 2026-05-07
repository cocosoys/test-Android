// 中文：本文件是 Flutter 应用入口，负责初始化系统能力、全局服务、异常捕获、主题、本地化和根路由容器。
// English: This file is the Flutter app entry point and initializes system services, global services, error capture, themes, localization, and the root route container.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import 'package:soys_app/app/bindings/initial_binding.dart';
import 'package:soys_app/app/routes/app_routes.dart';
import 'package:soys_app/app/theme/app_theme.dart';
import 'package:soys_app/app/translations/app_translations.dart';
import 'package:soys_app/core/logger/app_logger.dart';
import 'package:soys_app/services/crash/crash_service.dart';

/// 中文：启动 Flutter 应用，并把真正的初始化流程委托给独立方法，便于统一捕获异常。
/// English: Starts the Flutter app and delegates initialization to a separate method so uncaught errors can be handled consistently.
void main() async {
  await _initApp();
}

/// 中文：执行 initApp 对应的业务步骤，并把内部细节封装在当前模块内。
/// English: Executes the initApp business step while keeping internal details encapsulated in this module.
Future<void> _initApp() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      FlutterError.onError = (details) {
        CrashService.recordFlutterError(details);
      };

      const style = SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      );
      SystemChrome.setSystemUIOverlayStyle(style);

      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      await InitialBinding.ensureInitialized();

      runApp(const SOYSApp());
    },
    (error, stack) {
      CrashService.recordError(error, stack);
      AppLogger.e('Uncaught error', error, stack);
    },
  );
}

/// 中文：承载 SOYSApp 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: SOYSApp carries its core responsibility and supports the business or UI logic in this file.
class SOYSApp extends StatelessWidget {
  const SOYSApp({super.key});

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'SOYS App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeController().themeMode,
          translations: AppTranslations(),
          locale: Get.deviceLocale,
          fallbackLocale: const Locale('zh', 'CN'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('zh', 'CN'), Locale('en', 'US')],
          initialRoute: AppRoutes.splash,
          getPages: AppPages.pages,
          builder: FlutterSmartDialog.init(),
          navigatorObservers: [FlutterSmartDialog.observer],
          initialBinding: InitialBinding(),
        );
      },
    );
  }
}
