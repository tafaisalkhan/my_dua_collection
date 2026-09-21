package com.favoritedua.favorite_dua

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import org.json.JSONArray
import org.json.JSONObject
import java.util.Calendar

object DuaBundleScheduler {
    private const val PREFS = "dua_bundle_schedules"

    fun schedule(
        context: Context,
        id: String,
        name: String,
        titles: ArrayList<String>,
        audioPaths: ArrayList<String>,
        repeats: ArrayList<Int>,
        hour: Int,
        minute: Int,
        frequency: String,
        weekday: Int,
        dayOfMonth: Int,
        persist: Boolean = true,
        afterFiring: Boolean = false
    ) {
        if (persist) {
            val json = JSONObject()
                .put("name", name)
                .put("titles", JSONArray(titles))
                .put("audioPaths", JSONArray(audioPaths))
                .put("repeats", JSONArray(repeats))
                .put("hour", hour)
                .put("minute", minute)
                .put("frequency", frequency)
                .put("weekday", weekday)
                .put("dayOfMonth", dayOfMonth)
            context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
                .edit().putString(id, json.toString()).apply()
        }
        val now = Calendar.getInstance()
        val next = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, hour)
            set(Calendar.MINUTE, minute)
            set(Calendar.SECOND, 0)
            set(Calendar.MILLISECOND, 0)
            when (frequency) {
                "weekly" -> {
                    set(Calendar.DAY_OF_WEEK, if (weekday == 7) Calendar.SUNDAY else weekday + 1)
                    if (!after(now) || afterFiring) add(Calendar.WEEK_OF_YEAR, 1)
                }
                "monthly" -> {
                    set(Calendar.DAY_OF_MONTH, dayOfMonth.coerceIn(1, 28))
                    if (!after(now) || afterFiring) add(Calendar.MONTH, 1)
                }
                else -> if (!after(now) || afterFiring) add(Calendar.DAY_OF_YEAR, 1)
            }
        }
        val alarm = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val pending = pendingIntent(context, id, name, titles, audioPaths, repeats, hour, minute, frequency, weekday, dayOfMonth)
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.S || alarm.canScheduleExactAlarms()) {
            alarm.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, next.timeInMillis, pending)
        } else {
            alarm.setAndAllowWhileIdle(AlarmManager.RTC_WAKEUP, next.timeInMillis, pending)
        }
    }

    fun cancel(context: Context, id: String) {
        context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).edit().remove(id).apply()
        val alarm = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        alarm.cancel(pendingIntent(context, id, "", arrayListOf(), arrayListOf(), arrayListOf(), 0, 0, "daily", 1, 1))
    }

    fun restoreAll(context: Context) {
        for ((id, raw) in context.getSharedPreferences(PREFS, Context.MODE_PRIVATE).all) {
            val json = runCatching { JSONObject(raw as String) }.getOrNull() ?: continue
            schedule(
                context, id, json.optString("name", "Dua Bundle"),
                json.getJSONArray("titles").toStringList(),
                json.getJSONArray("audioPaths").toStringList(),
                json.getJSONArray("repeats").toIntList(),
                json.optInt("hour", 8), json.optInt("minute", 0),
                json.optString("frequency", "daily"), json.optInt("weekday", 1),
                json.optInt("dayOfMonth", 1), persist = false
            )
        }
    }

    private fun pendingIntent(
        context: Context, id: String, name: String, titles: ArrayList<String>,
        audioPaths: ArrayList<String>, repeats: ArrayList<Int>, hour: Int, minute: Int,
        frequency: String, weekday: Int, dayOfMonth: Int
    ): PendingIntent {
        val intent = Intent(context, DuaBundleReceiver::class.java).apply {
            action = "com.favoritedua.PLAY_BUNDLE"
            putExtra("id", id); putExtra("name", name)
            putStringArrayListExtra("titles", titles)
            putStringArrayListExtra("audioPaths", audioPaths)
            putIntegerArrayListExtra("repeats", repeats)
            putExtra("hour", hour); putExtra("minute", minute)
            putExtra("frequency", frequency); putExtra("weekday", weekday)
            putExtra("dayOfMonth", dayOfMonth)
        }
        return PendingIntent.getBroadcast(context, id.hashCode(), intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
    }

    private fun JSONArray.toStringList() = ArrayList<String>().also { out ->
        for (index in 0 until length()) out.add(getString(index))
    }
    private fun JSONArray.toIntList() = ArrayList<Int>().also { out ->
        for (index in 0 until length()) out.add(getInt(index))
    }
}