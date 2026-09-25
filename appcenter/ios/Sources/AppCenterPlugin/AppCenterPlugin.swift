import Foundation
import Capacitor
import AppCenterCapacitorShared

@objc(AppCenterPlugin)
public class AppCenterPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "AppCenterPlugin"
    public let jsName = "AppCenter"
    public let pluginMethods: [CAPPluginMethod] = [
        .promise("getInstallId", AppCenterPlugin.getInstallId),
        .none("setUserId", AppCenterPlugin.setUserId),
        .promise("getSdkVersion", AppCenterPlugin.getSdkVersion),
        .promise("isEnabled", AppCenterPlugin.isEnabled),
        .none("setEnabled", AppCenterPlugin.setEnabled),
        .none("setCustomProperties", AppCenterPlugin.setCustomProperties),
        .promise("getLogLevel", AppCenterPlugin.getLogLevel),
        .none("setLogLevel", AppCenterPlugin.setLogLevel),
        .none("setNetworkRequestsAllowed", AppCenterPlugin.setNetworkRequestsAllowed),
        .promise("isNetworkRequestsAllowed", AppCenterPlugin.isNetworkRequestsAllowed),
        .none("setCountryCode", AppCenterPlugin.setCountryCode)
    ]

    private let implementation = AppCenterBase()

    override public func load() {
        AppCenterCapacitorShared.configureWithSettings()
    }

    func getInstallId(_ call: CAPPluginCall) {
        call.resolve(["value": implementation.getInstallId()])
    }

    func setUserId(_ call: CAPPluginCall) {
        implementation.setUserId(call.getString("userId") ?? "")
        call.resolve()
    }

    func getSdkVersion(_ call: CAPPluginCall) {
        call.resolve(["value": implementation.getSdkVersion()])
    }

    func isEnabled(_ call: CAPPluginCall) {
        call.resolve(["value": implementation.isEnabled()])
    }

    func setEnabled(_ call: CAPPluginCall) {
        implementation.enable(call.getBool("enabled") ?? false)
        call.resolve()
    }

    func getLogLevel(_ call: CAPPluginCall) {
        call.resolve(["value": implementation.getLogLevel()])
    }

    func setLogLevel(_ call: CAPPluginCall) throws {
        guard let level = call.options["logLevel"] as? Int else {
            throw CAPPluginError("Must provide LogLevel")
        }

        implementation.setLogLevel(level)
        call.resolve()
    }

    func setCustomProperties(_ call: CAPPluginCall) {
        call.unavailable("Not available in appcenter@2.0.0 or later.")
        //        guard let properties = call.options["properties"] as? [String: [String: Any]] else {
        //            implementation.setCustomProperties([:])
        //            call.resolve()
        //            return
        //        }
        //
        //        implementation.setCustomProperties(properties)
        //
        //        call.resolve()
    }

    func setNetworkRequestsAllowed(_ call: CAPPluginCall) {
        implementation.setNetworkRequestsAllowed(call.getBool("isAllowed", true))
        call.resolve()
    }

    func isNetworkRequestsAllowed(_ call: CAPPluginCall) {
        call.resolve(["value": implementation.isNetWorkRequestsAllowed()])
    }

    func setCountryCode(_ call: CAPPluginCall) {
        implementation.setCountryCode(call.getString("countryCode") ?? "")
        call.resolve()
    }
}
