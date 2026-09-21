package com.favoritedua.favorite_dua

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import java.util.Calendar

object DuaAlarmScheduler {
    private const val PREFS = "dua_audio_schedules"

    fun schedule(
        context: Context,
        id: String,
        title: String,
        audioPath: String?,
        hour: Int,
        minute: Int,
        repeats: Int,
        mode: String = "notification",
        persist: Boolean = true,
        afterFiring: Boolean = false,
        category: String = "",
        duaText: String = ""
    ) {
        if (persist) {
            context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).edit()
                .putString(
                    id,
                    listOf(title, audioPath ?: "", hour, minute, repeats, mode, category, duaText)
                        .joinToString("\u001f")
                ).apply()
        }
        val now = Calendar.getInstance()
        val isCurrentMinute = now.get(Calendar.HOUR_OF_DAY) == hour &&
                now.get(Calendar.MINUTE) == minute
        val next = Calendar.getInstance().apply {
            if (isCurrentMinute && !afterFiring) {
                timeInMillis = now.timeInMillis + 5_000
            } else {
                set(Calendar.HOUR_OF_DAY, hour)
                set(Calendar.MINUTE, minute)
                set(Calendar.SECOND, 0)
                set(Calendar.MILLISECOND, 0)
                if (!after(now)) add(Calendar.DAY_OF_YEAR, 1)
            }
        }
        val alarm = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val pending = pendingIntent(
            context, id, title, audioPath, hour, minute, repeats, mode, category, duaText
        )
        try {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S || alarm.canScheduleExactAlarms()) {
                alarm.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, next.timeInMillis, pending)
            } else {
                alarm.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, next.timeInMillis, pending)
            }
        } catch (_: SecurityException) {
            alarm.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, next.timeInMillis, pending)
        }
    }

    fun cancel(context: Context, id: String) {
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).edit().remove(id).apply()
        val alarm = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        alarm.cancel(pendingIntent(context, id, "", null, 0, 0, 1))
    }

    fun restoreAll(context: Context) {
        for ((id, raw) in context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).all) {
            val parts = (raw as? String)?.split("\u001f") ?: continue
            if (parts.size < 5) continue
            schedule(
                context = context,
                id = id,
                title = parts[0],
                audioPath = parts[1],
                hour = parts[2].toIntOrNull() ?: continue,
                minute = parts[3].toIntOrNull() ?: continue,
                repeats = parts[4].toIntOrNull() ?: 3,
                mode = if (parts.size > 5) parts[5] else "play",
                persist = false,
                category = if (parts.size > 6) parts[6] else "",
                duaText = if (parts.size > 7) parts[7] else ""
            )
        }
    }

    private fun pendingIntent(
        context: Context,
        id: String,
        title: String,
        audioPath: String?,
        hour: Int,
        minute: Int,
        repeats: Int,
        mode: String = "notification",
        category: String = "",
        duaText: String = ""
    ): PendingIntent {
        val intent = Intent(context, DuaAlarmReceiver::class.java).apply {
            action = "com.favoritedua.PLAY_DUA"
            putExtra("id", id)
            putExtra("title", title)
            putExtra("audioPath", audioPath)
            putExtra("hour", hour)
            putExtra("minute", minute)
            putExtra("repeats", repeats)
            putExtra("mode", mode)
            putExtra("category", category)
            putExtra("duaText", duaText)
        }
        return PendingIntent.getBroadcast(
            context,
            id.hashCode(),
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
    }
}