# Flutter ProGuard / R8 Rules
# Keeps Flutter and plugin classes from being stripped or obfuscated unexpectedly

# Flutter engine rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Flutter embedding
-dontwarn io.flutter.embedding.**

# Keep annotations and generic signatures for serialization
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod

# Preserve enums
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
