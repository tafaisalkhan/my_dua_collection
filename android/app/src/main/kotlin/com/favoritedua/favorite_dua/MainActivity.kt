package com.favoritedua.favorite_dua

import android.app.AlarmManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "favorite_dua/audio_schedule")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "schedule" -> {
                        val id = call.argument<String>("id")
                        val title = call.argument<String>("title")
                        val audioPath = call.argument<String>("audioPath")
                        val hour = call.argument<Int>("hour")
                        val minute = call.argument<Int>("minute")
                        val repeats = call.argument<Int>("repeats") ?: 3
                        val mode = call.argument<String>("mode") ?: "notification"
                        val category = call.argument<String>("category") ?: ""
                        val duaText = call.argument<String>("duaText") ?: ""
                        if (id == null || title == null || hour == null || minute == null || (mode != "notification" && audioPath == null)) {
                            result.error("invalid_arguments", "Missing schedule information", null)
                        } else {
                            DuaAlarmScheduler.schedule(this, id, title, audioPath, hour, minute, repeats, mode, category = category, duaText = duaText)
                            result.success(true)
                        }
                    }
                    "scheduleBundle" -> {
                        val id = call.argument<String>("id") ?: "primary_dua_bundle"
                        val name = call.argument<String>("name") ?: "Dua Bundle"
                        val titles = ArrayList(call.argument<List<String>>("titles") ?: emptyList())
                        val audioPaths = ArrayList(call.argument<List<String>>("audioPaths") ?: emptyList())
                        val repeats = ArrayList(call.argument<List<Int>>("repeats") ?: emptyList())
                        val hour = call.argument<Int>("hour") ?: 8
                        val minute = call.argument<Int>("minute") ?: 0
                        val frequency = call.argument<String>("frequency") ?: "daily"
                        val weekday = call.argument<Int>("weekday") ?: 1
                        val dayOfMonth = call.argument<Int>("dayOfMonth") ?: 1
                        if (audioPaths.isEmpty()) {
                            result.error("invalid_arguments", "Select at least one Dua with voice", null)
                        } else {
                            DuaBundleScheduler.schedule(this, id, name, titles, audioPaths, repeats, hour, minute, frequency, weekday, dayOfMonth)
                            result.success(true)
                        }
                    }
                    "cancelBundle" -> {
                        call.argument<String>("id")?.let { DuaBundleScheduler.cancel(this, it) }
                        result.success(true)
                    }
                    "requestExactTiming" -> {
                    val alarm = getSystemService(Context.ALARM_SERVICE) as AlarmManager
                    val allowed = Build.VERSION.SDK_INT < Build.VERSION_CODES.S || alarm.canScheduleExactAlarms()
                    if (!allowed && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                        startActivity(Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM).apply {
                            data = Uri.parse("package:$packageName")
                        })
                    }
                    result.success(allowed)
                }
                "cancel" -> {
                        call.argument<String>("id")?.let { DuaAlarmScheduler.cancel(this, it) }
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}


