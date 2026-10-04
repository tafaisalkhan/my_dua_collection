# ProGuard / R8 rules for Favorite Dua app

# Preserve annotations, line numbers, and generic signatures
-keepattributes *Annotation*,Signature,InnerClasses,EnclosingMethod,Exceptions,LineNumberTable,SourceFile

# Ignore missing optional dependencies in Flutter engine & third party libraries
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.engine.deferredcomponents.**
-dontwarn com.google.android.gms.ads.**
-dontwarn com.google.android.exoplayer2.**
-dontwarn androidx.media3.**
-dontwarn org.sqlite.**
-dontwarn io.simonbinder.sqlite3.**
-dontwarn com.dexterous.flutterlocalnotifications.**
-dontwarn com.dishank.receive_sharing_intent.**
-dontwarn io.paratoner.tesseract_ocr.**

# Keep Flutter wrapper, engine & embedding classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.provider.Implementation { *; }
-keep class * implements io.flutter.plugin.common.MethodChannel$MethodCallHandler { *; }
-keep class * implements io.flutter.plugin.common.PluginRegistry$Registrar { *; }
-keep class * implements io.flutter.plugin.common.PluginRegistry$PluginRegistrantCallback { *; }

# Keep App Native Kotlin Classes, Services & Receivers
-keep class com.myfavourite.duas.** { *; }
-keepclassmembers class com.myfavourite.duas.** { *; }

# Google Mobile Ads SDK
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.ads.** { *; }

# SQLite & Drift Native Bindings
-keep class org.sqlite.** { *; }
-keep class io.simonbinder.sqlite3.** { *; }
-keep class com.simonbinder.sqlite3.** { *; }

# Flutter Plugins (keep all plugin classes)
-keep class io.flutter.plugins.** { *; }
-keep class dev.flutter.plugins.** { *; }
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep class com.dishank.receive_sharing_intent.** { *; }
-keep class io.paratoner.tesseract_ocr.** { *; }
-keep class com.ryanheise.** { *; }
-keep class io.flutter.plugins.videoplayer.** { *; }

# Keep all JNI native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep enum fields for Reflection / Serialization
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
