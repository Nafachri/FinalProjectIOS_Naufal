//
//  ContactDetailCoordinator.swift
//  ContactsFeature
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import Foundation
import Coordinator
import Dependency
import UIKit
import TheNorthCoreDataManager

class ContactDetailCoordinator: ContactDetailCoordinatorable {
  
  weak var navigationController: UINavigationController!
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  let paymentDependency: PayRequestDependency
    
  init(navigationController: UINavigationController,
       childCoordinators: [Coordinator] = [],
       parentCoordinator: Coordinator? = nil,
       paymentDependency: PayRequestDependency
  ) {
    self.navigationController = navigationController
    self.childCoordinators = childCoordinators
    self.parentCoordinator = parentCoordinator
    self.paymentDependency = paymentDependency
  }
  
  func start() {
      let contactDetailVC = ContactDetailViewController(coordinator: self)
      navigationController.pushViewController(contactDetailVC, animated: true)
  }
  
  func start(with selectedData: ContactModel){
    let contactDetailVC = ContactDetailViewController(coordinator: self)
    contactDetailVC.selectedData = selectedData
    navigationController.pushViewController(contactDetailVC, animated: true)
  }
  
  func startPresent(with selectedData: ContactModel) {
    let contactDetailVC = ContactDetailViewController(coordinator: self)
    contactDetailVC.selectedData = selectedData
    navigationController.setViewControllers([contactDetailVC], animated: false)
    let tabBarCoordinator = getParentCoordinator(from: self, with: "TabbarCoordinator") as? TabbarCoordinatorable
    tabBarCoordinator?.tabbarController.present(navigationController, animated: true)
  }
  func startPresent(quickSendData : QuickSendModel) {
    let contactDetailVC = ContactDetailViewController(coordinator: self)
    contactDetailVC.quickSendData = quickSendData
    navigationController.setViewControllers([contactDetailVC], animated: false)
    let tabBarCoordinator = getParentCoordinator(from: self, with: "TabbarCoordinator") as? TabbarCoordinatorable
    tabBarCoordinator?.tabbarController.present(navigationController, animated: true)
  }
  
  
  func goToPayment(with selectedData: ContactModel){
    let coordinator = paymentDependency.payRequestCoordinator(navigationController)
    addChildCoordinator(coordinator)
    coordinator.start(with: selectedData)
  }
  
  func goToPayment(quickSendData: QuickSendModel){
    let coordinator = paymentDependency.payRequestCoordinator(navigationController)
    addChildCoordinator(coordinator)
    coordinator.start(quickSendData: quickSendData)
  }
}
