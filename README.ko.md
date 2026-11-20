# Sample Rust Core · iOS SDK

[English](README.md)

Swift에서 `account.getMe()`를 호출하면 로그인한 사용자의 프로필을 받습니다. Rust Inside는 샘플 Rust 라이브러리로 iOS SDK를 빌드해 이 저장소에 Swift 패키지로 배포합니다. 패키지는 Swift tools 6.0을 사용하고, iOS 18 이상인 arm64 기기와 Apple Silicon 시뮬레이터를 지원합니다. [Rust 구현](https://github.com/Rust-Inside/sample-rust-core/blob/v0.2.0/src/api.rs)

## Xcode에 추가하기

Xcode에서 **File → Add Package Dependencies**를 열고 `https://github.com/Rust-Inside/sample-ios-sdk.git`를 입력하세요. 버전 `0.2.0`을 선택하고 앱 타깃에 `SampleRustCoreSDK` 제품을 추가하면 Xcode가 미리 빌드된 XCFramework를 내려받습니다. [v0.2.0 릴리스](https://github.com/Rust-Inside/sample-ios-sdk/releases/tag/v0.2.0)

### 비공개 XCFramework 받기

비공개 저장소에 자체 SDK를 배포했는데 Xcode가 XCFramework를 받지 못한다면, 그 저장소에 읽기 권한이 있는 계정으로 `gh auth login`을 실행하세요. 앱 저장소의 같은 셸에서 아래 명령을 차례로 실행하고, `repo`에는 자체 SDK 저장소를 지정합니다.

```sh
version=0.2.0
repo=Rust-Inside/sample-ios-sdk
package_dir="Vendor/SampleRustCoreSDK-$version"
archive="SampleRustCoreSDKFFI-$version.xcframework.zip"

mkdir -p Vendor
gh repo clone "$repo" "$package_dir" -- --depth 1 --branch "v$version"
gh release download "v$version" --repo "$repo" --pattern "$archive" --dir "$package_dir"
```

태그의 매니페스트에 적힌 체크섬과 내려받은 파일이 일치하면 압축을 풉니다. 이 명령은 로컬 복사본의 `Package.swift`가 내려받은 XCFramework를 사용하도록 수정합니다.

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

Xcode의 **Add Package Dependencies → Add Local**에서 `Vendor/SampleRustCoreSDK-0.2.0` 폴더를 선택하고 앱 타깃에 `SampleRustCoreSDK`를 추가하세요.

## 프로필 조회

계정 서버 주소와 사용자의 액세스 토큰을 넘기세요. Rust 라이브러리가 인증 헤더를 붙여 `GET /v1/me`를 요청하고 응답을 읽습니다.

```swift
import SampleRustCoreSDK

func profileName(apiOrigin: String, accessToken: String) async throws -> String {
    let account = AccountClient(baseUrl: apiOrigin, authorization: "Bearer \(accessToken)")
    let me = try await account.getMe()
    return me.displayName
}
```

`Me`에는 `id`, `handle`, `displayName`이 들어 있습니다. 요청이 실패하면 `getMe()`가 오류를 던집니다.

## 라이선스

[MIT](LICENSE)
