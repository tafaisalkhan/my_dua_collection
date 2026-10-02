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

# Keep App Native Kotlin Classes, Services & Receivers
-keep class com.myfavourite.duas.** { *; }
-keepclassmembers class com.myfavourite.duas.** { *; }

# Google Mobile Ads SDK
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.ads.** { *; }
-dontwarn com.google.android.gms.ads.**

# SQLite & Drift
-keep class org.sqlite.** { *; }
-keep class io.simonbinder.sqlite3.** { *; }
-keep class com.simonbinder.sqlite3.** { *; }
-dontwarn org.sqlite.**
-dontwarn io.simonbinder.sqlite3.**

# Flutter Local Notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-dontwarn com.dexterous.flutterlocalnotifications.**

# Receive Sharing Intent
-keep class com.dishank.receive_sharing_intent.** { *; }
-dontwarn com.dishank.receive_sharing_intent.**

# Tesseract OCR
-keep class io.paratoner.tesseract_ocr.** { *; }
-dontwarn io.paratoner.tesseract_ocr.**

# Audio & Video
-keep class com.ryanheise.just_audio.** { *; }
-keep class com.ryanheise.audio_session.** { *; }
-keep class io.flutter.plugins.videoplayer.** { *; }
-dontwarn com.google.android.exoplayer2.**
-dontwarn androidx.media3.**

# Shared Preferences & Path Provider & Image Picker
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep class io.flutter.plugins.pathprovider.** { *; }
-keep class io.flutter.plugins.imagepicker.** { *; }
