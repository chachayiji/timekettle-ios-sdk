// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "TKTranslateSDK",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "TKTranslateSDK",
            targets: ["TKTranslateSDK"]
        )
    ],
    targets: [
        .target(
            name: "TKTranslateSDK",
            path: "Sources/TKTranslateSDK"
        ),
        .testTarget(
            name: "TKTranslateSDKTests",
            dependencies: ["TKTranslateSDK"],
            path: "Tests/TKTranslateSDKTests"
        )
    ]
)
