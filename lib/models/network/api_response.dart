// 中文：本文件定义数据模型和序列化逻辑，负责把接口 JSON 与应用内强类型对象互相转换。
// English: This file defines data models and serialization logic for converting between API JSON and strongly typed app objects.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

/// 统一网络响应模型
/// 中文：表示 ApiResponse 响应结构，用于统一接口分页或业务状态解析。
/// English: ApiResponse represents a response structure used to normalize API pagination or business status parsing.
class ApiResponse<T> {
  final int code;
  final String message;
  final T? data;

  ApiResponse({required this.code, required this.message, this.data});

  bool get isSuccess => code == 0;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse(
      code: json['code'] as int? ?? -1,
      message: json['message'] as String? ?? json['msg'] as String? ?? '',
      data: json['data'] == null
          ? null
          : fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
    );
  }

  /// 中文：转换接口或本地数据结构，隔离外部字段格式对页面层的影响。
  /// English: Converts API or local data structures so external field formats stay isolated from the UI layer.
  Map<String, dynamic> toJson() {
    return {'code': code, 'message': message, 'data': data};
  }

  /// 中文：执行 toString 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the toString business step while keeping internal details encapsulated in this module.
  @override
  String toString() =>
      'ApiResponse(code: $code, message: $message, data: $data)';
}

/// 分页响应
/// 中文：表示 PageResponse 响应结构，用于统一接口分页或业务状态解析。
/// English: PageResponse represents a response structure used to normalize API pagination or business status parsing.
class PageResponse<T> {
  final List<T> list;
  final int total;
  final int page;
  final int pageSize;

  PageResponse({
    required this.list,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  bool get hasMore => page * pageSize < total;

  factory PageResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    final listData = json['list'] ?? json['records'] ?? json['items'] ?? [];
    return PageResponse(
      list: (listData as List).map((e) => fromJsonT(e)).toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? json['pageNum'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? json['size'] as int? ?? 20,
    );
  }
}

/// 错误码
/// 中文：集中声明 ErrorCode 常量，避免魔法值分散在业务代码中。
/// English: ErrorCode centralizes constants to keep magic values out of feature code.
class ErrorCode {
  ErrorCode._();

  static const int success = 0;
  static const int tokenExpired = 401;
  static const int tokenInvalid = 403;
  static const int paramsError = 400;
  static const int serverError = 500;
  static const int networkError = -1;
  static const int timeout = -2;
  static const int cancel = -3;
  static const int unknown = -4;
}
