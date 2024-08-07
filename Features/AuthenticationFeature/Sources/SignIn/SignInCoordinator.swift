//
//  SignInCoordinator.swift
//  AuthenticationFeature
//
//  Created by Naufal Al-Fachri on 05/08/24.
//

import Foundation
import Coordinator
import UIKit

class SignInCoordinator: Coordinator {
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
  
  func start() {
    let signInViewController = SignInViewController(coordinator: self)
    navigationController.setViewControllers([signInViewController], animated: true)
    startWithRoot(navigationController)
  }
}
