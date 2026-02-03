# TKTranslateSDK

A minimal iOS/macOS SDK scaffold.

## Build xcframework (static, includes Mac Catalyst)

```bash
./scripts/build_xcframework.sh
```

## CocoaPods

```ruby
pod "TKTranslateSDK"
```

## Swift Package Manager

```swift
.package(path: "./TKTranslateSDK")
```

Then import:

```swift
import TKTranslateSDK
```

## Release process

1) Merge changes into `main`.
2) Tag a release with `vX.Y.Z` and push the tag.
3) CI will:
   - Sync `TKTranslateSDK.podspec` version to `X.Y.Z`
   - Build and upload `TKTranslateSDK.xcframework.zip`
   - Generate GitHub Release notes
   - Publish the pod to CocoaPods Trunk

The CocoaPods binary URL is:

```
https://github.com/chachayiji/timekettle-ios-sdk/releases/download/vX.Y.Z/TKTranslateSDK.xcframework.zip
```
