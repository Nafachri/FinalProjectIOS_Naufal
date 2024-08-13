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

class ContactDetailCoordinator: ContactsCoordinatorable {
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
  
  func start(){
    let contactDetailVC = ContactDetailViewController(coordinator: self)
    navigationController.pushViewController(contactDetailVC, animated: true)
  }
  
  func startPresent() {
    let contactDetailVC = ContactDetailViewController(coordinator: self)
    navigationController.setViewControllers([contactDetailVC], animated: false)
    let tabBarCoordinator = getParentCoordinator(from: self, with: "TabbarCoordinator") as? TabbarCoordinatorable
    tabBarCoordinator?.tabbarController.present(navigationController, animated: true)
  }
  
  func goToPayment(){
    let coordinator = paymentDependency.payRequestCoordinator(navigationController)
    addChildCoordinator(coordinator)
    coordinator.start()
  }
}
