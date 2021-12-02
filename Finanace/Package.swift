// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Finanace",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "AddPaymentMethod",
            targets: ["AddPaymentMethod"]
        ),
        .library(
            name: "AddPaymentMethodImp",
            targets: ["AddPaymentMethodImp"]
        ),
        .library(
            name: "FinanceEntity",
            targets: ["FinanceEntity"]
        ),
        .library(
            name: "FinanceRepository",
            targets: ["FinanceRepository"]
        ),
        .library(
            name: "Topup",
            targets: ["Topup"]
        ),
        .library(
            name: "TopupImp",
            targets: ["TopupImp"]
        ),
        .library(
            name: "FinanceHome",
            targets: ["FinanceHome"]
        ),
        .library(
            name: "FinanaceRepositoryTestSupport",
            targets: ["FinanaceRepositoryTestSupport"]
        ),
        .library(
            name: "TopupTestSupport",
            targets: ["TopupTestSupport"]
        ),
        .library(
            name: "AddPaymentMethodTestSupport",
            targets: ["AddPaymentMethodTestSupport"]
        )
    ],
    dependencies: [
        .package(name: "ModernRIBs", url: "https://github.com/DevYeom/ModernRIBs", .exact("1.0.1")),
        .package(path: "../Platform")
    ],
    targets: [
        .target(
            name: "AddPaymentMethod",
            dependencies: [
                "ModernRIBs",
                "FinanceEntity",
                .product(name: "RIBsUtil", package: "Platform")
            ]
        ),
        .target(
            name: "AddPaymentMethodImp",
            dependencies: [
                "AddPaymentMethod",
                "ModernRIBs",
                "FinanceEntity",
                "FinanceRepository",
                .product(name: "RIBsUtil", package: "Platform"),
                .product(name: "SuperUI", package: "Platform"),
            ]
        ),
        .target(
            name: "FinanceEntity",
            dependencies: [
                
            ]
        ),
        .target(
            name: "FinanceRepository",
            dependencies: [
                "FinanceEntity",
                .product(name: "CombineUtil", package: "Platform"),
                .product(name: "Network", package: "Platform")
            ]
        ),
        .target(
            name: "Topup",
            dependencies: [
                "ModernRIBs"
            ]
        ),
        .target(
            name: "TopupImp",
            dependencies: [
                "ModernRIBs",
                "Topup",
                "FinanceEntity",
                "FinanceRepository",
                "AddPaymentMethod",
                .product(name: "RIBsUtil", package: "Platform"),
                .product(name: "SuperUI", package: "Platform"),
                .product(name: "DefaultsStore", package: "Platform")
            ]
        ),
        .target(
            name: "FinanceHome",
            dependencies: [
                "ModernRIBs",
                "FinanceEntity",
                "FinanceRepository",
                "AddPaymentMethod",
                "Topup",
                .product(name: "RIBsUtil", package: "Platform"),
                .product(name: "SuperUI", package: "Platform"),
            ]
        ),
        .target(
            name: "FinanaceRepositoryTestSupport",
            dependencies: [
                "FinanceEntity",
                "FinanceRepository",
                .product(name: "CombineUtil", package: "Platform")
            ]
        ),
        .target(
            name: "TopupTestSupport",
            dependencies: [
                "Topup"
            ]
        ),
        .target(
            name: "AddPaymentMethodTestSupport",
            dependencies: [
                "AddPaymentMethod"
            ]
        ),
        .testTarget(
            name: "TopupImpTests",
            dependencies: [
                "TopupImp",
                "FinanaceRepositoryTestSupport",
                "TopupTestSupport",
                "AddPaymentMethodTestSupport",
                .product(name: "RIBsTestSupport", package: "Platform")
        ])
    ]
)
