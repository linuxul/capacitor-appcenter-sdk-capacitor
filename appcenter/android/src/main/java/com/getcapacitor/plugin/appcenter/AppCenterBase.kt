package com.getcapacitor.plugin.appcenter

import com.microsoft.appcenter.AppCenter

public class AppCenterBase {
    public var isNetworkRequestsAllowed: Boolean
        get() = AppCenter.isNetworkRequestsAllowed()
        set(shouldAllow) = AppCenter.setNetworkRequestsAllowed(shouldAllow)

    public var logLevel: Int
        get() = AppCenter.getLogLevel()
        set(level) = AppCenter.setLogLevel(level)

    public val installId: String?
        get() = AppCenter.getInstallId().get()?.toString()

    public val sdkVersion: String?
        get() = AppCenter.getSdkVersion()

    public fun setUserId(userId: String?) {
        AppCenter.setUserId(userId)
    }

    public fun enable(enabled: Boolean) {
        AppCenter.setEnabled(enabled).get()
    }

    public val isEnabled: Boolean
        get() = AppCenter.isEnabled().get()

    public fun setCountryCode(countryCode: String?) {
        AppCenter.setCountryCode(countryCode)
    }
}
