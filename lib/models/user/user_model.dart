// 中文：本文件定义数据模型和序列化逻辑，负责把接口 JSON 与应用内强类型对象互相转换。
// English: This file defines data models and serialization logic for converting between API JSON and strongly typed app objects.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

/// 用户信息模型
/// 中文：表示 UserModel 数据结构，并负责接口数据与应用对象之间的转换。
/// English: UserModel represents a data structure and converts between API payloads and app objects.
class UserModel {
  final String? id;
  final String? username;
  final String? nickname;
  final String? phone;
  final String? email;
  final String? avatar;
  final String? gender;
  final String? birthday;
  final String? token;
  final String? refreshToken;

  UserModel({
    this.id,
    this.username,
    this.nickname,
    this.phone,
    this.email,
    this.avatar,
    this.gender,
    this.birthday,
    this.token,
    this.refreshToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString(),
      username: json['username'] as String?,
      nickname: json['nickname'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      avatar: json['avatar'] as String?,
      gender: json['gender'] as String?,
      birthday: json['birthday'] as String?,
      token: json['token'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );
  }

  /// 中文：转换接口或本地数据结构，隔离外部字段格式对页面层的影响。
  /// English: Converts API or local data structures so external field formats stay isolated from the UI layer.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'nickname': nickname,
      'phone': phone,
      'email': email,
      'avatar': avatar,
      'gender': gender,
      'birthday': birthday,
      'token': token,
      'refreshToken': refreshToken,
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? nickname,
    String? phone,
    String? email,
    String? avatar,
    String? gender,
    String? birthday,
    String? token,
    String? refreshToken,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      nickname: nickname ?? this.nickname,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  bool get isEmpty => id == null && username == null;

  /// 中文：执行 toString 对应的业务步骤，并把内部细节封装在当前模块内。
  /// English: Executes the toString business step while keeping internal details encapsulated in this module.
  @override
  String toString() =>
      'UserModel(id: $id, username: $username, nickname: $nickname)';
}
