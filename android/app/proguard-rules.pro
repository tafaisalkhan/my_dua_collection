# ProGuard / R8 rules for Favorite Dua app

# Ignore missing optional dependencies in Flutter engine
-dontwarn com.google.android.play.core.**
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

# Keep Flutter wrapper & embedding classes
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }

# Keep App Native Kotlin Classes & Receivers
-keep class com.myfavourite.duas.** { *; }
-keepclassmembers class com.myfavourite.duas.** { *; }

# Google Mobile Ads SDK
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.ads.** { *; }
-dontwarn com.google.android.gms.ads.**

# SQLite & Drift
-keep class org.sqlite.** { *; }
-dontwarn org.sqlite.**

# Flutter Local Notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }
