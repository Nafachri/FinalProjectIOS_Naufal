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
import TheNorthCoreDataManager
import NetworkManager

// MARK: - HomeCoordinator

class HomeCoordinator: Coordinator {
  
  // MARK: - Properties
  
  weak var navigationController: UINavigationController!
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  let payRequestDependency: PayRequestDependency
  let contactsDependency: ContactsDependency
  let historyDependency: HistoryDependency
  let settingDependency: SettingDependency
  
  // MARK: - Initializer
  
  init(
    navigationController: UINavigationController,
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
  
  // MARK: - Coordinator Methods
  
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
    let coordinator = payRequestDependency.paymentCoordinator(navigationController)
    addChildCoordinator(coordinator)
    coordinator.start()
  }
  
  func goToGenerateQR() {
    let coordinator = payRequestDependency.generateQRCoordinator(navigationController)
    addChildCoordinator(coordinator)
    coordinator.start()
  }
  
  func goToTopUp(userData: ProfileResponse) {
    let nav = UINavigationController()
    let coordinator = payRequestDependency.paymentCoordinator(nav)
    addChildCoordinator(coordinator)
    coordinator.startPresent(userData: userData)
  }
  
  func goToContacts() {
    let nav = UINavigationController()
    let coordinator = contactsDependency.contactsCoordinator(nav)
    addChildCoordinator(coordinator)
    coordinator.startPresent()
  }
  
  func goToContactDetailQuickSend(quickSendData: QuickSendModel) {
    let nav = UINavigationController()
    let coordinator = contactsDependency.contactDetailCoordinator(nav)
    addChildCoordinator(coordinator)
    coordinator.startPresent(quickSendData: quickSendData)
  }
  
  func goToHistory() {
    let nav = UINavigationController()
    let coordinator = historyDependency.historyCoordinator(nav)
    addChildCoordinator(coordinator)
    coordinator.startPresent()
  }
  
  func goToHistoryDetail(with selectedData: TransactionResponse) {
    let nav = UINavigationController()
    let coordinator = historyDependency.historyDetailCoordinator(nav)
    addChildCoordinator(coordinator)
    coordinator.startPresent(with: selectedData)
  }
  
  func goToSetting() {
    let nav = UINavigationController()
    let coordinator = settingDependency.settingCoordinator(nav)
    addChildCoordinator(coordinator)
    coordinator.startPresent()
  }
}
