// swift-tools-version: 5.9
import Foundation
import PackageDescription

// Apps override this dependency with the @capacitor/ios they installed. To build this package on its own
// against a local runtime, point CAPACITOR_IOS_PATH at it.
let capacitor: Package.Dependency
if let path = ProcessInfo.processInfo.environment["CAPACITOR_IOS_PATH"] {
    capacitor = .package(name: "capacitor-swift-pm", path: path)
} else {
    capacitor = .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "8.0.0")
}

// AppCenterCapacitorShared is the package at the root of this repository. It has no release tags, and only this
// branch of the fork declares the iOS platform it needs. Inside the repository, point APPCENTER_SHARED_PATH
// at the root to build against the working copy.
let shared: Package.Dependency
if let path = ProcessInfo.processInfo.environment["APPCENTER_SHARED_PATH"] {
    shared = .package(name: "capacitor-appcenter-sdk-capacitor", path: path)
} else {
    shared = .package(url: "https://github.com/linuxul/capacitor-appcenter-sdk-capacitor.git", branch: "refactor/kotlin-swift")
}

let package = Package(
    name: "CapacitorCommunityAppcenterCrashes",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "CapacitorCommunityAppcenterCrashes",
            targets: ["CrashesPlugin"])
    ],
    dependencies: [
        capacitor,
        shared,
        .package(url: "https://github.com/microsoft/appcenter-sdk-apple.git", .upToNextMajor(from: "5.0.5"))
    ],
    targets: [
        .target(
            name: "CrashesPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "AppCenterCapacitorShared", package: "capacitor-appcenter-sdk-capacitor"),
                .product(name: "AppCenterCrashes", package: "appcenter-sdk-apple")
            ],
            path: "ios/Sources/CrashesPlugin"),
        .testTarget(
            name: "CrashesPluginTests",
            dependencies: ["CrashesPlugin"],
            path: "ios/Tests/CrashesPluginTests")
    ]
)
