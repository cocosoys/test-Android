// 中文：本文件维护应用多语言文案映射，为 GetX 国际化提供中文和英文文本。
// English: This file maintains localized copy maps and supplies Chinese and English strings to GetX internationalization.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import 'package:get/get.dart';

/// 国际化翻译
/// 中文：承载 AppTranslations 的核心职责，配合当前文件完成对应业务或界面逻辑。
/// English: AppTranslations carries its core responsibility and supports the business or UI logic in this file.
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'zh_CN': {
      // 通用
      'app_name': 'SOYS应用',
      'confirm': '确认',
      'cancel': '取消',
      'save': '保存',
      'delete': '删除',
      'edit': '编辑',
      'search': '搜索',
      'loading': '加载中...',
      'retry': '重试',
      'no_data': '暂无数据',
      'no_more': '没有更多了',
      'load_more': '加载更多',
      'success': '操作成功',
      'failed': '操作失败',
      'error': '出错了',
      'timeout': '请求超时',
      'network_error': '网络连接失败，请检查网络',
      'server_error': '服务器开小差了，请稍后再试',

      // 底部Tab
      'tab_home': '首页',
      'tab_message': '消息',
      'tab_mine': '我的',

      // 登录注册
      'login': '登录',
      'register': '注册',
      'logout': '退出登录',
      'phone': '手机号',
      'email': '邮箱',
      'account': '账号',
      'password': '密码',
      'confirm_password': '确认密码',
      'forgot_password': '忘记密码？',
      'sms_code': '验证码',
      'get_sms_code': '获取验证码',
      'sms_sent': '验证码已发送',
      'phone_hint': '请输入手机号',
      'email_hint': '请输入邮箱',
      'account_hint': '请输入账号',
      'password_hint': '请输入密码',
      'sms_code_hint': '请输入验证码',
      'login_success': '登录成功',
      'register_success': '注册成功',
      'logout_confirm': '确定退出登录吗？',
      'phone_invalid': '手机号格式不正确',
      'email_invalid': '邮箱格式不正确',
      'password_invalid': '密码需8-20位，包含字母和数字',
      'password_not_match': '两次密码不一致',
      'test_account': '测试账号登录',

      // 第三方登录
      'wechat_login': '微信登录',
      'qq_login': 'QQ登录',
      'apple_login': 'Apple登录',
      'other_login': '其他登录方式',

      // 个人中心
      'profile': '个人资料',
      'avatar': '头像',
      'nickname': '昵称',
      'gender': '性别',
      'male': '男',
      'female': '女',
      'birthday': '生日',
      'change_avatar': '更换头像',
      'take_photo': '拍照',
      'pick_from_album': '从相册选择',

      // 设置
      'settings': '设置',
      'theme_mode': '主题模式',
      'theme_light': '浅色模式',
      'theme_dark': '深色模式',
      'theme_system': '跟随系统',
      'language': '语言',
      'language_zh': '简体中文',
      'language_en': 'English',
      'cache_clear': '清理缓存',
      'cache_size': '缓存大小',
      'cache_clear_confirm': '确定清理所有缓存吗？',
      'about': '关于我们',
      'privacy': '隐私协议',
      'terms': '用户协议',
      'version': '当前版本',
      'check_update': '检查更新',
      'has_update': '发现新版本',
      'no_update': '已是最新版本',

      // 消息
      'message_center': '消息中心',
      'notification': '通知',
      'system_message': '系统消息',

      // WebView
      'webview_loading': '页面加载中...',

      // 权限
      'permission_denied': '权限被拒绝',
      'permission_camera': '需要相机权限',
      'permission_gallery': '需要相册权限',
      'permission_location': '需要定位权限',
      'permission_notification': '需要通知权限',
      'permission_storage': '需要存储权限',
      'permission_go_settings': '去设置',
      'permission_rationale': '此功能需要相关权限才能正常使用，是否前往设置开启？',

      // 更新
      'update_title': '版本更新',
      'update_content': '更新内容',
      'update_now': '立即更新',
      'update_later': '稍后更新',
      'downloading': '下载中...',
      'download_complete': '下载完成',
      'install_now': '立即安装',

      // 分享
      'share': '分享',
      'share_to_wechat': '分享到微信',
      'share_to_moments': '分享到朋友圈',
      'share_to_qq': '分享到QQ',
      'copy_link': '复制链接',

      // 协议
      'agreement_title': '用户协议与隐私政策',
      'agreement_content': '请您务必审慎阅读、充分理解"用户协议"和"隐私政策"各条款。您可点击查看',
      'agreement_and': '和',
      'agreement_accept': '同意并继续',
      'agreement_disagree': '不同意',
    },
    'en_US': {
      // Common
      'app_name': 'SOYS App',
      'confirm': 'Confirm',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'search': 'Search',
      'loading': 'Loading...',
      'retry': 'Retry',
      'no_data': 'No data',
      'no_more': 'No more data',
      'load_more': 'Load more',
      'success': 'Success',
      'failed': 'Failed',
      'error': 'Error',
      'timeout': 'Request timeout',
      'network_error': 'Network error, please check your connection',
      'server_error': 'Server error, please try again later',

      // Tab
      'tab_home': 'Home',
      'tab_message': 'Message',
      'tab_mine': 'Mine',

      // Auth
      'login': 'Login',
      'register': 'Register',
      'logout': 'Logout',
      'phone': 'Phone',
      'email': 'Email',
      'account': 'Account',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'forgot_password': 'Forgot Password?',
      'sms_code': 'Code',
      'get_sms_code': 'Get Code',
      'sms_sent': 'Code sent',
      'phone_hint': 'Enter phone number',
      'email_hint': 'Enter email',
      'account_hint': 'Enter account',
      'password_hint': 'Enter password',
      'sms_code_hint': 'Enter verification code',
      'login_success': 'Login success',
      'register_success': 'Register success',
      'logout_confirm': 'Are you sure to logout?',
      'phone_invalid': 'Invalid phone number',
      'email_invalid': 'Invalid email address',
      'password_invalid':
          'Password must be 8-20 chars with letters and numbers',
      'password_not_match': 'Passwords do not match',
      'test_account': 'Test Account',

      // Third-party login
      'wechat_login': 'WeChat Login',
      'qq_login': 'QQ Login',
      'apple_login': 'Apple Login',
      'other_login': 'Other Login',

      // Profile
      'profile': 'Profile',
      'avatar': 'Avatar',
      'nickname': 'Nickname',
      'gender': 'Gender',
      'male': 'Male',
      'female': 'Female',
      'birthday': 'Birthday',
      'change_avatar': 'Change Avatar',
      'take_photo': 'Take Photo',
      'pick_from_album': 'Pick from Album',

      // Settings
      'settings': 'Settings',
      'theme_mode': 'Theme',
      'theme_light': 'Light',
      'theme_dark': 'Dark',
      'theme_system': 'System',
      'language': 'Language',
      'language_zh': '简体中文',
      'language_en': 'English',
      'cache_clear': 'Clear Cache',
      'cache_size': 'Cache Size',
      'cache_clear_confirm': 'Clear all cache?',
      'about': 'About',
      'privacy': 'Privacy Policy',
      'terms': 'Terms of Service',
      'version': 'Version',
      'check_update': 'Check Update',
      'has_update': 'New version available',
      'no_update': 'Already up to date',

      // Message
      'message_center': 'Messages',
      'notification': 'Notification',
      'system_message': 'System',

      // WebView
      'webview_loading': 'Loading...',

      // Permission
      'permission_denied': 'Permission Denied',
      'permission_camera': 'Camera permission required',
      'permission_gallery': 'Gallery permission required',
      'permission_location': 'Location permission required',
      'permission_notification': 'Notification permission required',
      'permission_storage': 'Storage permission required',
      'permission_go_settings': 'Go Settings',
      'permission_rationale':
          'This feature requires permission. Go to settings to enable?',

      // Update
      'update_title': 'Update',
      'update_content': 'What\'s New',
      'update_now': 'Update Now',
      'update_later': 'Later',
      'downloading': 'Downloading...',
      'download_complete': 'Download Complete',
      'install_now': 'Install Now',

      // Share
      'share': 'Share',
      'share_to_wechat': 'Share to WeChat',
      'share_to_moments': 'Share to Moments',
      'share_to_qq': 'Share to QQ',
      'copy_link': 'Copy Link',

      // Agreement
      'agreement_title': 'Terms & Privacy',
      'agreement_content':
          'Please read the Terms of Service and Privacy Policy carefully.',
      'agreement_and': 'and',
      'agreement_accept': 'Agree & Continue',
      'agreement_disagree': 'Disagree',
    },
  };
}
