import ProjectDescription
let appName = "The North"
let prefixBundleID = "com.nafachri"

let project = Project(
  name: appName,
  targets: [
    .mainApp(appName,
             dependencies: [
              .target(name: "TNUI"),
              .target(name: "Coordinator"),
              .target(name: "Dependency"),
              .target(name: "AuthenticationFeature"),
              .target(name: "ProfileFeature"),
              .target(name: "SettingFeature"),
              .target(name: "PaymentFeature"),
              .target(name: "ContactsFeature"),
              .target(name: "OnBoardingFeature"),
              .target(name: "HomeFeature"),
              .target(name: "HistoryFeature"),
              .target(name: "TabBarFeature"),
              .external(name: "netfox"),
              .external(name: "Lottie"),
              .external(name: "KeychainSwift"),
              .external(name: "MidtransKit"),
              .target(name: "TheNorthCoreDataModel"),
              .target(name: "TheNorthCoreDataManager")
]),
    
    //MARK: Foundations
    .framework("TNUI",
               sources: ["Foundations/TNUI/Sources/**/*.swift"],
               resources: [
                "Foundations/TNUI/Sources/**/*.xib",
                "Foundations/TNUI/Resources/**/*.xcassets",
                ],
               dependencies: [
                .target(name: "Utils"),
                .external(name: "RxSwift")
               ]),
    .framework("Dependency",
               sources: ["Foundations/Dependency/**/*.swift"],
               resources: [],
               dependencies: [
                .target(name: "Networking")
               ]),
    .framework("Networking",
               sources: ["Foundations/Networking/**/*.swift"],
               resources: [],
               dependencies: [
                .external(name: "Alamofire"),
                .external(name: "RxSwift"),
               ]),
    .framework("Coordinator",
               sources: ["Foundations/Coordinator/**/*.swift"],
               resources: [],
               dependencies: []
              ),
    .framework("Utils",
               sources: ["Foundations/Utils/**/*.swift"],
               resources: [],
               dependencies: [
                .external(name: "RxSwift"),
               ]
              ),
    .framework("TheNorthCoreDataModel",
               sources: [],
               resources: ["Foundations/TheNorthCoreDataModel/Resources/**/*.json",
                           "Foundations/TheNorthCoreDataModel/Resources/**/*.xcdatamodeld"],
               dependencies: []
              ),
    .framework("TheNorthCoreDataManager",
               sources: ["Foundations/TheNorthCoreDataManager/**/*.swift"],
               resources: [],
               dependencies: []
              ),
    //MARK: Features
    .framework("Services",
               sources: ["Features/Services/**/*.swift"],
               resources: [],
               dependencies: [
                .target(name: "Dependency"),
                .target(name: "Networking"),
                .external(name: "RxSwift"),
               ]),
    .framework("AuthenticationFeature",
               sources: ["Features/AuthenticationFeature/Sources/**/*.swift"],
               resources: ["Features/AuthenticationFeature/Sources/**/*.xib",         
                           "Features/AuthenticationFeature/Resources/**/*.xcassets"
                          ],
               dependencies: [
                .target(name: "TNUI"),
                .target(name: "Dependency"),
                .target(name: "Services"),
                .external(name: "RxRelay"),
                .external(name: "RxCocoa"),
                .external(name: "RxSwift"),
                .target(name: "Coordinator"),
               ]),
    .framework("ProfileFeature",
               sources: ["Features/ProfileFeature/Sources/**/*.swift"],
               resources: ["Features/ProfileFeature/Sources/**/*.xib",
                           "Features/ProfileFeature/Resources/**/*.xcassets"
                          ],
               dependencies: [
                .target(name: "TNUI"),
                .target(name: "Dependency"),
                .target(name: "Coordinator"),
                .external(name: "RxSwift"),
                .external(name: "RxRelay"),
                .external(name: "RxCocoa"),
                .external(name: "RxSwift"),

               ]),
    .framework("SettingFeature",
               sources: ["Features/SettingFeature/Sources/**/*.swift"],
               resources: ["Features/SettingFeature/Sources/**/*.xib",
                           "Features/SettingFeature/Resources/**/*.xcassets"
                          ],
               dependencies: [
                .target(name: "TNUI"),
                .target(name: "Dependency"),
                .target(name: "Coordinator"),

               ]),
    .framework("PaymentFeature",
               sources: ["Features/PaymentFeature/Sources/**/*.swift"],
               resources: ["Features/PaymentFeature/Sources/**/*.xib",
                           "Features/PaymentFeature/Resources/**/*.xcassets"
                          ],
               dependencies: [
                .target(name: "TNUI"),
                .target(name: "Dependency"),
                .target(name: "Coordinator"),
                .external(name: "RxSwift"),
                .external(name: "RxRelay"),
                .external(name: "RxCocoa"),
                .external(name: "RxSwift"),
                .target(name: "Utils")
               ]),
    .framework("ContactsFeature",
               sources: ["Features/ContactsFeature/Sources/**/*.swift"],
               resources: ["Features/ContactsFeature/Sources/**/*.xib",
                           "Features/ContactsFeature/Resources/**/*.xcassets"
                          ],
               dependencies: [
                .target(name: "TNUI"),
                .target(name: "Dependency"),
                .target(name: "Coordinator"),
                .target(name: "TheNorthCoreDataModel"),
                .target(name: "TheNorthCoreDataManager")
               ]),
    .framework("OnBoardingFeature",
               sources: ["Features/OnBoardingFeature/Sources/**/*.swift"],
               resources: ["Features/OnBoardingFeature/Sources/**/*.xib",
                           "Features/OnBoardingFeature/Resources/**/*.xcassets"
                          ],
               dependencies: [
                .target(name: "TNUI"),
                .target(name: "Dependency"),
                .target(name: "Coordinator"),
               ]),
    .framework("HomeFeature",
               sources: ["Features/HomeFeature/Sources/**/*.swift"],
               resources: ["Features/HomeFeature/Sources/**/*.xib",
                           "Features/HomeFeature/Resources/**/*.xcassets"
                          ],
               dependencies: [
                .target(name: "TNUI"),
                .target(name: "Dependency"),
                .target(name: "Coordinator"),
                .target(name: "Services"),
                .external(name: "SnapKit"),
               ]),
    .framework("HistoryFeature",
               sources: ["Features/HistoryFeature/Sources/**/*.swift"],
               resources: ["Features/HistoryFeature/Sources/**/*.xib",
                           "Features/HistoryFeature/Resources/**/*.xcassets"
                          ],
               dependencies: [
                .target(name: "TNUI"),
                .target(name: "Dependency"),
                .target(name: "Coordinator"),
                .target(name: "Services"),
               ]),
    .framework("TabBarFeature",
               sources: ["Features/TabBarFeature/Sources/**/*.swift"],
               resources: ["Features/TabBarFeature/Sources/**/*.xib",
                           "Features/TabBarFeature/Resources/**/*.xcassets"
                          ],
               dependencies: [
                .target(name: "TNUI"),
                .target(name: "Dependency"),
                .target(name: "Coordinator"),
                .target(name: "Services"),
               ]),
    
    //     diaktifkan kalau perlu test
    //    .target(
    //      name: "\(appName)Tests",
    //      destinations: .iOS,
    //      product: .unitTests,
    //      bundleId: "\(prefixBundleID).\(appName.dashSeparator)Tests",
    //      infoPlist: .default,
    //      sources: ["\(appName)/Tests/**"],
    //      resources: [],
    //      dependencies: [.target(name: appName)]
    //    ),
    
    
  ]
)



