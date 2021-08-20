package com.fsapps.minimal_adhan

import android.media.MediaPlayer
import android.media.Ringtone
import android.media.RingtoneManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

val adhans = listOf("adhan_mecca.mp3", "adhan_medina.mp3");

class MainActivity : FlutterActivity() {


    var ringtone: Ringtone? = null;
    var mediaPlayer: MediaPlayer? = null;


    fun play(notifyID: Int) {
        stop()
        if (notifyID == 2 || notifyID == 3) {
            val notification =
                RingtoneManager.getDefaultUri(if (notifyID == 2) RingtoneManager.TYPE_ALARM else RingtoneManager.TYPE_RINGTONE)
            ringtone = RingtoneManager.getRingtone(applicationContext, notification)
            ringtone?.play()
        } else {
            val adhan = when (notifyID) {
                4 -> R.raw.adhan_mecca;
                5 -> R.raw.adhan_medina;
                else -> throw IllegalAccessError("No Adhan added")
            }
            mediaPlayer = MediaPlayer.create(this, adhan)
            mediaPlayer?.start()
        }
    }

    fun stop() {
        ringtone?.stop();
        mediaPlayer?.stop();
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.fsapps.minimaladhan"
        ).setMethodCallHandler { call, result ->
            if (call.method == "play") {
                val notifyID = call.arguments as Int
                play(notifyID)
                result.success(notifyID);
            } else if (call.method == "stop") {
                stop()
                result.success(-1)
            } else if (call.method == "getAdhanName") {
                val notifyID = call.arguments as Int
            }
        }
    }
}
