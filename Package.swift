// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Frame",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "Frame",
            targets: ["Frame"]
        ),
    ],
    targets: [
        .target(name: "Frame")
    ]
)
