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
        
        // Uncomment when Swift version is available.
//        .library(
//            name: "IQDropDownTextFieldSwift",
//            targets: ["IQDropDownTextFieldSwift"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "IQDropDownTextField",
            path: "IQDropDownTextField",
            publicHeadersPath: "."),
        
        // Uncomment when Swift version is available.
//        .target(
//            name: "IQDropDownTextFieldSwift",
//            path: "IQDropDownTextFieldSwift"),
    ]
)
