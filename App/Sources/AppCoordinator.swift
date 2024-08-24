//
//  AppCoordinator.swift
//  The North
//
//  Created by Naufal Al-Fachri on 05/08/24.
//

import UIKit
import Coordinator
import Dependency
import KeychainSwift

class AppCoordinator: AppCoordinatorable, NavigationCoordinator {
  let keychain = KeychainSwift()
  let authDependency: AuthenticationDependency
  let profileDependency: ProfileDependency
  let settingDependency: SettingDependency
  let contactsDependency: ContactsDependency
  let onBoardingDependency: OnBoardingDependency
  let homeDependency: HomeDependency
  let payRequestDependency: PayRequestDependency
  let historyDependency: HistoryDependency
  let tabBarDependency: TabBarDependency
  weak var parentCoordinator: Coordinator?
  var childCoordinators = [Coordinator]()
  var navigationController: UINavigationController
  
  init(
    profileDependency: ProfileDependency,
    authDependency: AuthenticationDependency,
    settingDependency: SettingDependency,
    contactDependency: ContactsDependency,
    onBoardingDependency: OnBoardingDependency,
    homeDependency: HomeDependency,
    payRequestDependency: PayRequestDependency,
    historyDependency: HistoryDependency,
    tabBarDependency: TabBarDependency,
    navigationController: UINavigationController) {
      
      self.authDependency = authDependency
      self.profileDependency = profileDependency
      self.settingDependency = settingDependency
      self.contactsDependency = contactDependency
      self.onBoardingDependency = onBoardingDependency
      self.homeDependency = homeDependency
      self.payRequestDependency = payRequestDependency
      self.historyDependency = historyDependency
      self.tabBarDependency = tabBarDependency
      self.navigationController = navigationController
    }
  
  func start() {
    if keychain.get("userToken") == nil {
      showOnBoarding()
    } else {
      showTabBar()
    }
//    showTabBar()
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
  
//  func showContacts() {
//    let coordinator = contactsDependency.contactsCoordinator(navigationController)
//    addChildCoordinator(coordinator)
//    coordinator.start()
//  }
  
  func showOnBoarding() {
    let coordinator = onBoardingDependency.onBoardingCoordinator(navigationController)
    addChildCoordinator(coordinator)
    coordinator.start()
  }
  
  func showHome() {
    let coordinator = homeDependency.homeCoordinator(navigationController)
    addChildCoordinator(coordinator)
    coordinator.start()
  }
  
  func showPayRequest() {
    let coordinator = payRequestDependency.paymentCoordinator(navigationController)
    addChildCoordinator(coordinator)
    coordinator.start()
  }
  
  func showScanQR() {
    let coordinator = payRequestDependency.scanQRCoordinator(navigationController)
    addChildCoordinator(coordinator)
    coordinator.start()
  }
  
  func showHistory() {
    let coordinator = historyDependency.historyCoordinator(navigationController)
    addChildCoordinator(coordinator)
    coordinator.start()
  }
  
  func showTabBar() {
    let coordinator = tabBarDependency.tabBarCoordinator(navigationController)
    addChildCoordinator(coordinator)
    coordinator.start()
  }
}
