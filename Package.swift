// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SampleRustCoreSDK",
    platforms: [.iOS(.v18), .macOS(.v14)],
    products: [.library(name: "SampleRustCoreSDK", targets: ["SampleRustCoreSDK"])],
    targets: [
        .binaryTarget(name: "SampleRustCoreSDKFFI", url: "https://github.com/Rust-Inside/sample-ios-sdk/releases/download/v0.2.0/SampleRustCoreSDKFFI-0.2.0.xcframework.zip", checksum: "72462b23cec404ef65cef45a1f9232237cb6915723ca7cdc87d462bf2c768a98"),
        .target(name: "SampleRustCoreSDK", dependencies: ["SampleRustCoreSDKFFI"])
    ]
)
