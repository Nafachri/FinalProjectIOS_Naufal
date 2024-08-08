//
//  ContactsCoordinator.swift
//  ContactsFeature
//
//  Created by Naufal Al-Fachri on 07/08/24.
//

import Foundation
import Coordinator
import UIKit

class ContactsCoordinator: Coordinator {
  weak var navigationController: UINavigationController!
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  
  init(navigationController: UINavigationController,
       childCoordinators: [Coordinator] = [],
       parentCoordinator: Coordinator? = nil) {
    self.navigationController = navigationController
    self.childCoordinators = childCoordinators
    self.parentCoordinator = parentCoordinator
  }
  
  func start(){
    let contactsVC = ContactsViewController(coordinator: self)
    navigationController.pushViewController(contactsVC, animated: true)
//    let contactsVC = ContactsViewController(coordinator: self)
//    navigationController.setViewControllers([contactsVC], animated: true)
//    startWithRoot(navigationController)
  }
  
  func goToContactDetail() {
    let coordinator = ContactDetailCoordinator(navigationController: navigationController)
    addChildCoordinator(coordinator)
    coordinator.start()
  }
}
