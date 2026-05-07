# SOYS App ProGuard Rules

# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# GetX
-keep class com.get.** { *; }

# 极光推送
-dontwarn cn.jpush.**
-keep class cn.jpush.** { *; }
-dontwarn cn.jiguang.**
-keep class cn.jiguang.** { *; }

# 微信
-keep class com.tencent.mm.opensdk.** { *; }
-keep class com.tencent.wxop.** { *; }

# QQ
-keep class com.tencent.connect.** { *; }
-keep class com.tencent.tauth.** { *; }

# Gson
-keepattributes Signature
-keepattributes *Annotation*
-keep class sun.misc.Unsafe { *; }
-keep class com.google.gson.** { *; }

# 通用
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
