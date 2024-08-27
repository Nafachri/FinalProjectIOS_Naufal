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
import TheNorthCoreDataManager
import NetworkManager

class ContactsCoordinator: ContactsCoordinatorable {
  
  // MARK: - Properties
  weak var navigationController: UINavigationController!
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  private let paymentDependency: PayRequestDependency
  
  // MARK: - Initialization
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
  
  // MARK: - Coordinator Methods
  func start() {
      let contactsVC = ContactsViewController(coordinator: self)
      navigationController.setViewControllers([contactsVC], animated: false)
  }
  
  func startPresent() {
      let contactsVC = ContactsViewController(coordinator: self)
      navigationController.setViewControllers([contactsVC], animated: false)
      presentNavigationController()
  }
  
  func goToContactDetail(with selectedData: ListContactResponseData) {
      let contactDetailCoordinator = ContactDetailCoordinator(
          navigationController: navigationController,
          paymentDependency: paymentDependency
      )
      addChildCoordinator(contactDetailCoordinator)
      contactDetailCoordinator.start(with: selectedData)
  }
  
  // MARK: - Private Methods
  private func presentNavigationController() {
      guard let tabBarCoordinator = getParentCoordinator(
          from: self,
          with: "TabbarCoordinator"
      ) as? TabbarCoordinatorable else {
          return
      }
      tabBarCoordinator.tabbarController.present(navigationController, animated: true)
  }
}
