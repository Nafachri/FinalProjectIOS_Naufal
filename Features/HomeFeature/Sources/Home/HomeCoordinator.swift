//
//  HomeCoordinator.swift
//  The North
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import Foundation
import Coordinator
import UIKit
import Dependency

class HomeCoordinator: Coordinator {
  weak var navigationController: UINavigationController!
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  let payRequestDependency: PayRequestDependency
  let contactsDependency: ContactsDependency
  let historyDependency: HistoryDependency
  let settingDependency: SettingDependency
  
  
  init(navigationController: UINavigationController,
       childCoordinators: [Coordinator] = [],
       parentCoordinator: Coordinator? = nil,
       payRequestDependency: PayRequestDependency,
       contactsDependency: ContactsDependency,
       historyDependency: HistoryDependency,
       settingDependency: SettingDependency
    ) {
    self.navigationController = navigationController
    self.childCoordinators = childCoordinators
    self.parentCoordinator = parentCoordinator
    self.payRequestDependency = payRequestDependency
    self.contactsDependency = contactsDependency
    self.historyDependency = historyDependency
    self.settingDependency = settingDependency
    
  }
  
  func start() {
    let homeVC = HomeViewController(coordinator: self)
    navigationController.setViewControllers([homeVC], animated: true)
  }
  
  func goToScanQR() {
    let coordinator = payRequestDependency.scanQRCoordinator(navigationController)
    addChildCoordinator(coordinator)
    coordinator.start()
  }
  
  func goToPayRequest() {
    let coordinator = payRequestDependency.payRequestCoordinator(navigationController)
    addChildCoordinator(coordinator)
    coordinator.start()
  }
  
  func goToGenerateQR() {
    let coordinator = payRequestDependency.generateQRCoordinator(navigationController)
    addChildCoordinator(coordinator)
    coordinator.start()
  }
  
  func goToTopUp() {
    let coordinator = payRequestDependency.midtransCoordinator(navigationController)
    addChildCoordinator(coordinator)
    coordinator.start()
  }
  
  func goToContacts(){
    let nav = UINavigationController()
    let coordinator = contactsDependency.contactsCoordinator(nav){contact in
      print("contact : \(contact)")
    }
    addChildCoordinator(coordinator)
    coordinator.startPresent()
  }
  
  func goToContactDetail() {
    let nav = UINavigationController()
    let coordinator = contactsDependency.contactDetailCoordinator(nav)
    addChildCoordinator(coordinator)
    coordinator.startPresent()
  }
  
  func goToHistory() {
    let nav = UINavigationController()
    let coordinator = historyDependency.historyCoordinator(nav)
    addChildCoordinator(coordinator)
    coordinator.startPresent()
  }
  
  func goToHistoryDetail() {
    let nav = UINavigationController()
    let coordinator = historyDependency.historyDetailCoordinator(nav)
    addChildCoordinator(coordinator)
    coordinator.startPresent()
  }
  
  func goToSetting() {
    let nav = UINavigationController()
    let coordinator = settingDependency.settingCoordinator(nav)
    addChildCoordinator(coordinator)
    coordinator.startPresent()
  }
}
