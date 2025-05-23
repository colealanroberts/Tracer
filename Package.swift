// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Tracer",
    platforms: [
        .iOS(.v16)
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
