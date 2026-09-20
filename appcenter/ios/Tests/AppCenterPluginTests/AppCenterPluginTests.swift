import XCTest
import Capacitor
@testable import AppCenterPlugin

class AppCenterTests: XCTestCase {
    func testBridgedPlugin() {
        let plugin = AppCenterPlugin()

        XCTAssertEqual("AppCenterPlugin", plugin.identifier)
        XCTAssertEqual("AppCenter", plugin.jsName)
        XCTAssertEqual(
            [
                "getInstallId", "setUserId", "getSdkVersion", "isEnabled", "setEnable", "setCustomProperties",
                "getLogLevel", "setLogLevel", "setNetworkRequestsAllowed", "isNetworkRequestsAllowed", "setCountryCode"
            ],
            plugin.pluginMethods.map { $0.name })
    }
}
