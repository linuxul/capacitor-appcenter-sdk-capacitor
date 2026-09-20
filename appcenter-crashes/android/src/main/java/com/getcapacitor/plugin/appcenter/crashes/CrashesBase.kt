package com.getcapacitor.plugin.appcenter.crashes

import com.getcapacitor.JSArray
import com.getcapacitor.JSObject
import com.microsoft.appcenter.AppCenter
import com.microsoft.appcenter.crashes.Crashes
import com.microsoft.appcenter.crashes.WrapperSdkExceptionManager
import com.microsoft.appcenter.crashes.ingestion.models.ErrorAttachmentLog

public class CrashesBase {
    /**
     * Track a handled custom exception
     * @param exception - JSObject containing AppCenter crashes.ingestion.models.Exception properties
     * @param properties - JSObject containing any custom properties for the exception
     * @param attachments - JSArray containing objects of  to save with the exception
     * @return
     */
    public fun trackException(exception: JSObject?, properties: JSObject?, attachments: JSArray?): String? {
        val exceptionModel = CrashesUtil.toExceptionModel(exception)

        val convertedProperties = properties?.let { CrashesUtil.convertJSObjectToStringMap(it) }

        val convertedAttachments = attachments?.let { CrashesUtil.toCustomErrorAttachments(it) }

        return WrapperSdkExceptionManager.trackException(exceptionModel, convertedProperties, convertedAttachments)
    }

    /**
     * Track a handled error with name and optional properties and attachments.
     * @param error Error to track
     * @param properties
     * @param attachments
     */
    @JvmOverloads
    public fun trackError(error: Throwable, properties: Map<String, String>? = null, attachments: Iterable<ErrorAttachmentLog>? = null) {
        Crashes.trackError(error, properties, attachments)
    }

    public fun enable(enabled: Boolean) {
        Crashes.setEnabled(enabled).get()
    }

    public val isEnabled: Boolean
        get() = Crashes.isEnabled().get()

    public fun start() {
        if (AppCenter.isConfigured()) {
            AppCenter.start(Crashes::class.java)
        }
    }

    public fun generateTestCrash() {
        Crashes.generateTestCrash()
    }

    public fun hasReceivedMemoryWarningInLastSession(): Boolean = Crashes.hasReceivedMemoryWarningInLastSession().get()

    public fun hasCrashedInLastSession(): Boolean = Crashes.hasCrashedInLastSession().get()

    public fun lastSessionCrashReport(): JSObject? = CrashesUtil.convertReportToJs(Crashes.getLastSessionCrashReport().get())
}
