// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ISBN",
    products: [
        .library(
            name: "ISBN",
            targets: ["ISBN"]),
    ],
    targets: [
        .target(
            name: "ISBN",
            dependencies: [],
            resources: [.process("Resources")]),
        .testTarget(
            name: "ISBNTests",
            dependencies: ["ISBN"]),
    ]
)
