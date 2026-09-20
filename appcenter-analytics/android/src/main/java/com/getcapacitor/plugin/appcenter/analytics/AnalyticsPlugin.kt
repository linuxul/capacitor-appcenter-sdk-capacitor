package com.getcapacitor.plugin.appcenter.analytics

import com.getcapacitor.JSObject
import com.getcapacitor.Plugin
import com.getcapacitor.PluginCall
import com.getcapacitor.PluginMethod
import com.getcapacitor.annotation.CapacitorPlugin
import com.microsoft.appcenter.AppCenter
import com.microsoft.appcenter.analytics.Analytics
import com.microsoft.appcenter.reactnative.shared.AppCenterReactNativeShared
import org.json.JSONObject

@CapacitorPlugin(name = "Analytics")
public class AnalyticsPlugin : Plugin() {
    private val implementation = AnalyticsBase()

    override fun load() {
        AppCenterReactNativeShared.configureAppCenter(activity.application)

        // todo: get additional config options

        if (AppCenter.isConfigured()) {
            AppCenter.start(Analytics::class.java)
        }
    }

    @PluginMethod(returnType = PluginMethod.RETURN_NONE)
    public fun setEnabled(call: PluginCall) {
        implementation.enable(call.getBoolean("enable", false) ?: false)
        call.resolve()
    }

    @PluginMethod(returnType = PluginMethod.RETURN_NONE)
    public fun pause(call: PluginCall) {
        implementation.pause()
        call.resolve()
    }

    @PluginMethod(returnType = PluginMethod.RETURN_NONE)
    public fun resume(call: PluginCall) {
        implementation.resume()
        call.resolve()
    }

    @PluginMethod
    public fun isEnabled(call: PluginCall) {
        val ret = JSObject()
        ret.put("value", implementation.isEnabled)
        call.resolve(ret)
    }

    @PluginMethod(returnType = PluginMethod.RETURN_NONE)
    public fun trackEvent(call: PluginCall) {
        if (!call.data.has("name")) {
            call.reject("Must provide an event name")
            return
        }
        val name = call.getString("name")

        val flag = call.getString("flag", "normal") ?: "normal"

        val properties = mapFromJSON(call.getObject("properties", JSObject()))

        implementation.trackEvent(name, properties, flag)
    }

    @PluginMethod(returnType = PluginMethod.RETURN_NONE)
    public fun enableManualSessionTracker(call: PluginCall) {
        implementation.enableManualSessionTracker()
        call.resolve()
    }

    @PluginMethod(returnType = PluginMethod.RETURN_NONE)
    public fun startSession(call: PluginCall) {
        implementation.startSession()
        call.resolve()
    }

    private companion object {
        private fun mapFromJSON(jsonObject: JSONObject?): Map<String, String>? {
            if (jsonObject == null) {
                return null
            }
            val map = HashMap<String, String>()
            for (key in jsonObject.keys()) {
                // Only support storing strings. Non-string data must be stringified in JS.
                map[key] = jsonObject.optString(key)
            }
            return map
        }
    }
}
