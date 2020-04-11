// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "RegisterMachine",
  dependencies: [],
  targets: [
    .target(name: "RegisterMachine", dependencies: []),
    .testTarget(name: "RegisterMachineTests", dependencies: ["RegisterMachine"])
  ]
)
