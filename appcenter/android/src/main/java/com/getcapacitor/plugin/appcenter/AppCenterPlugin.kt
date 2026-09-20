package com.getcapacitor.plugin.appcenter

import com.getcapacitor.JSObject
import com.getcapacitor.Plugin
import com.getcapacitor.PluginCall
import com.getcapacitor.PluginMethod
import com.getcapacitor.annotation.CapacitorPlugin
import com.microsoft.appcenter.reactnative.shared.AppCenterReactNativeShared

@CapacitorPlugin(name = "AppCenter")
public class AppCenterPlugin : Plugin() {
    private val implementation = AppCenterBase()

    override fun load() {
        AppCenterReactNativeShared.configureAppCenter(activity.application)
    }

    @PluginMethod
    public fun getInstallId(call: PluginCall) {
        val ret = JSObject()
        ret.put("value", implementation.installId)
        call.resolve(ret)
    }

    @PluginMethod(returnType = PluginMethod.RETURN_NONE)
    public fun setUserId(call: PluginCall) {
        implementation.setUserId(call.getString("userId", null))
        call.resolve()
    }

    @PluginMethod
    public fun getSdkVersion(call: PluginCall) {
        val ret = JSObject()
        ret.put("value", implementation.sdkVersion)
        call.resolve(ret)
    }

    @PluginMethod
    public fun isEnabled(call: PluginCall) {
        val ret = JSObject()
        ret.put("value", implementation.isEnabled)
        call.resolve(ret)
    }

    @PluginMethod(returnType = PluginMethod.RETURN_NONE)
    public fun setEnabled(call: PluginCall) {
        implementation.enable(call.getBoolean("enabled", false) ?: false)
        call.resolve()
    }

    @PluginMethod
    public fun getLogLevel(call: PluginCall) {
        val ret = JSObject()
        ret.put("value", implementation.logLevel)
        call.resolve(ret)
    }

    @PluginMethod(returnType = PluginMethod.RETURN_NONE)
    public fun setLogLevel(call: PluginCall) {
        if (!call.data.has("logLevel")) {
            call.reject("Must provide a LogLevel")
            return
        }

        // A logLevel that is not an integer is null here. The Java code threw a NullPointerException
        // while unboxing it, which the `!!` keeps.
        implementation.logLevel = call.getInt("logLevel")!!
        call.resolve()
    }

    @PluginMethod(returnType = PluginMethod.RETURN_NONE)
    public fun setCustomProperties(call: PluginCall) {
        call.unavailable("Not available in appcenter 2.0.0 or later.")
    }

    @PluginMethod(returnType = PluginMethod.RETURN_NONE)
    public fun setNetworkRequestsAllowed(call: PluginCall) {
        implementation.isNetworkRequestsAllowed = call.getBoolean("isAllowed", true) ?: true
        call.resolve()
    }

    @PluginMethod
    public fun isNetworkRequestsAllowed(call: PluginCall) {
        val ret = JSObject()
        ret.put("value", implementation.isNetworkRequestsAllowed)
        call.resolve(ret)
    }

    @PluginMethod(returnType = PluginMethod.RETURN_NONE)
    public fun setCountryCode(call: PluginCall) {
        implementation.setCountryCode(call.getString("countryCode", null))
        call.resolve()
    }
}
