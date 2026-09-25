import XCTest
import Capacitor
@testable import AnalyticsPlugin

class AnalyticsTests: XCTestCase {
    func testBridgedPlugin() {
        let plugin = AnalyticsPlugin()

        XCTAssertEqual("AnalyticsPlugin", plugin.identifier)
        XCTAssertEqual("Analytics", plugin.jsName)
        XCTAssertEqual(
            ["setEnabled", "isEnabled", "pause", "resume", "trackEvent", "enableManualSessionTracker", "startSession"],
            plugin.pluginMethods.map { $0.name })
        XCTAssertEqual(
            [.none, .promise, .none, .none, .none, .none, .none],
            plugin.pluginMethods.map { $0.returnType })
    }

    func testTrackEventWithoutANameThrows() {
        for options: JSObject in [[:], ["name": 1], ["name": ""]] {
            XCTAssertThrowsError(try AnalyticsPlugin().trackEvent(unansweredCall("trackEvent", options))) { error in
                XCTAssertEqual((error as? CAPPluginError)?.message, "Must provide an event name")
                XCTAssertNil((error as? CAPPluginError)?.code)
            }
        }
    }

    private func unansweredCall(_ method: String, _ options: JSObject) -> CAPPluginCall {
        return CAPPluginCall(callbackId: "test", methodName: method, options: options, success: { _, _ in
            XCTFail("\(method) answers by throwing")
        }, error: { _ in
            XCTFail("\(method) answers by throwing")
        })
    }
}
