package com.favoritedua.favorite_dua

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.os.IBinder
import android.os.PowerManager
import androidx.core.app.NotificationCompat
import java.io.File

class DuaPlaybackService : Service() {
    private var player: MediaPlayer? = null
    private var playlist = listOf<String>()
    private var index = 0

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val title = intent?.getStringExtra("title") ?: "Scheduled Dua"
        val paths = intent?.getStringArrayListExtra("audioPaths")
        val repeats = intent?.getIntegerArrayListExtra("audioRepeats")
        playlist = if (!paths.isNullOrEmpty()) {
            buildList {
                paths.forEachIndexed { itemIndex, path ->
                    repeat((repeats?.getOrNull(itemIndex) ?: 1).coerceIn(1, 10)) { add(path) }
                }
            }
        } else {
            val path = intent?.getStringExtra("audioPath") ?: return START_NOT_STICKY
            List(intent.getIntExtra("repeats", 3).coerceIn(1, 10)) { path }
        }.filter { File(it).exists() }
        if (playlist.isEmpty()) { stopSelf(); return START_NOT_STICKY }

        createChannel()
        val launchIntent = packageManager.getLaunchIntentForPackage(packageName) ?: Intent(this, MainActivity::class.java)
        val openApp = PendingIntent.getActivity(this, 0, launchIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        startForeground(2301, NotificationCompat.Builder(this, "scheduled_dua_audio")
            .setSmallIcon(applicationInfo.icon)
            .setContentTitle(title)
            .setContentText("Playing ${playlist.size} Dua recitations")
            .setContentIntent(openApp)
            .setOngoing(true)
            .build())
        index = 0
        playCurrent()
        return START_NOT_STICKY
    }

    private fun playCurrent() {
        if (index >= playlist.size) { stopSelf(); return }
        player?.release()
        player = MediaPlayer().apply {
            setWakeMode(applicationContext, PowerManager.PARTIAL_WAKE_LOCK)
            setAudioAttributes(AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_ALARM)
                .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
                .build())
            setVolume(1.0f, 1.0f)
            setDataSource(playlist[index])
            setOnPreparedListener { it.start() }
            setOnCompletionListener { index++; playCurrent() }
            setOnErrorListener { _, _, _ -> index++; playCurrent(); true }
            prepareAsync()
        }
    }

    private fun createChannel() {
        getSystemService(NotificationManager::class.java).createNotificationChannel(
            NotificationChannel("scheduled_dua_audio", "Scheduled Dua playback", NotificationManager.IMPORTANCE_LOW)
        )
    }

    override fun onDestroy() { player?.release(); player = null; super.onDestroy() }
    override fun onBind(intent: Intent?): IBinder? = null
}