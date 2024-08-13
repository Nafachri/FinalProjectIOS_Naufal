//
//  ContactsCoordinator.swift
//  ContactsFeature
//
//  Created by Naufal Al-Fachri on 07/08/24.
//

import Foundation
import Coordinator
import UIKit
import Dependency

class ContactsCoordinator: ContactsCoordinatorable {
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
    let contactsVC = ContactsViewController(coordinator: self)
    navigationController.setViewControllers([contactsVC], animated: false)
  }
  
  func startPresent() {
    let contactsVC = ContactsViewController(coordinator: self)
    navigationController.setViewControllers([contactsVC], animated: false)
    let tabBarCoordinator = getParentCoordinator(from: self, with: "TabbarCoordinator") as? TabbarCoordinatorable
    tabBarCoordinator?.tabbarController.present(navigationController, animated: true)
  }
  
  func goToContactDetail() {
    let coordinator = ContactDetailCoordinator(navigationController: navigationController,paymentDependency: paymentDependency)
    addChildCoordinator(coordinator)
    coordinator.start()
  }
}
