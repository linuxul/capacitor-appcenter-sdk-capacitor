package com.getcapacitor.plugin.appcenter.crashes

import android.util.Base64
import android.util.Log
import com.getcapacitor.JSArray
import com.getcapacitor.JSObject
import com.microsoft.appcenter.crashes.ingestion.models.ErrorAttachmentLog
import com.microsoft.appcenter.crashes.ingestion.models.Exception as ExceptionModel
import com.microsoft.appcenter.crashes.model.ErrorReport
import com.microsoft.appcenter.ingestion.models.Device
import java.util.LinkedList

/**
 * Utility class containing helpers for converting App Center objects.
 */
public object CrashesUtil {
    private const val LOG_TAG = "AppCenterCrashes"
    private const val DATA_FIELD = "data"
    private const val TEXT_FIELD = "text"
    private const val FILE_NAME_FIELD = "fileName"
    private const val CONTENT_TYPE_FIELD = "contentType"

    public fun logError(message: String) {
        Log.e(LOG_TAG, message)
    }

    internal fun logInfo(message: String) {
        Log.i(LOG_TAG, message)
    }

    internal fun logDebug(message: String) {
        Log.d(LOG_TAG, message)
    }

    /**
     * Creates an AppCenter Exception model out of JSObject.
     * Used for creating an actual Exception model out of passed in data from a plugin call from js.
     * @param jsObject JSObject to convert
     * @return AppCenter Exception model
     */
    public fun toExceptionModel(jsObject: JSObject?): ExceptionModel {
        val model = ExceptionModel()
        try {
            model.read(jsObject)
            if (model.type.isNullOrEmpty()) {
                throw Exception("Type value shouldn't be null or empty")
            }
            if (model.message.isNullOrEmpty()) {
                throw Exception("Message value shouldn't be null or empty")
            }
            if (model.wrapperSdkName.isNullOrEmpty()) {
                throw Exception("wrapperSdkName value shouldn't be null or empty")
            }
        } catch (e: Exception) {
            logError("Failed to get exception model")
            logError(Log.getStackTraceString(e))
        }
        return model
    }

    /**
     * Converts JSObject to String Map
     * @param jsObject JSObject to convert
     * @return String map
     */
    public fun convertJSObjectToStringMap(jsObject: JSObject?): Map<String, String?> {
        val stringMap = HashMap<String, String?>()
        if (jsObject != null) {
            for (key in jsObject.keys()) {
                stringMap[key] = jsObject.getString(key)
            }
        }
        return stringMap
    }

    /**
     * Creates a Collection of AppCenter ErrorAttachmentLog from a JSArray of attachment objects
     * Used for extracting attachments from a plugin call from js to be able to upload it to AppCenter.
     * @param attachments JSArray of attachment objects
     * @return Collection of ErrorAttachmentLog
     */
    public fun toCustomErrorAttachments(attachments: JSArray): Collection<ErrorAttachmentLog> {
        val attachmentLogs = LinkedList<ErrorAttachmentLog>()
        try {
            for (i in 0 until attachments.length()) {
                val jsAttachment = attachments.getJSONObject(i)
                var fileName: String? = null
                if (jsAttachment.has(FILE_NAME_FIELD)) {
                    fileName = jsAttachment.getString(FILE_NAME_FIELD)
                }
                if (jsAttachment.has(TEXT_FIELD)) {
                    val text = jsAttachment.getString(TEXT_FIELD)
                    attachmentLogs.add(ErrorAttachmentLog.attachmentWithText(text, fileName))
                } else {
                    val encodedData = jsAttachment.getString(DATA_FIELD)
                    val data = Base64.decode(encodedData, Base64.DEFAULT)
                    val contentType = jsAttachment.getString(CONTENT_TYPE_FIELD)
                    attachmentLogs.add(ErrorAttachmentLog.attachmentWithBinary(data, fileName, contentType))
                }
            }
        } catch (e: Exception) {
            logError("Failed to get error attachment for report: $attachments")
            logError(Log.getStackTraceString(e))
        }
        return attachmentLogs
    }

    /**
     * Serializes App Center Device properties to Dictionary
     * @param device App Center Device
     * @return Device Dictionary
     */
    public fun serializeDeviceToJs(device: Device?): JSObject? {
        if (device == null) {
            return null
        }
        val dict = JSObject()

        dict.put("sdkName", device.sdkName)
        dict.put("sdkVersion", device.sdkVersion)
        dict.put("model", device.model)
        dict.put("oemName", device.oemName)
        dict.put("osName", device.osName)
        dict.put("osVersion", device.osVersion)
        if (device.osBuild != null) {
            dict.put("osBuild", device.osBuild)
        }
        if (device.osApiLevel != null) {
            dict.put("osApiLevel", device.osApiLevel as Any?)
        }
        dict.put("locale", device.locale)
        // The offset is a boxed Integer that may be null, which removes the key instead of failing to unbox
        dict.put("timeZoneOffset", device.timeZoneOffset as Any?)
        dict.put("screenSize", device.screenSize)
        dict.put("appVersion", device.appVersion)
        if (device.carrierName != null) {
            dict.put("carrierName", device.carrierName)
        }
        if (device.carrierCountry != null) {
            dict.put("carrierCountry", device.carrierCountry)
        }
        dict.put("appBuild", device.appBuild)
        if (device.appNamespace != null) {
            dict.put("appNamespace", device.appNamespace)
        }

        return dict
    }

    /**
     * Converts App Center ErrorReport to Dictionary
     * @param report App Center ErrorReport
     * @return JS optional Dictionary
     */
    public fun convertReportToJs(report: ErrorReport?): JSObject? {
        if (report == null) {
            return null
        }

        val dict = JSObject()

        dict.put("id", report.id)

        report.threadName?.let { dict.put("threadName", it) }

        report.stackTrace?.let { dict.put("stackTrace", it) }

        report.appStartTime?.let { dict.put("appStartTime", it.time.toString()) }

        report.appErrorTime?.let { dict.put("appErrorTime", it.time.toString()) }

        dict.put("device", serializeDeviceToJs(report.device))

        return dict
    }

    /**
     * Converts list of App Center ErrorReports to a list of maps
     * @param reports App Center ErrorReport list
     * @return List of maps
     */
    public fun convertReportsToJs(reports: List<ErrorReport>?): List<JSObject> {
        if (reports == null) {
            return ArrayList()
        }

        return reports.mapNotNullTo(ArrayList()) { convertReportToJs(it) }
    }
}
