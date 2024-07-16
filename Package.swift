// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IQDropDownTextFieldSwift",
    platforms: [
        .iOS(.v11)
    ],
    products: [
       .library(
        name: "IQDropDownTextFieldSwift",
        targets: ["IQDropDownTextFieldSwift"]
       )
   ],
   targets: [
       .target(
           name: "IQDropDownTextFieldSwift",
           path: "IQDropDownTextFieldSwift",
           resources: [
               .copy("PrivacyInfo.xcprivacy")
           ]
       )
   ]
)
