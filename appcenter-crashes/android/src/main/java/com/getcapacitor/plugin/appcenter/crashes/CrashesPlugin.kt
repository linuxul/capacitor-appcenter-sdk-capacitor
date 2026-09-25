package com.getcapacitor.plugin.appcenter.crashes

import com.getcapacitor.JSObject
import com.getcapacitor.Plugin
import com.getcapacitor.PluginCall
import com.getcapacitor.PluginException
import com.getcapacitor.PluginMethod
import com.getcapacitor.annotation.CapacitorPlugin
import com.microsoft.appcenter.reactnative.shared.AppCenterReactNativeShared

@CapacitorPlugin(name = "Crashes")
public class CrashesPlugin : Plugin() {
    private val implementation = CrashesBase()

    override fun load() {
        AppCenterReactNativeShared.configureAppCenter(activity.application)
        implementation.start()
    }

    @PluginMethod
    public fun trackError(call: PluginCall) {
        val error = call.getObject("error")
        val properties = call.getObject("properties")
        val attachments = call.getArray("attachments")

        val errorReportId: String?
        try {
            // We call trackException here and not trackError because the error is a custom error
            // parsed from JS instead of a Throwable error. It ends up the same in AppCenter
            errorReportId = implementation.trackException(error, properties, attachments)
        } catch (e: Exception) {
            throw PluginException("Exception while tracking error: " + e.message, cause = e)
        }

        val ret = JSObject()
        ret.put("value", errorReportId)
        call.resolve(ret)
    }

    @PluginMethod(returnType = PluginMethod.RETURN_NONE)
    public fun setEnabled(call: PluginCall) {
        implementation.enable(call.getBoolean("enable", false) ?: false)
        call.resolve()
    }

    @PluginMethod
    public fun isEnabled(call: PluginCall) {
        val ret = JSObject()
        ret.put("value", implementation.isEnabled)
        call.resolve(ret)
    }

    @PluginMethod(returnType = PluginMethod.RETURN_NONE)
    public fun generateTestCrash(call: PluginCall) {
        implementation.generateTestCrash()
        call.resolve()
    }

    @PluginMethod
    public fun hasReceivedMemoryWarningInLastSession(call: PluginCall) {
        val ret = JSObject()
        ret.put("value", implementation.hasReceivedMemoryWarningInLastSession())
        call.resolve(ret)
    }

    @PluginMethod
    public fun hasCrashedInLastSession(call: PluginCall) {
        val ret = JSObject()
        ret.put("value", implementation.hasCrashedInLastSession())
        call.resolve(ret)
    }

    @PluginMethod
    public fun lastSessionCrashReport(call: PluginCall) {
        val lastSessionCrashReport = implementation.lastSessionCrashReport()
            ?: throw PluginException("No crash report available")
        val ret = JSObject()
        ret.put("value", lastSessionCrashReport)
        call.resolve(ret)
    }
}
