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
                "getInstallId", "setUserId", "getSdkVersion", "isEnabled", "setEnabled", "setCustomProperties",
                "getLogLevel", "setLogLevel", "setNetworkRequestsAllowed", "isNetworkRequestsAllowed", "setCountryCode"
            ],
            plugin.pluginMethods.map { $0.name })
        XCTAssertEqual(
            [
                .promise, .none, .promise, .promise, .none, .none,
                .promise, .none, .none, .promise, .none
            ],
            plugin.pluginMethods.map { $0.returnType })
    }

    func testSetLogLevelWithoutALevelThrows() {
        XCTAssertThrowsError(try AppCenterPlugin().setLogLevel(unansweredCall("setLogLevel", ["logLevel": "debug"]))) { error in
            XCTAssertEqual((error as? CAPPluginError)?.message, "Must provide LogLevel")
            XCTAssertNil((error as? CAPPluginError)?.code)
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
