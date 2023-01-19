import PackageDescription

let package = Package(
    name: "IQDropDownTextFieldSwift",
    products: [
       .library(name: "IQDropDownTextFieldSwift", targets: ["IQDropDownTextFieldSwift"])
   ],
   targets: [
       .target(
           name: "IQDropDownTextFieldSwift",
           path: "IQDropDownTextFieldSwift"
       )
   ]
)
