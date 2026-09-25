import Foundation
import Capacitor
import AppCenterCapacitorShared

@objc(CrashesPlugin)
public class CrashesPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "CrashesPlugin"
    public let jsName = "Crashes"
    public let pluginMethods: [CAPPluginMethod] = [
        .async("trackError", CrashesPlugin.trackError),
        .none("setEnabled", CrashesPlugin.setEnabled),
        .promise("isEnabled", CrashesPlugin.isEnabled),
        .none("generateTestCrash", CrashesPlugin.generateTestCrash),
        .async("hasReceivedMemoryWarningInLastSession", CrashesPlugin.hasReceivedMemoryWarningInLastSession),
        .async("hasCrashedInLastSession", CrashesPlugin.hasCrashedInLastSession),
        .async("lastSessionCrashReport", CrashesPlugin.lastSessionCrashReport)
    ]

    private let implementation = AppCenterCrashesBase()

    override public func load() {

        print("[CrashesPlugin] load")

        AppCenterCapacitorShared.configureWithSettings()

        let config: NSDictionary = AppCenterCapacitorShared.getConfiguration()

        // get Crashes config options
        let alwaysSendCrashes = config["CrashesAlwaysSend"] as? Bool

        if AppCenterCapacitorShared.isSdkConfigured() {
            print("[CrashesPlugin] starting")
            implementation.start()
        }
    }

    // trackError and the three last-session queries ran their App Center calls in DispatchQueue.main.async. They
    // are @MainActor async methods now and run on the main actor. They answer by returning or throwing; async
    // methods do not wait for each other, which none of them needs.

    @MainActor
    func trackError(_ call: CAPPluginCall) async throws -> JSObject {
        let errorToTrack = call.getObject("error")
        let properties = call.getObject("properties")
        let attachments = call.getArray("attachments", JSObject.self)

        do {
            // We call trackException here and not trackError because the error is a custom exception
            // parsed from JS instead of a Throwable error
            let errorReportId = try implementation.trackException(errorToTrack, properties, attachments)
            return ["value": errorReportId]
        } catch CrashesUtil.ExceptionModelError.validationError(let message) {
            throw CAPPluginError("Tracking error failed: \(message)")
        } catch {
            throw CAPPluginError("Tracking error failed: \(error)")
        }
    }

    func setEnabled(_ call: CAPPluginCall) {
        implementation.enable(call.getBool("enable") ?? false)
        call.resolve()
    }

    func isEnabled(_ call: CAPPluginCall) {
        call.resolve(["value": implementation.isEnabled()])
    }

    func generateTestCrash(_ call: CAPPluginCall) {
        implementation.generateTestCrash()
        call.resolve()
    }

    @MainActor
    func hasReceivedMemoryWarningInLastSession(_ call: CAPPluginCall) async -> JSObject {
        return ["value": implementation.hasReceivedMemoryWarningInLastSession()]
    }

    @MainActor
    func hasCrashedInLastSession(_ call: CAPPluginCall) async -> JSObject {
        return ["value": implementation.hasCrashedInLastSession()]
    }

    @MainActor
    func lastSessionCrashReport(_ call: CAPPluginCall) async throws {
        guard let report = implementation.lastSessionCrashReport() else {
            throw CAPPluginError("No crash report available")
        }

        // The report is a dictionary of JSON values rather than a JSObject, so the method resolves the call itself.
        call.resolve(["value": report])
    }

}
