# Sample Rust Core · iOS SDK

[English](README.md) | [한국어](README.ko.md)

Call `account.getMe()` from Swift to fetch the signed-in user's profile. Rust Inside builds the iOS SDK from the sample Rust library and publishes it here as a Swift package. The package uses Swift tools 6.0 and supports iOS 18 or later on arm64 devices and Apple Silicon simulators. [Rust implementation](https://github.com/Rust-Inside/sample-rust-core/blob/main/src/api.rs)

## Add the package in Xcode

Open **File → Add Package Dependencies** in Xcode and enter `https://github.com/Rust-Inside/sample-ios-sdk.git`. Select version `0.1.0` and add the `SampleRustCoreSDK` product to your app target. Xcode downloads the prebuilt XCFramework. [Release v0.1.0](https://github.com/Rust-Inside/sample-ios-sdk/releases/tag/v0.1.0)

### Download the private XCFramework

If you publish your own SDK to a private repository and Xcode cannot download the XCFramework, sign in with `gh auth login` using an account with read access. From your app repository, run both command blocks in the same shell. Set `repo` to your SDK repository.

```sh
version=0.1.0
repo=Rust-Inside/sample-ios-sdk
package_dir="Vendor/SampleRustCoreSDK-$version"
archive="SampleRustCoreSDKFFI-$version.xcframework.zip"

mkdir -p Vendor
gh repo clone "$repo" "$package_dir" -- --depth 1 --branch "v$version"
gh release download "v$version" --repo "$repo" --pattern "$archive" --dir "$package_dir"
```

Check the downloaded archive against the checksum in the tagged manifest, then unpack it. This updates the local copy of `Package.swift` to use the downloaded XCFramework.

```sh
(
  set -eu
  cd "$package_dir"
  checksum=$(swift package compute-checksum "$archive")
  grep -Fq "checksum: \"$checksum\"" Package.swift
  ditto -x -k "$archive" .
  sed -i '' -E 's|url: "[^"]+", checksum: "[0-9a-f]{64}"|path: "SampleRustCoreSDKFFI.xcframework"|' Package.swift
  swift package describe >/dev/null
)
```

In Xcode, choose **Add Package Dependencies → Add Local**, select `Vendor/SampleRustCoreSDK-0.1.0`, and add `SampleRustCoreSDK` to your app target.

## Fetch a profile

Pass your account server's origin and the user's access token. The Rust library sends the bearer token with `GET /v1/me` and decodes the response.

```swift
import SampleRustCoreSDK

func profileName(apiOrigin: String, accessToken: String) async throws -> String {
    let account = AccountClient(baseUrl: apiOrigin, authorization: "Bearer \(accessToken)")
    let me = try await account.getMe()
    return me.displayName
}
```

`Me` contains `id`, `handle`, and `displayName`. If the request fails, `getMe()` throws.

## License

[MIT](LICENSE)
