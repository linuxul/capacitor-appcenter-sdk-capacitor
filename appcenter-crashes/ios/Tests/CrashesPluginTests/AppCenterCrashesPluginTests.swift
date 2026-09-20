import XCTest
import Capacitor
@testable import CrashesPlugin

class AppCenterCrashesTests: XCTestCase {
    func testBridgedPlugin() {
        let plugin = CrashesPlugin()

        XCTAssertEqual("CrashesPlugin", plugin.identifier)
        XCTAssertEqual("Crashes", plugin.jsName)
        XCTAssertEqual(
            [
                "trackError", "setEnabled", "isEnabled", "generateTestCrash", "hasReceivedMemoryWarningInLastSession",
                "hasCrashedInLastSession", "lastSessionCrashReport"
            ],
            plugin.pluginMethods.map { $0.name })
    }

    func testExceptionModel() throws {
        XCTAssertThrowsError(try CrashesUtil.toExceptionModel(nil))
        XCTAssertThrowsError(try CrashesUtil.toExceptionModel(["type": "Error", "message": ""]))

        let model = try CrashesUtil.toExceptionModel([
            "type": "Error", "message": "Something failed", "wrapperSdkName": "appcenter.capacitor", "stackTrace": "at main"
        ])
        XCTAssertEqual("Error", model.type)
        XCTAssertEqual("Something failed", model.message)
        XCTAssertEqual("appcenter.capacitor", model.wrapperSdkName)
        XCTAssertEqual("at main", model.stackTrace)
    }
}
