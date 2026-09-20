import XCTest
@testable import AppCenterCapacitorShared
import AppCenter

class AppCenterCapacitorSharedTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Reset shared state before each test
        AppCenterCapacitorShared.startAutomatically = true
        AppCenterCapacitorShared.configuration = [:]
        AppCenterCapacitorShared.appSecret = nil
        AppCenterCapacitorShared.logLevel = nil
        AppCenterCapacitorShared.wrapperSdk = nil
    }

    func testIsSdkConfigured() {
        // AppCenter stays configured for the whole process, so the initial state is checked in
        // testConfigureWithSettings, which is the only test that configures it
        XCTAssertEqual(AppCenter.isConfigured, AppCenterCapacitorShared.isSdkConfigured())
    }

    func testSetStartAutomatically() {
        AppCenterCapacitorShared.setStartAutomatically(false)
        XCTAssertFalse(AppCenterCapacitorShared.startAutomatically)
    }

    func testSetAppSecret() {
        let secret = "test-secret"
        AppCenterCapacitorShared.setAppSecret(secret)
        XCTAssertEqual(AppCenterCapacitorShared.appSecret, secret)
    }

    func testConfigureWithSettings() {
        // Initially, the SDK should not be configured
        XCTAssertFalse(AppCenterCapacitorShared.isSdkConfigured())

        // Test without app secret
        AppCenterCapacitorShared.configureWithSettings()
        XCTAssertTrue(AppCenter.isConfigured)

        // Test with app secret
        let secret = "test-secret"
        AppCenterCapacitorShared.setAppSecret(secret)
        AppCenterCapacitorShared.configureWithSettings()
        XCTAssertTrue(AppCenter.isConfigured)
    }

    func testGetConfiguration() {
        let config = AppCenterCapacitorShared.getConfiguration()
        XCTAssertEqual(config, [:])
    }

    func testGetWrapperSdk() {
        XCTAssertNil(AppCenterCapacitorShared.getWrapperSdk())
    }

    func testSetWrapperSdk() throws {
        let wrapperSdk = try XCTUnwrap(WrapperSdk(wrapperSdkVersion: "5.0.0",
                                    wrapperSdkName: "appcenter.capacitor",
                                    wrapperRuntimeVersion: nil,
                                    liveUpdateReleaseLabel: nil,
                                    liveUpdateDeploymentKey: nil,
                                    liveUpdatePackageHash: nil))
        AppCenterCapacitorShared.setWrapperSdk(wrapperSdk)
        XCTAssertEqual(AppCenterCapacitorShared.getWrapperSdk(), wrapperSdk)
    }
}
