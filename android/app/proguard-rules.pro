# ProGuard / R8 Rules for Remember Me
# Protect against obfuscation breakage for Flutter, Isar, and location plugins

# Flutter wrapper & Play Store deferred components
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn com.google.android.play.core.**

# Isar Database native JNI & generated models
-keepclassmembers class * extends io.isar.IsarObject { *; }
-keep class io.isar.** { *; }
-dontwarn io.isar.**

# Desugaring & Kotlin Coroutines
-keepattributes *Annotation*,InnerClasses,Signature,EnclosingMethod
-dontwarn java.lang.invoke.**
-dontwarn java.time.**

# Geolocator & Permissions
-keep class com.baseflow.geolocator.** { *; }
-keep class com.baseflow.permissionhandler.** { *; }

# Flutter Local Notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Gson 2.8.9 reads cached alarms through anonymous TypeToken subclasses.
# R8 full mode requires both the generic base and its subclasses to be kept.
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken { *; }

# Security hardening: Strip line numbers and debugging info in release
-renamesourcefileattribute SourceFile
-keepattributes SourceFile,LineNumberTable
