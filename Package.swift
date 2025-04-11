// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Tracer",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "Tracer",
            targets: ["Tracer"]
        ),
    ],
    targets: [
        .target(name: "Tracer")
    ]
)
