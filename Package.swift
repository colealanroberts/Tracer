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
        )
    ],
    dependencies: [
        .package(url: "https://github.com/stephencelis/SQLite.swift.git", from: "0.15.3"),
    ],
    targets: [
        .target(
            name: "Tracer",
            dependencies: [
                .product(name: "SQLite", package: "SQLite.swift")
            ]
        )
    ]
)
