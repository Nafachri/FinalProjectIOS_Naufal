//
//  SceneDelegate.swift
//  The North
//
//  Created by Naufal Al-Fachri on 01/08/24.
//

import UIKit
import AuthenticationFeature
import ProfileFeature
import SettingFeature
import ContactsFeature
import OnBoardingFeature
import PaymentFeature
import HomeFeature
import HistoryFeature
import TabBarFeature
import Dependency
import TNUI
import MidtransKit
import TheNorthCoreDataManager
import netfox
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  // MARK: - Properties
  var window: UIWindow?
  var app: AppCoordinator?
  let coreData = CoreDataManager.shared
  
  // MARK: - UIWindowSceneDelegate
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
#if DEBUG
    NFX.sharedInstance().start()
#endif
    
    window = UIWindow(windowScene: windowScene)
    setupAppearance()
    setupMidtransConfig()
    
    let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
    print(paths[0])
    
    let nav = UINavigationController()
    window?.rootViewController = nav
    window?.makeKeyAndVisible()
    
    setupCoordinator(navigationController: nav)
    loadContactsData()
    
    let darkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")
    window?.overrideUserInterfaceStyle = darkModeEnabled ? .dark : .light
  }
  
  // MARK: - Private Methods
  private func setupAppearance() {
    UITabBar.appearance().unselectedItemTintColor = .gray
    UITabBar.appearance().tintColor = .label
  }
  
  private func setupMidtransConfig() {
    MidtransConfig.shared().setClientKey("SB-Mid-client-4zX2hEwOqCgsOpUX", environment: .sandbox, merchantServerURL:
                                          "https://merchant-url-sandbox.com"
    )
  }
  
  private func setupCoordinator(navigationController: UINavigationController) {
    let paymentDependency = PayRequestModule()
    let contactsDependency = ContactsModule(paymentDependency: paymentDependency)
    let historyDependency = HistoryModule()
    let settingDependency = SettingModule()
    let homeDependency = HomeModule(payRequestDependency: paymentDependency, contactsDependency: contactsDependency, historyDependency: historyDependency, settingDependency: settingDependency)
    let profileDependency = ProfileModule()
    let tabBarDependency = TabBarModule(homeDependency: homeDependency, contactsDependency: contactsDependency, historyDependency: historyDependency, profileDependency: profileDependency)
    let authenticationDependency = AuthenticationModule(tabBarDependency: tabBarDependency)
    let onboardingDependency = OnBoardingModule(authDependency: authenticationDependency)
    
    app = AppCoordinator(
      profileDependency: profileDependency,
      authDependency: authenticationDependency,
      settingDependency: settingDependency,
      contactDependency: contactsDependency,
      onBoardingDependency: onboardingDependency,
      homeDependency: homeDependency,
      payRequestDependency: paymentDependency,
      historyDependency: historyDependency,
      tabBarDependency: tabBarDependency,
      navigationController: navigationController
    )
    app?.start()
  }
  
  private func loadContactsData() {
    for contact in loadDataContact() {
      do {
        try coreData.create(entity: ContactModel.self, properties: contact)
      } catch {
        print("Failed to create contact: \(error.localizedDescription)")
      }
    }
  }
  
  private func loadDataContact() -> [[String: Any]] {
    guard let path = Bundle(for: TheNorthCoreDataManager.ContactModel.self).path(forResource: "contacts", ofType: "json") else {
      return []
    }
    
    do {
      let data = try Data(contentsOf: URL(fileURLWithPath: path))
      let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [[String: Any]]
      return jsonResult ?? []
    } catch {
      print("Error loading contacts data: \(error.localizedDescription)")
      return []
    }
  }
  
  // MARK: - UISceneDelegate Lifecycle Methods
  func sceneDidDisconnect(_ scene: UIScene) { }
  func sceneDidBecomeActive(_ scene: UIScene) { }
  func sceneWillResignActive(_ scene: UIScene) { }
  func sceneWillEnterForeground(_ scene: UIScene) { }
  func sceneDidEnterBackground(_ scene: UIScene) { }
}

// MARK: - Debugging Extensions
#if DEBUG

extension UIWindow {
  
  override open func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    // Implement if needed
  }
  
  func showSimpleActionSheet(controller: UIViewController) {
    let alert = UIAlertController(title: "Debug", message: "Choose an option", preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Network", style: .default) { _ in
      NFX.sharedInstance().show()
    })
    alert.addAction(UIAlertAction(title: "UI Debugging", style: .default) { _ in
    })
    controller.present(alert, animated: true)
  }
}

extension UIApplication {
  
  class func topViewController(base: UIViewController? = UIApplication.shared.connectedScenes
    .filter({ $0.activationState == .foregroundActive })
    .compactMap({ $0 as? UIWindowScene })
    .first?.windows
    .filter({ $0.isKeyWindow }).first?.rootViewController) -> UIViewController? {
      if let nav = base as? UINavigationController {
        return topViewController(base: nav.visibleViewController)
      }
      if let tab = base as? UITabBarController {
        return topViewController(base: tab.selectedViewController)
      }
      if let presented = base?.presentedViewController {
        return topViewController(base: presented)
      }
      return base
    }
}
#endif
