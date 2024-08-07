//
//  AppCoordinator.swift
//  The North
//
//  Created by Naufal Al-Fachri on 05/08/24.
//

import UIKit
import Coordinator
import Dependency


class AppCoordinator: Coordinator, NavigationCoordinator {
  
  let authDependency: AuthenticationDependency
  let profileDependency: ProfileDependency
  let settingDependency: SettingDependency
  let contactsDependency: ContactsDependency
  let onBoardingDependency: OnBoardingDependency
  weak var parentCoordinator: Coordinator?
  var childCoordinators = [Coordinator]()
  var navigationController: UINavigationController
  
  init(
      profileDependency: ProfileDependency,
      authDependency: AuthenticationDependency,
      settingDependency: SettingDependency,
      contactDependency: ContactsDependency,
      onBoardingDependency: OnBoardingDependency,
       navigationController: UINavigationController) {
    
    self.authDependency = authDependency
         self.profileDependency = profileDependency
         self.settingDependency = settingDependency
         self.contactsDependency = contactDependency
         self.onBoardingDependency = onBoardingDependency
         self.navigationController = navigationController
  }
  
  func start() {
//    showLogin()
//    showProfile()
//    showSetting()
//    showContacts()
    showOnBoarding()
  }
  
  func showLogin() {
    let coordinator = authDependency.signinCoordinator(navigationController)
    addChildCoordinator(coordinator)
    coordinator.start()
  }
  
  func showProfile() {
    let coordinator = profileDependency.profileCoordinator(navigationController)
    addChildCoordinator(coordinator)
    coordinator.start()
  }
  
  func showSetting() {
    let coordinator = settingDependency.settingCoordinator(navigationController)
    addChildCoordinator(coordinator)
    coordinator.start()
  }
  
  func showContacts() {
    let coordinator = contactsDependency.contactsCoordinator(navigationController)
    addChildCoordinator(coordinator)
    coordinator.start()
  }
  
  func showOnBoarding() {
    let coordinator = onBoardingDependency.onBoardingCoordinator(navigationController)
    addChildCoordinator(coordinator)
    coordinator.start()
  }
  
}
