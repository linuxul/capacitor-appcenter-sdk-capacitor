import Foundation
import Capacitor
import AppCenterCapacitorShared

@objc(AnalyticsPlugin)
public class AnalyticsPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "AnalyticsPlugin"
    public let jsName = "Analytics"
    public let pluginMethods: [CAPPluginMethod] = [
        .none("setEnabled", AnalyticsPlugin.setEnabled),
        .promise("isEnabled", AnalyticsPlugin.isEnabled),
        .none("pause", AnalyticsPlugin.pause),
        .none("resume", AnalyticsPlugin.resume),
        .none("trackEvent", AnalyticsPlugin.trackEvent),
        .none("enableManualSessionTracker", AnalyticsPlugin.enableManualSessionTracker),
        .none("startSession", AnalyticsPlugin.startSession)
    ]

    private let implementation = AppCenterAnalyticsBase()

    override public func load() {

        AppCenterCapacitorShared.configureWithSettings()

        let config: NSDictionary = AppCenterCapacitorShared.getConfiguration()

        // get Analytics config options
        let enableInJs = config["AnalyticsEnableInJs"] as? Bool
        let transmissionInterval = config["AnalyticsTransmissionInterval"] as? UInt

        if AppCenterCapacitorShared.isSdkConfigured() {

            if transmissionInterval != nil {
                implementation.setTransmissionInterval(transmissionInterval!)
            }

            implementation.start()

            // disable auto start of Analytics
            if enableInJs ?? false {
                implementation.enable(false)
            }
        }
    }

    func setEnabled(_ call: CAPPluginCall) {
        implementation.enable(call.getBool("enable") ?? false)
        call.resolve()
    }

    func isEnabled(_ call: CAPPluginCall) {
        call.resolve(["value": implementation.isEnabled()])
    }

    func pause(_ call: CAPPluginCall) {
        implementation.pause()
        call.resolve()
    }

    func resume(_ call: CAPPluginCall) {
        implementation.resume()
        call.resolve()
    }

    func trackEvent(_ call: CAPPluginCall) throws {
        guard let name = call.options["name"] as? String, !name.isEmpty else {
            throw CAPPluginError("Must provide an event name")
        }

        let properties = call.options["properties"] as? [String: String] ?? [:]
        let flag: String = call.getString("flag") ?? "none"

        implementation.trackEvent(name, properties, flag)

        call.resolve()
    }

    func enableManualSessionTracker(_ call: CAPPluginCall) {
        implementation.enableManualSessionTracker()
        call.resolve()
    }

    func startSession(_ call: CAPPluginCall) {
        implementation.startSession()
        call.resolve()
    }
}
