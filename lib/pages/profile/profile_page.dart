// 中文：本文件承载资料编辑页面逻辑，负责头像、昵称、性别、生日和资料保存。
// English: This file owns the Profile page logic for avatar, nickname, gender, birthday, and profile saving.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import 'package:soys_app/app/theme/app_theme.dart';
import 'package:soys_app/models/user/user_model.dart';
import 'package:soys_app/services/auth/auth_service.dart';
import 'package:soys_app/core/permission/permission_service.dart';
import 'package:soys_app/components/toast/app_toast.dart';

/// 中文：管理 ProfileController 对应页面或功能的状态、数据加载和用户交互。
/// English: ProfileController manages state, data loading, and user interactions for its related page or feature.
class ProfileController extends GetxController {
  final AuthService _auth = Get.find<AuthService>();
  final PermissionService _permission = Get.find<PermissionService>();

  final nicknameController = TextEditingController();
  final _selectedGender = ''.obs;
  final _selectedBirthday = ''.obs;
  final _avatarPath = ''.obs;

  UserModel? get user => _auth.user;
  String get selectedGender => _selectedGender.value;
  String get selectedBirthday => _selectedBirthday.value;
  String get avatarPath => _avatarPath.value;

  /// 中文：完成当前对象的初始化流程，确保依赖、监听器或初始数据在使用前准备好。
  /// English: Initializes the current object so dependencies, listeners, or initial data are ready before use.
  @override
  void onInit() {
    super.onInit();
    _loadUserInfo();
  }

  /// 中文：加载或刷新当前功能所需数据，并在失败时保留可用的兜底状态。
  /// English: Loads or refreshes data required by this feature and keeps usable fallback state when requests fail.
  void _loadUserInfo() {
    final user = _auth.user;
    if (user != null) {
      nicknameController.text = user.nickname ?? '';
      _selectedGender.value = user.gender ?? '';
      _selectedBirthday.value = user.birthday ?? '';
      _avatarPath.value = user.avatar ?? '';
    }
  }

  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  Future<void> changeAvatar() async {
    final hasPermission = await _permission.requestGallery();
    if (!hasPermission) return;

    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 80,
    );

    if (image != null) {
      _avatarPath.value = image.path;
      final response = await _auth.uploadAvatar(image.path);
      if (response.isSuccess &&
          response.data != null &&
          response.data!.isNotEmpty) {
        _avatarPath.value = response.data!;
      }
      AppToast.showSuccess('change_avatar'.tr);
    }
  }

  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  void setGender(String gender) {
    _selectedGender.value = gender;
  }

  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  void setBirthday(String date) {
    _selectedBirthday.value = date;
  }

  /// 中文：更新当前功能状态或持久化数据，并确保界面和本地缓存保持一致。
  /// English: Updates feature state or persisted data while keeping the UI and local cache consistent.
  Future<void> save() async {
    final nickname = nicknameController.text.trim();
    if (nickname.isEmpty) {
      AppToast.showWarning('请输入昵称');
      return;
    }

    final updatedUser = _auth.user?.copyWith(
      nickname: nickname,
      gender: _selectedGender.value,
      birthday: _selectedBirthday.value,
      avatar: _avatarPath.value,
    );

    if (updatedUser != null) {
      final response = await _auth.updateProfile(updatedUser);
      if (response.isSuccess) {
        AppToast.showSuccess('success'.tr);
        Get.back();
      } else {
        AppToast.showError(response.message);
      }
    }
  }
}

/// 中文：构建 ProfilePage 对应的页面界面，并把用户操作转交给控制器处理。
/// English: ProfilePage builds its page UI and delegates user actions to the controller.
class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  /// 中文：构建当前组件的界面树，并根据响应式状态刷新可见内容。
  /// English: Builds the widget tree for this component and refreshes visible content from reactive state.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile'.tr),
        actions: [
          TextButton(
            onPressed: controller.save,
            child: Text(
              'save'.tr,
              style: const TextStyle(color: AppTheme.primaryColor),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildAvatarSection(),
            SizedBox(height: 24.h),
            _buildNicknameField(),
            SizedBox(height: 16.h),
            _buildGenderField(),
            SizedBox(height: 16.h),
            _buildBirthdayField(),
          ],
        ),
      ),
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildAvatarSection() {
    return Center(
      child: GestureDetector(
        onTap: controller.changeAvatar,
        child: Obx(
          () => Stack(
            children: [
              CircleAvatar(
                radius: 48.r,
                backgroundColor: AppTheme.bgSecondary,
                backgroundImage: controller.avatarPath.isNotEmpty
                    ? (controller.avatarPath.startsWith('http')
                          ? NetworkImage(controller.avatarPath)
                          : FileImage(File(controller.avatarPath)))
                    : null,
                child: controller.avatarPath.isEmpty
                    ? Icon(Icons.person, size: 48.sp, color: AppTheme.textHint)
                    : null,
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 14.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildNicknameField() {
    return TextField(
      controller: controller.nicknameController,
      decoration: InputDecoration(
        labelText: 'nickname'.tr,
        prefixIcon: const Icon(Icons.badge_outlined),
      ),
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildGenderField() {
    return Obx(
      () => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.wc_outlined, color: AppTheme.textSecondary),
        title: Text('gender'.tr, style: TextStyle(fontSize: 15.sp)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ChoiceChip(
              label: Text('male'.tr),
              selected: controller.selectedGender == 'male',
              onSelected: (_) => controller.setGender('male'),
            ),
            SizedBox(width: 8.w),
            ChoiceChip(
              label: Text('female'.tr),
              selected: controller.selectedGender == 'female',
              onSelected: (_) => controller.setGender('female'),
            ),
          ],
        ),
      ),
    );
  }

  /// 中文：构建当前页面中的局部 UI 片段，保持主构建方法结构清晰。
  /// English: Builds a focused UI section in the page so the main build method stays readable.
  Widget _buildBirthdayField() {
    return Obx(
      () => ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.cake_outlined, color: AppTheme.textSecondary),
        title: Text('birthday'.tr, style: TextStyle(fontSize: 15.sp)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              controller.selectedBirthday.isEmpty
                  ? '请选择'
                  : controller.selectedBirthday,
              style: TextStyle(fontSize: 14.sp, color: AppTheme.textSecondary),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14.sp,
              color: AppTheme.textHint,
            ),
          ],
        ),
        onTap: () async {
          final date = await showDatePicker(
            context: Get.context!,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (date != null) {
            controller.setBirthday(
              '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
            );
          }
        },
      ),
    );
  }
}
