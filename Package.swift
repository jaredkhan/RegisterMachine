// swift-tools-version:3.1

import PackageDescription

let package = Package(
  name: "RegisterMachine",
  targets: [
    Target(name: "RegisterMachine", dependencies: []),
    Target(name: "RegisterMachineRuns", dependencies: ["RegisterMachine"])
  ],
  dependencies: []
)
