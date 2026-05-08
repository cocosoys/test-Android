// 中文：本文件验证应用环境配置，确保本地测试环境和线上环境的数据来源边界稳定。
// English: This file verifies app environment config so local-test and online data-source boundaries stay stable.

import 'package:flutter_test/flutter_test.dart';
import 'package:soys_app/core/constants/env_config.dart';

/// 中文：环境配置测试入口。
/// English: Entry point for environment configuration tests.
void main() {
  setUp(() {
    Environments.switchTo(Environments.local);
  });

  test('local environment uses only local content', () {
    final env = Environments.resolve('local');

    expect(env.isLocal, isTrue);
    expect(env.useLocalContent, isTrue);
    expect(env.useRemoteContent, isFalse);
    expect(env.baseUrl, isEmpty);
    expect(env.siteUrl, startsWith('asset://'));
    expect(env.allowLocalTestLogin, isTrue);
  });

  test('online environment uses only server content', () {
    final env = Environments.resolve('online');

    expect(env.isOnline, isTrue);
    expect(env.useLocalContent, isFalse);
    expect(env.useRemoteContent, isTrue);
    expect(env.baseUrl, startsWith('https://'));
    expect(env.siteUrl, startsWith('https://'));
    expect(env.allowLocalTestLogin, isFalse);
  });

  test('historical aliases resolve to the two supported environments', () {
    expect(Environments.resolve('dev'), same(Environments.local));
    expect(Environments.resolve('test'), same(Environments.local));
    expect(Environments.resolve('staging'), same(Environments.local));
    expect(Environments.resolve('prod'), same(Environments.online));
    expect(Environments.resolve('production'), same(Environments.online));
  });
}
