// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "IQDropDownTextField",
    platforms: [
        .iOS(.v9),
    ],
    products: [
        .library(
            name: "IQDropDownTextField",
            targets: ["IQDropDownTextField"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "IQDropDownTextField",
            path: "IQDropDownTextField",
            publicHeadersPath: "."),
    ]
)
