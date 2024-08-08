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
  
  
  init(navigationController: UINavigationController,
       childCoordinators: [Coordinator] = [],
       parentCoordinator: Coordinator? = nil,
       payRequestDependency: PayRequestDependency,
       contactsDependency: ContactsDependency,
       historyDependency: HistoryDependency
    ) {
    self.navigationController = navigationController
    self.childCoordinators = childCoordinators
    self.parentCoordinator = parentCoordinator
    self.payRequestDependency = payRequestDependency
    self.contactsDependency = contactsDependency
    self.historyDependency = historyDependency
    
  }
  
  func start() {
    let homeVC = HomeViewController(coordinator: self)
    navigationController.setViewControllers([homeVC], animated: true)
    startWithRoot(navigationController)
  }
  
  func goToPayRequest() {
    let coordinator = payRequestDependency.payRequestCoordinator(navigationController)
    addChildCoordinator(coordinator)
    coordinator.start()
  }
  
  func goToContacts(){
    let coordinator =
    contactsDependency.contactsCoordinator(navigationController)
    addChildCoordinator(coordinator)
    coordinator.start()
  }
  
  func goToContactDetail() {
    let coordinator = contactsDependency.contactDetailCoordinator(navigationController)
    addChildCoordinator(coordinator)
    coordinator.start()
  }
  
  func goToHistory() {
    let coordinator = historyDependency.historyCoordinator(navigationController)
    addChildCoordinator(coordinator)
    coordinator.start()
  }
  
  func goToHistoryDetail() {
    let coordinator = historyDependency.historyDetailCoordinator(navigationController)
    addChildCoordinator(coordinator)
    coordinator.start()
  }
}
