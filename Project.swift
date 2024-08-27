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
              .target(name: "TheNorthCoreDataManager"),
              .target(name: "NetworkManager"),
              .external(name: "Kingfisher"),
              .external(name: "SkeletonView"),
              .external(name: "SnapKit")
             ]),
    
    //MARK: Foundations
    .framework("TNUI",
               sources: ["Foundations/TNUI/Sources/**/*.swift"],
               resources: [
                "Foundations/TNUI/Sources/**/*.xib",
                "Foundations/TNUI/Resources/**/*.xcassets",
                "Foundations/TNUI/Resources/**/*.json",
               ],
               dependencies: [
                .target(name: "Utils"),
                .external(name: "RxSwift")
               ]),
    .framework("Dependency",
               sources: ["Foundations/Dependency/**/*.swift"],
               resources: [],
               dependencies: [
                .target(name: "Networking"),
                .target(name: "Coordinator")
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
               dependencies: [
                .target(name: "NetworkManager")
               ]
              ),
    .framework("Utils",
               sources: ["Foundations/Utils/**/*.swift"],
               resources: [],
               dependencies: [
                .external(name: "RxSwift"),
               ]
              ),
    
      .framework("TheNorthCoreDataManager",
                 sources: ["Foundations/TheNorthCoreDataManager/**/*.swift"],
                 resources: ["Foundations/TheNorthCoreDataManager/Resources/**/*.json",
                             "Foundations/TheNorthCoreDataManager/Resources/**/*.xcdatamodeld"],
                 dependencies: []
                ),
    .framework("NetworkManager",
               sources: ["Foundations/NetworkManager/**/*.swift"],
               resources: [],
               dependencies: [.external(name: "KeychainSwift")]
              ),
    //MARK: Features
    .framework("AuthenticationFeature",
               sources: ["Features/AuthenticationFeature/Sources/**/*.swift"],
               resources: ["Features/AuthenticationFeature/Sources/**/*.xib",
                           "Features/AuthenticationFeature/Resources/**/*.xcassets"
                          ],
               dependencies: [
                .target(name: "TNUI"),
                .target(name: "Dependency"),
                .external(name: "RxRelay"),
                .external(name: "RxCocoa"),
                .external(name: "RxSwift"),
                .target(name: "Coordinator")
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
                .target(name: "NetworkManager"),
                .external(name: "Kingfisher"),
                
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
                .target(name: "Utils"),
                .target(name: "NetworkManager")
                
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
                .target(name: "TheNorthCoreDataManager"),
                .target(name: "NetworkManager"),
                .external(name: "RxRelay"),
                .external(name: "RxCocoa"),
                .external(name: "RxSwift"),
                .external(name: "Kingfisher"),
                .target(name: "Utils"),
                .external(name: "SkeletonView"),
                .external(name: "SnapKit")
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
                .target(name: "TheNorthCoreDataManager"),
                .external(name: "SnapKit"),
                .external(name: "RxRelay"),
                .external(name: "RxCocoa"),
                .external(name: "RxSwift"),
                .target(name: "NetworkManager"),
                .external(name: "Kingfisher"),
                .target(name: "Utils")
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
                .external(name: "RxRelay"),
                .external(name: "RxCocoa"),
                .external(name: "RxSwift"),
                .target(name: "NetworkManager"),
                .external(name: "Kingfisher"),
                .target(name: "Utils"),
                .external(name: "SkeletonView"),
               ]),
    .framework("TabBarFeature",
               sources: ["Features/TabBarFeature/Sources/**/*.swift"],
               resources: [],
               dependencies: [
                .target(name: "TNUI"),
                .target(name: "Dependency"),
                .target(name: "Coordinator"),
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
      resources: ["App/Resources/**", "App/Resources/**/*.xcassets","App/Resources/**/*.mp4"
                 ],
      dependencies: dependencies,
      settings: .settings(
        base: ["OTHER_LDFLAGS": "$(inherited) -ObjC"])
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
      dependencies: dependencies,
      settings: .settings(
        base: ["OTHER_LDFLAGS": "$(inherited) -ObjC"])
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
      dependencies: dependencies,
      settings: .settings(
        base: ["OTHER_LDFLAGS": "$(inherited) -ObjC"])
    )
  }
  
}

extension String {
  var dashSeparator: String {
    self.replacingOccurrences(of: " ", with: "-")
  }
}
