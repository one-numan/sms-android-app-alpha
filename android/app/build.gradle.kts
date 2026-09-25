import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

val envStoreFile: String? = System.getenv("ONPS_KEYSTORE_FILE")
val envStorePassword: String? = System.getenv("ONPS_STORE_PASSWORD")
val envKeyAlias: String? = System.getenv("ONPS_KEY_ALIAS")
val envKeyPassword: String? = System.getenv("ONPS_KEY_PASSWORD")

val storeFilePath: String? = keystoreProperties.getProperty("storeFile") ?: envStoreFile
val storePass: String? = keystoreProperties.getProperty("storePassword") ?: envStorePassword
val keyId: String? = keystoreProperties.getProperty("keyAlias") ?: envKeyAlias
val keyPass: String? = keystoreProperties.getProperty("keyPassword") ?: envKeyPassword
val hasReleaseKeystore = !storeFilePath.isNullOrBlank() && 
    (file(storeFilePath).exists() || rootProject.file(storeFilePath).exists())

android {
    namespace = "com.onenuman.sms_android_app_alpha"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // Unique Application ID for Alpha release to prevent conflicting with installed app
        applicationId = "com.onenuman.sms_android_app_alpha"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (hasReleaseKeystore) {
                val resolvedKeystoreFile = if (file(storeFilePath!!).exists()) {
                    file(storeFilePath)
                } else {
                    rootProject.file(storeFilePath)
                }
                storeFile = resolvedKeystoreFile
                storePassword = storePass
                keyAlias = keyId
                keyPassword = keyPass
            } else {
                // If production keystore is not yet configured, fall back to debug signing for local staging/smoke test.
                // NOTE: Production release status will report PRODUCTION SIGNING: NOT VERIFIED.
                val debugConfig = signingConfigs.getByName("debug")
                storeFile = debugConfig.storeFile
                storePassword = debugConfig.storePassword
                keyAlias = debugConfig.keyAlias
                keyPassword = debugConfig.keyPassword
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
