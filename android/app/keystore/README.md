# SOYS App Android 签名配置说明

## 生成签名文件

```bash
keytool -genkey -v -keystore soys_app.jks -keyalg RSA -keysize 2048 -validity 10000 -alias soys_app
```

## 签名信息
- **Keystore文件**: keystore/soys_app.jks
- **Alias**: soys_app
- **Store密码**: 在local.properties中配置
- **Key密码**: 在local.properties中配置

## 配置方式
在 `android/local.properties` 中添加：
```
storePassword=your_store_password
keyPassword=your_key_password
```

## 多渠道打包
```bash
# 开发版
flutter build apk --flavor dev

# 测试版
flutter build apk --flavor qa

# 预发版
flutter build apk --flavor staging

# 正式版
flutter build apk --flavor prod

# 正式版 App Bundle (Google Play)
flutter build appbundle --flavor prod
```

⚠️ 注意：正式发布前请替换签名文件并更新密码配置！
