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
        XCTAssertEqual(
            [.promise, .none, .promise, .none, .promise, .promise, .promise],
            plugin.pluginMethods.map { $0.returnType })
    }

    @MainActor
    func testTrackErrorRejectsAnInvalidError() async {
        let cases: [(JSObject, String)] = [
            ([:], "Tracking error failed: Exception model cannot be nil"),
            (["error": ["type": "Error", "message": "boom"] as JSObject], "Tracking error failed: wrapperSdkName value shouldn't be nil or empty")
        ]
        for (options, message) in cases {
            do {
                _ = try await CrashesPlugin().trackError(unansweredCall("trackError", options))
                XCTFail("trackError should throw for \(options)")
            } catch let error as CAPPluginError {
                XCTAssertEqual(error.message, message)
                XCTAssertNil(error.code)
            } catch {
                XCTFail("unexpected error \(error)")
            }
        }
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

    private func unansweredCall(_ method: String, _ options: JSObject) -> CAPPluginCall {
        return CAPPluginCall(callbackId: "test", methodName: method, options: options, success: { _, _ in
            XCTFail("\(method) answers by returning or throwing")
        }, error: { _ in
            XCTFail("\(method) answers by returning or throwing")
        })
    }
}
