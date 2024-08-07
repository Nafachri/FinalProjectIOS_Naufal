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
              .target(name: "PayRequestFeature"),
              .target(name: "ContactsFeature"),
              .target(name: "OnBoardingFeature"),
              .external(name: "netfox"),
]),
    
    //MARK: Foundations
    .framework("TNUI",
               sources: ["Foundations/TNUI/**"],
               resources: [],
               dependencies: []),
    .framework("Dependency",
               sources: ["Foundations/Dependency/**"],
               resources: [],
               dependencies: [
                .target(name: "Networking")
               ]),
    .framework("Networking",
               sources: ["Foundations/Networking/**"],
               resources: [],
               dependencies: [
                .external(name: "Alamofire"),
                .external(name: "RxSwift"),
               ]),
    .framework("Coordinator",
               sources: ["Foundations/Coordinator/**"],
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
               resources: ["Features/AuthenticationFeature/Sources/**/*.xib",         "Features/AuthenticationFeature/Resources/**/*.xcassets"
                          ],
               dependencies: [
                .target(name: "TNUI"),
                .target(name: "Dependency"),
                .target(name: "Services"),
                .external(name: "RxSwift"),
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
    .framework("PayRequestFeature",
               sources: ["Features/PayRequestFeature/Sources/**/*.swift"],
               resources: ["Features/PayRequestFeature/Sources/**/*.xib",
                           "Features/PayRequestFeature/Resources/**/*.xcassets"
                          ],
               dependencies: [
                .target(name: "TNUI"),
                .target(name: "Dependency"),
                .target(name: "Coordinator"),
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
      resources: ["App/Resources/**", "App/Resources/**/*.xcassets"],
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
