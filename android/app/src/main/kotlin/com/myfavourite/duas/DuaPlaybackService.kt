package com.myfavourite.duas

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.net.Uri
import android.os.IBinder
import android.os.PowerManager
import android.util.Log
import androidx.core.app.NotificationCompat
import java.io.File

class DuaPlaybackService : Service() {
    private var player: MediaPlayer? = null
    private var playlist = listOf<String>()
    private var index = 0
    private var wakeLock: PowerManager.WakeLock? = null

    override fun onCreate() {
        super.onCreate()
        try {
            val powerManager = getSystemService(POWER_SERVICE) as PowerManager
            wakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "FavoriteDua:PlaybackWakeLock").apply {
                acquire(15 * 60 * 1000L) // Safe 15-minute maximum timeout
            }
        } catch (e: Exception) {
            Log.e("FavoriteDuaPlayback", "WakeLock acquire error: ${e.message}")
        }
    }

    private fun sanitizePath(raw: String?): String? {
        if (raw.isNullOrBlank()) return null
        val trimmed = raw.trim()
        return if (trimmed.startsWith("file://")) {
            Uri.parse(trimmed).path ?: trimmed
        } else {
            trimmed
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val title = intent?.getStringExtra("title") ?: "Scheduled Dua"
        val paths = intent?.getStringArrayListExtra("audioPaths")
        val repeats = intent?.getIntegerArrayListExtra("audioRepeats")
        
        val rawList = if (!paths.isNullOrEmpty()) {
            buildList {
                paths.forEachIndexed { itemIndex, path ->
                    val clean = sanitizePath(path)
                    if (clean != null) {
                        repeat((repeats?.getOrNull(itemIndex) ?: 1).coerceIn(1, 10)) { add(clean) }
                    }
                }
            }
        } else {
            val clean = sanitizePath(intent?.getStringExtra("audioPath"))
            if (clean != null) {
                List(intent?.getIntExtra("repeats", 3)?.coerceIn(1, 10) ?: 3) { clean }
            } else {
                emptyList()
            }
        }

        playlist = rawList.filter { path ->
            val file = File(path)
            val exists = file.exists()
            Log.d("FavoriteDuaPlayback", "Audio file check [$path] -> exists: $exists")
            exists
        }

        if (playlist.isEmpty()) {
            Log.w("FavoriteDuaPlayback", "Playlist is empty or files do not exist on disk. Stopping service.")
            stopSelf()
            return START_NOT_STICKY
        }

        createChannel()
        val launchIntent = packageManager.getLaunchIntentForPackage(packageName) ?: Intent(this, MainActivity::class.java)
        val openApp = PendingIntent.getActivity(this, 0, launchIntent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
        startForeground(2301, NotificationCompat.Builder(this, "scheduled_dua_audio")
            .setSmallIcon(applicationInfo.icon)
            .setContentTitle(title)
            .setContentText("Playing ${playlist.size} Dua recitation(s)")
            .setContentIntent(openApp)
            .setOngoing(true)
            .build())
        index = 0
        playCurrent()
        return START_NOT_STICKY
    }

    private fun playCurrent() {
        if (index >= playlist.size) {
            Log.d("FavoriteDuaPlayback", "Finished playing all audio items in playlist.")
            stopSelf()
            return
        }
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
            setOnErrorListener { _, what, extra ->
                Log.e("FavoriteDuaPlayback", "MediaPlayer error: what=$what, extra=$extra")
                index++
                playCurrent()
                true
            }
            prepareAsync()
        }
    }

    private fun createChannel() {
        getSystemService(NotificationManager::class.java).createNotificationChannel(
            NotificationChannel("scheduled_dua_audio", "Scheduled Dua playback", NotificationManager.IMPORTANCE_LOW)
        )
    }

    override fun onDestroy() {
        player?.release()
        player = null
        try {
            if (wakeLock?.isHeld == true) {
                wakeLock?.release()
            }
        } catch (_: Exception) {}
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null
}