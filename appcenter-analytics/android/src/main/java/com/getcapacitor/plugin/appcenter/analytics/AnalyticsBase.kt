package com.getcapacitor.plugin.appcenter.analytics

import com.microsoft.appcenter.AppCenter
import com.microsoft.appcenter.Flags
import com.microsoft.appcenter.analytics.Analytics

public class AnalyticsBase {
    public fun trackEvent(name: String?, properties: Map<String, String>?, flag: String) {
        val analyticsFlag =
            when (flag) {
                "critical" -> Flags.CRITICAL
                "normal" -> Flags.NORMAL
                else -> Flags.NORMAL
            }
        Analytics.trackEvent(name, properties, analyticsFlag)
    }

    public fun setTransmissionInterval(seconds: Int) {
        Analytics.setTransmissionInterval(seconds)
    }

    public fun start() {
        AppCenter.start(Analytics::class.java)
    }

    public fun pause() {
        Analytics.pause()
    }

    public fun resume() {
        Analytics.resume()
    }

    public fun enable(enable: Boolean) {
        Analytics.setEnabled(enable).get()
    }

    public val isEnabled: Boolean
        get() = Analytics.isEnabled().get()

    public fun enableManualSessionTracker() {
        Analytics.enableManualSessionTracker()
    }

    public fun startSession() {
        Analytics.startSession()
    }
}
