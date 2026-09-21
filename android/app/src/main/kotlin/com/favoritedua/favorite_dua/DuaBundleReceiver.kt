package com.favoritedua.favorite_dua

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat

class DuaBundleReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED || intent.action == Intent.ACTION_MY_PACKAGE_REPLACED) {
            DuaBundleScheduler.restoreAll(context)
            return
        }
        val id = intent.getStringExtra("id") ?: return
        val name = intent.getStringExtra("name") ?: "Dua Bundle"
        val titles = intent.getStringArrayListExtra("titles") ?: arrayListOf()
        val paths = intent.getStringArrayListExtra("audioPaths") ?: arrayListOf()
        val repeats = intent.getIntegerArrayListExtra("repeats") ?: arrayListOf()
        val hour = intent.getIntExtra("hour", 8)
        val minute = intent.getIntExtra("minute", 0)
        val frequency = intent.getStringExtra("frequency") ?: "daily"
        val weekday = intent.getIntExtra("weekday", 1)
        val dayOfMonth = intent.getIntExtra("dayOfMonth", 1)
        DuaBundleScheduler.schedule(context, id, name, titles, paths, repeats, hour, minute, frequency, weekday, dayOfMonth, afterFiring = true)

        val manager = context.getSystemService(NotificationManager::class.java)
        manager.createNotificationChannel(NotificationChannel("dua_bundle_reminders", "Dua bundle reminders", NotificationManager.IMPORTANCE_HIGH))
        val launch = context.packageManager.getLaunchIntentForPackage(context.packageName) ?: Intent(context, MainActivity::class.java)
        manager.notify(id.hashCode(), NotificationCompat.Builder(context, "dua_bundle_reminders")
            .setSmallIcon(context.applicationInfo.icon)
            .setContentTitle(name)
            .setContentText("Playing ${paths.size} selected Duas")
            .setStyle(NotificationCompat.BigTextStyle().bigText(titles.joinToString(" • ")))
            .setContentIntent(PendingIntent.getActivity(context, id.hashCode(), launch, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE))
            .setAutoCancel(true).build())

        if (paths.isNotEmpty()) {
            ContextCompat.startForegroundService(context, Intent(context, DuaPlaybackService::class.java).apply {
                putExtra("title", name)
                putStringArrayListExtra("audioPaths", paths)
                putIntegerArrayListExtra("audioRepeats", repeats)
            })
        }
    }
}