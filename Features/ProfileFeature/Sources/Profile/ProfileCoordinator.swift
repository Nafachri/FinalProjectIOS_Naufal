//
//  ProfileCoordinator.swift
//  ProfileFeature
//
//  Created by Naufal Al-Fachri on 05/08/24.
//

import Foundation
import Coordinator
import UIKit
import Dependency

class ProfileCoordinator: Coordinator {
  
  // MARK: - Properties
  weak var navigationController: UINavigationController!
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  // MARK: - Initialization
  init(navigationController: UINavigationController,
       childCoordinators: [Coordinator] = [],
       parentCoordinator: Coordinator? = nil) {
    self.navigationController = navigationController
    self.childCoordinators = childCoordinators
    self.parentCoordinator = parentCoordinator
  }
  
  // MARK: - Coordinator Methods
  func start() {
    let profileViewController = ProfileViewController(coordinator: self)
    navigationController.setViewControllers([profileViewController], animated: true)
  }
}
