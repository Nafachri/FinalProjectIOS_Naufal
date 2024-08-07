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
import Dependency
import netfox
//import FLEX

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  var authDependency = AuthenticationModule()
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    let nav = UINavigationController()
    window?.rootViewController = nav
    
//    let userInterfaceStyle = UserDefaults.standard.integer(forKey: "userInterfaceStyle")
//    window?.overrideUserInterfaceStyle = UIUserInterfaceStyle(rawValue: userInterfaceStyle) ?? .light
    
    window?.makeKeyAndVisible()
    
    //MARK: set theme
    
    let darkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")
    let style: UIUserInterfaceStyle = darkModeEnabled ? .dark : .light
    window?.overrideUserInterfaceStyle = style
    
//    #if DEBUG
//    NFX.sharedInstance().setGesture(.custom)
//    #endif
    
    //MARK: set coordinator
    let authenticationDependency = AuthenticationModule()
    let app = AppCoordinator(
      profileDependency: ProfileModule(),
      authDependency: authenticationDependency,
      settingDependency: SettingModule(),
      contactDependency: ContactsModule(),
      onBoardingDependency: OnBoardingModule(authDependency: authenticationDependency),
      navigationController: nav)
    app.start()
  }
  
  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
  }
  
  
}
#if DEBUG
extension UIWindow {
  override open func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    // code you want to implement
    
    if motion == .motionShake {
      guard let view = UIApplication.topViewController() else {
        return
      }
      
      if view.responds(to: Selector(("shouldForceLandscape"))) {
        // If the rootViewController should force landscape, do not handle shake
        return
      }
      showSimpleActionSheet(controller: view)
    }
    
  }
  
  func showSimpleActionSheet(controller: UIViewController) {
    let alert = UIAlertController(title: "debug", message: "sub", preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Network", style: .default, handler: { _ in
      NFX.sharedInstance().show()
    }))
    
    
    // show FLEX
    
    alert.addAction(UIAlertAction(title: "UI DEBUGGING 😮‍💨", style: .default, handler: { _ in
//      FLEXManager.shared.showExplorer()
    }))
    
    controller.present(alert, animated: true, completion: {})
    
    
  }
  
}

#endif


extension UIApplication {
  class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let nav = base as? UINavigationController {
      return topViewController(base: nav.visibleViewController)
    }
    if let tab = base as? UITabBarController {
      if let selected = tab.selectedViewController {
        return topViewController(base: selected)
      }
    }
    if let presented = base?.presentedViewController {
      return topViewController(base: presented)
    }
    return base
  }
  
  class func currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let nav = base as? UINavigationController {
      return topViewController(base: nav.viewControllers.last)
    }
    if let tab = base as? UITabBarController {
      if let selected = tab.selectedViewController {
        return topViewController(base: selected)
      }
    }
    if let presented = base?.presentedViewController {
      return topViewController(base: presented)
    }
    return base
  }
}

