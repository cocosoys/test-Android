// 中文：本文件验证应用环境配置，确保 dev、local、prod 的数据来源边界稳定。
// English: This file verifies app environment config so dev, local, and prod data-source boundaries stay stable.

import 'package:flutter_test/flutter_test.dart';
import 'package:soys_app/core/constants/env_config.dart';

/// 中文：环境配置测试入口。
/// English: Entry point for environment configuration tests.
void main() {
  setUp(() {
    Environments.switchTo(Environments.local);
  });

  test('current environment is selected by the unified config field', () {
    expect([
      'dev',
      'local',
      'prod',
    ], contains(Environments.currentEnvironmentName));
    expect(
      Environments.resolve(Environments.currentEnvironmentName).name,
      Environments.currentEnvironmentName,
    );
  });

  test('local environment uses only local content', () {
    final env = Environments.resolve('local');

    expect(env.isLocal, isTrue);
    expect(env.useLocalContent, isTrue);
    expect(env.useRemoteContent, isFalse);
    expect(env.baseUrl, isEmpty);
    expect(env.siteUrl, startsWith('asset://'));
    expect(env.showTestAccountLogin, isTrue);
    expect(env.allowLocalTestLogin, isTrue);
  });

  test('dev environment uses development servers', () {
    final env = Environments.resolve('dev');

    expect(env.isDev, isTrue);
    expect(env.useLocalContent, isFalse);
    expect(env.useRemoteContent, isTrue);
    expect(env.baseUrl, contains('dev-api'));
    expect(env.siteUrl, contains('dev.'));
    expect(env.showTestAccountLogin, isTrue);
    expect(env.allowLocalTestLogin, isFalse);
    expect(env.enableLog, isTrue);
  });

  test('prod environment uses production servers', () {
    final env = Environments.resolve('prod');

    expect(env.isProd, isTrue);
    expect(env.isOnline, isTrue);
    expect(env.useLocalContent, isFalse);
    expect(env.useRemoteContent, isTrue);
    expect(env.baseUrl, startsWith('https://'));
    expect(env.siteUrl, startsWith('https://'));
    expect(env.showTestAccountLogin, isFalse);
    expect(env.allowLocalTestLogin, isFalse);
  });

  test('historical aliases resolve to the three supported environments', () {
    expect(Environments.resolve('local').name, 'local');
    expect(Environments.resolve('offline').name, 'local');
    expect(Environments.resolve('test').name, 'dev');
    expect(Environments.resolve('qa').name, 'dev');
    expect(Environments.resolve('staging').name, 'dev');
    expect(Environments.resolve('online').name, 'prod');
    expect(Environments.resolve('production').name, 'prod');
  });
}
