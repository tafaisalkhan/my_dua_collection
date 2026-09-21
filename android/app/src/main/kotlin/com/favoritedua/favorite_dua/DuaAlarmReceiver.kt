package com.favoritedua.favorite_dua

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat

class DuaAlarmReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED || intent.action == Intent.ACTION_MY_PACKAGE_REPLACED) {
            DuaAlarmScheduler.restoreAll(context)
            return
        }
        val id = intent.getStringExtra("id") ?: return
        val title = intent.getStringExtra("title") ?: "Scheduled Dua"
        val audioPath = intent.getStringExtra("audioPath")?.takeIf { it.isNotEmpty() }
        val hour = intent.getIntExtra("hour", 8)
        val minute = intent.getIntExtra("minute", 0)
        val repeats = intent.getIntExtra("repeats", 3)
        val mode = intent.getStringExtra("mode") ?: "notification"
        val category = intent.getStringExtra("category") ?: ""
        val duaText = intent.getStringExtra("duaText") ?: ""
        DuaAlarmScheduler.schedule(context, id, title, audioPath, hour, minute, repeats, mode, persist = true, afterFiring = true, category = category, duaText = duaText)

        if (mode == "notification" || mode == "both") showReminder(context, id, title, category, duaText)
        if ((mode == "play" || mode == "both") && audioPath != null) {
            ContextCompat.startForegroundService(context, Intent(context, DuaPlaybackService::class.java).apply {
                putExtra("title", title)
                putExtra("audioPath", audioPath)
                putExtra("repeats", repeats)
            })
        }
    }

    private fun showReminder(context: Context, id: String, title: String, category: String, duaText: String) {
        val manager = context.getSystemService(NotificationManager::class.java)
        manager.createNotificationChannel(
            NotificationChannel("dua_time_reminders", "Dua time reminders", NotificationManager.IMPORTANCE_HIGH)
        )
        val launch = context.packageManager.getLaunchIntentForPackage(context.packageName)
            ?: Intent(context, MainActivity::class.java)
        val pending = PendingIntent.getActivity(
            context, id.hashCode(), launch,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        manager.notify(
            id.hashCode(),
            NotificationCompat.Builder(context, "dua_time_reminders")
                .setSmallIcon(context.applicationInfo.icon)
                .setContentTitle(if (category.isBlank()) title else "$category • $title")
                .setContentText(if (duaText.isBlank()) "It is time for your Dua" else duaText)
                .setStyle(NotificationCompat.BigTextStyle().bigText(if (duaText.isBlank()) "It is time for your Dua" else duaText))
                .setContentIntent(pending)
                .setAutoCancel(true)
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .build()
        )
    }
}
