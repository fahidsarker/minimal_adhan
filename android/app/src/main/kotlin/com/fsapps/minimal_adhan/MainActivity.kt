package com.fsapps.minimal_adhan

import android.content.ActivityNotFoundException
import android.content.ComponentName
import android.content.Intent
import android.content.pm.ActivityInfo
import android.content.pm.ResolveInfo
import android.media.MediaPlayer
import android.media.Ringtone
import android.media.RingtoneManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.net.Uri
import android.widget.Toast

val adhans = listOf("adhan_mecca.mp3", "adhan_medina.mp3");

class MainActivity : FlutterActivity() {


    var ringtone: Ringtone? = null;
    var mediaPlayer: MediaPlayer? = null;

    fun getToneURI(notifyID:Int):Uri{
        return RingtoneManager.getDefaultUri(if (notifyID == 2) RingtoneManager.TYPE_ALARM else RingtoneManager.TYPE_RINGTONE)
    }

    fun play(notifyID: Int) {
        stop()
        if (notifyID == 2 || notifyID == 3) {
            val notification = getToneURI(notifyID)

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
            }else if (call.method == "getToneURI"){
                result.success(getToneURI(call.arguments as Int).toString())
            } else if (call.method == "openPlayStore"){
                launchPlayStore(call.arguments as String);
                result.success(null)
            }
        }
    }

    private fun launchPlayStore(toastMessage: String?) {

        val appId = activity.packageName

        val rateIntent = Intent(
            Intent.ACTION_VIEW,
            Uri.parse("market://details?id=$appId")
        )
        var marketFound = false

        // find all applications able to handle our rateIntent
        val otherApps: List<ResolveInfo> = activity.packageManager
            .queryIntentActivities(rateIntent, 0)
        for (otherApp in otherApps) {
            // look for Google Play application
            if (otherApp.activityInfo.applicationInfo.packageName
                    .equals("com.android.vending")
            ) {
                val otherAppActivity: ActivityInfo = otherApp.activityInfo
                val componentName = ComponentName(
                    otherAppActivity.applicationInfo.packageName,
                    otherAppActivity.name
                )
                // make sure it does NOT open in the stack of your activity
                rateIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                // task reparenting if needed
                rateIntent.addFlags(Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED)
                // if the Google Play was already open in a search result
                //  this make sure it still go to the app page you requested
                rateIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                // this make sure only the Google Play app is allowed to
                // intercept the intent
                rateIntent.component = componentName
                if(toastMessage != null){
                    Toast.makeText(activity, toastMessage, Toast.LENGTH_SHORT).show()
                }
                activity.startActivity(rateIntent)
                marketFound = true
                break
            }
        }

        // if GP not present on device, open web browser
        if (!marketFound) {
            try {
                activity.startActivity(
                    Intent(
                        Intent.ACTION_VIEW,
                        Uri.parse("market://details?id=$appId")
                    )
                )
            } catch (e: ActivityNotFoundException) {
                activity.startActivity(
                    Intent(
                        Intent.ACTION_VIEW,
                        Uri.parse("https://play.google.com/store/apps/details?id=$appId")
                    )
                )
            }
        }

    }
}
