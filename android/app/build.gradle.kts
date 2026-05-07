// 中文：本文件属于 Android 平台工程，负责 Gradle、Manifest、资源或原生入口配置。
// English: This file belongs to the Android platform project and configures Gradle, manifests, resources, or the native entry point.
//
// 中文：本文件的注释统一采用“上中文、下英文”的双语顺序，不能使用 ASCII 转码代替中文。
// English: Comments in this file keep Chinese above English and use real Chinese characters instead of ASCII escapes.

import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("local.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}
val releaseStoreFile = keystoreProperties.getProperty("storeFile")
    ?.let { file(it) }
    ?: file("keystore/soys_app.jks")
val releaseStorePassword = keystoreProperties.getProperty("storePassword")
val releaseKeyAlias = keystoreProperties.getProperty("keyAlias") ?: "soys_app"
val releaseKeyPassword = keystoreProperties.getProperty("keyPassword")
val hasReleaseKeystore = releaseStoreFile.exists() &&
    !releaseStorePassword.isNullOrBlank() &&
    !releaseKeyPassword.isNullOrBlank()

android {
    namespace = "com.soys.app.test"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.soys.app.test"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        manifestPlaceholders["JPUSH_PKGNAME"] = applicationId ?: "com.soys.app.test"
        manifestPlaceholders["JPUSH_APPKEY"] = project.findProperty("jPushAppKey") as String? ?: ""
        manifestPlaceholders["JPUSH_CHANNEL"] = "developer-default"

        // 多渠道配置
        flavorDimensions += "channel"
    }

    // 签名配置
    signingConfigs {
        create("release") {
            if (hasReleaseKeystore) {
                storeFile = releaseStoreFile
                storePassword = releaseStorePassword
                keyAlias = releaseKeyAlias
                keyPassword = releaseKeyPassword
            }
        }
    }

    buildTypes {
        debug {
            isMinifyEnabled = false
            isShrinkResources = false
            signingConfig = signingConfigs.getByName("debug")
        }
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            signingConfig = if (hasReleaseKeystore) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    // 多渠道打包
    productFlavors {
        create("dev") {
            dimension = "channel"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "SOYS Dev")
            manifestPlaceholders["CHANNEL"] = "dev"
        }
        create("qa") {
            dimension = "channel"
            applicationIdSuffix = ".test"
            versionNameSuffix = "-test"
            resValue("string", "app_name", "SOYS Test")
            manifestPlaceholders["CHANNEL"] = "test"
        }
        create("staging") {
            dimension = "channel"
            applicationIdSuffix = ".staging"
            versionNameSuffix = "-staging"
            resValue("string", "app_name", "SOYS Staging")
            manifestPlaceholders["CHANNEL"] = "staging"
        }
        create("prod") {
            dimension = "channel"
            resValue("string", "app_name", "SOYS App")
            manifestPlaceholders["CHANNEL"] = "prod"
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
