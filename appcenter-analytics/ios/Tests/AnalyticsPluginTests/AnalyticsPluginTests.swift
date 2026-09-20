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
    }
}
