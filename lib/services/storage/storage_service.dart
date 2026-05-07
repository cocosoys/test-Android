// 中文：本文件封装本地存储服务，统一 SharedPreferences、用户信息、Token、协议状态、主题语言和 SQLite 初始化。
// English: This file wraps local storage for SharedPreferences, user info, tokens, agreement state, theme/language state, and SQLite initialization.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'package:soys_app/core/constants/app_constants.dart';
import 'package:soys_app/models/user/user_model.dart';

/// 本地存储服务
/// 中文：封装 StorageService 对应的跨页面服务能力，避免业务层直接依赖底层实现。
/// English: StorageService encapsulates cross-page service capabilities so feature code does not depend on low-level details directly.
class StorageService extends GetxService {
  late SharedPreferences _prefs;
  late Database _db;

  SharedPreferences get prefs => _prefs;
  Database get db => _db;

  /// 中文：完成当前对象的初始化流程，确保依赖、监听器或初始数据在使用前准备好。
  /// English: Initializes the current object so dependencies, listeners, or initial data are ready before use.
  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    _db = await _initDatabase();
    return this;
  }

  // ========== SharedPreferences 键值存储 ==========

  /// 中文：根据当前输入计算并返回调用方需要的派生值。
  /// English: Computes and returns the derived value required by the caller from the current input.
  String? getString(String key) => _prefs.getString(key);

  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  /// 中文：根据当前输入计算并返回调用方需要的派生值。
  /// English: Computes and returns the derived value required by the caller from the current input.
  int? getInt(String key) => _prefs.getInt(key);

  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);

  /// 中文：根据当前输入计算并返回调用方需要的派生值。
  /// English: Computes and returns the derived value required by the caller from the current input.
  bool? getBool(String key) => _prefs.getBool(key);

  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);

  /// 中文：根据当前输入计算并返回调用方需要的派生值。
  /// English: Computes and returns the derived value required by the caller from the current input.
  double? getDouble(String key) => _prefs.getDouble(key);

  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  Future<bool> setDouble(String key, double value) =>
      _prefs.setDouble(key, value);

  /// 中文：执行 remove 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the remove business step while keeping internal details encapsulated in this module.
  Future<bool> remove(String key) => _prefs.remove(key);

  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  Future<bool> clear() => _prefs.clear();

  /// 中文：执行 containsKey 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the containsKey business step while keeping internal details encapsulated in this module.
  bool containsKey(String key) => _prefs.containsKey(key);

  // ========== 业务快捷方法 ==========

  /// Token
  String? get token => getString(AppConstants.storageToken);

  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  Future<bool> setToken(String token) =>
      setString(AppConstants.storageToken, token);

  String? get refreshToken => getString(AppConstants.storageRefreshToken);

  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  Future<bool> setRefreshToken(String token) =>
      setString(AppConstants.storageRefreshToken, token);

  /// 用户信息
  UserModel? getUserInfo() {
    final jsonStr = getString(AppConstants.storageUserInfo);
    if (jsonStr == null) return null;
    try {
      return UserModel.fromJson(json.decode(jsonStr));
    } catch (_) {
      return null;
    }
  }

  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  Future<bool> setUserInfo(UserModel user) =>
      setString(AppConstants.storageUserInfo, json.encode(user.toJson()));

  /// 首次启动
  bool get isFirstLaunch => getBool(AppConstants.storageFirstLaunch) ?? true;

  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  Future<bool> setFirstLaunch(bool value) =>
      setBool(AppConstants.storageFirstLaunch, value);

  /// 协议同意
  bool get isAgreementAccepted =>
      getBool(AppConstants.storageAgreementAccepted) ?? false;

  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  Future<bool> setAgreementAccepted(bool value) =>
      setBool(AppConstants.storageAgreementAccepted, value);

  /// 清除用户数据
  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  Future<void> clearUserData() async {
    await remove(AppConstants.storageToken);
    await remove(AppConstants.storageRefreshToken);
    await remove(AppConstants.storageUserInfo);
  }

  // ========== SQLite 数据库 ==========

  /// 中文：执行 initDatabase 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the initDatabase business step while keeping internal details encapsulated in this module.
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = '$dbPath/soys_app.db';

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // 消息表
        await db.execute('''
          CREATE TABLE messages (
            id TEXT PRIMARY KEY,
            title TEXT,
            content TEXT,
            type TEXT,
            is_read INTEGER DEFAULT 0,
            create_time TEXT
          )
        ''');

        // 缓存表
        await db.execute('''
          CREATE TABLE api_cache (
            key TEXT PRIMARY KEY,
            data TEXT,
            expire_time INTEGER
          )
        ''');

        // 搜索历史表
        await db.execute('''
          CREATE TABLE search_history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            keyword TEXT NOT NULL,
            create_time INTEGER
          )
        ''');
      },
    );
  }

  // ========== 数据库操作 ==========

  /// 插入数据
  /// 中文：执行 dbInsert 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the dbInsert business step while keeping internal details encapsulated in this module.
  Future<int> dbInsert(String table, Map<String, dynamic> values) =>
      _db.insert(table, values);

  /// 查询数据
  Future<List<Map<String, dynamic>>> dbQuery(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) => _db.query(
    table,
    distinct: distinct,
    columns: columns,
    where: where,
    whereArgs: whereArgs,
    groupBy: groupBy,
    having: having,
    orderBy: orderBy,
    limit: limit,
    offset: offset,
  );

  /// 更新数据
  /// 中文：执行 dbUpdate 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the dbUpdate business step while keeping internal details encapsulated in this module.
  Future<int> dbUpdate(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<Object?>? whereArgs,
  }) => _db.update(table, values, where: where, whereArgs: whereArgs);

  /// 删除数据
  /// 中文：执行 dbDelete 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the dbDelete business step while keeping internal details encapsulated in this module.
  Future<int> dbDelete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) => _db.delete(table, where: where, whereArgs: whereArgs);

  /// 原始SQL查询
  Future<List<Map<String, dynamic>>> dbRawQuery(
    String sql, [
    List<Object?>? arguments,
  ]) => _db.rawQuery(sql, arguments);

  /// 执行原始SQL
  /// 中文：执行 dbExecute 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the dbExecute business step while keeping internal details encapsulated in this module.
  Future<void> dbExecute(String sql) => _db.execute(sql);
}
