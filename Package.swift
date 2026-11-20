// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SampleRustCoreSDK",
    platforms: [.iOS(.v18), .macOS(.v14)],
    products: [.library(name: "SampleRustCoreSDK", targets: ["SampleRustCoreSDK"])],
    targets: [
        .binaryTarget(name: "SampleRustCoreSDKFFI", url: "https://github.com/Rust-Inside/sample-ios-sdk/releases/download/v0.1.0/SampleRustCoreSDKFFI-0.1.0.xcframework.zip", checksum: "1ef7ee3233257ca19b2c5c726502a8e2a9d4f97a195a882608d591f8629a81d8"),
        .target(name: "SampleRustCoreSDK", dependencies: ["SampleRustCoreSDKFFI"])
    ]
)