public extension ProjectDescription.Target {
  
  static func mainApp(_ name: String, dependencies: [TargetDependency]) -> ProjectDescription.Target {
    .target(
      name: "\(name)",
      destinations: .iOS,
      product: .app,
      bundleId: "\(prefixBundleID).\(name.dashSeparator)",
      infoPlist: .file(path: .relativeToManifest("App/Info.plist")),
      sources: ["App/Sources/**"],
      resources: ["App/Resources/**", "App/Resources/**/*.xcassets", 
//                  "App/Resources/Data/**/*/.xcdatamodeld", "App/Resources/Data/**/*/.json"
                 ],
      dependencies: dependencies
    )
  }
  
  static func framework(_ targetName: String, sources: SourceFilesList?, resources: ResourceFileElements?, dependencies: [TargetDependency]) -> ProjectDescription.Target {
    .target(
      name: targetName,
      destinations: .iOS,
      product: .framework,
      bundleId: "\(prefixBundleID).\(targetName.dashSeparator)",
      sources: sources,
      resources: resources,
      dependencies: dependencies
    )
  }
  
  static func example(_ targetName: String, sources: SourceFilesList?, resources: ResourceFileElements?, dependencies: [TargetDependency]) -> ProjectDescription.Target {
    .target(
      name: targetName,
      destinations: .iOS,
      product: .app,
      bundleId: "\(prefixBundleID).\(targetName.dashSeparator)",
      sources: sources,
      resources: resources,
      dependencies: dependencies
    )
  }
  
}

extension String {
  var dashSeparator: String {
    self.replacingOccurrences(of: " ", with: "-")
  }
}
