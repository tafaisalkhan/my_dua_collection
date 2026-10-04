package com.myfavourite.duas

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class DuaBootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED ||
            intent.action == Intent.ACTION_MY_PACKAGE_REPLACED ||
            intent.action == "android.intent.action.QUICKBOOT_POWERON" ||
            intent.action == "com.htc.intent.action.QUICKBOOT_POWERON"
        ) {
            DuaAlarmScheduler.restoreAll(context)
            DuaBundleScheduler.restoreAll(context)
        }
    }
}
