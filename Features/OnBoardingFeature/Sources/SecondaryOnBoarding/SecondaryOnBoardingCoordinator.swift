//
//  SecondaryOnBoardingCoordinator.swift
//  OnBoardingFeature
//
//  Created by Naufal Al-Fachri on 07/08/24.
//

import Foundation
import Coordinator
import UIKit
import Dependency

// MARK: - SecondaryOnBoardingCoordinator

class SecondaryOnBoardingCoordinator: Coordinator {
  
  // MARK: - Properties
  
  weak var navigationController: UINavigationController!
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  let authDependency: AuthenticationDependency
  
  // MARK: - Initializer
  
  init(navigationController: UINavigationController,
       childCoordinators: [Coordinator] = [],
       parentCoordinator: Coordinator? = nil,
       authdependency: AuthenticationDependency) {
    self.navigationController = navigationController
    self.childCoordinators = childCoordinators
    self.parentCoordinator = parentCoordinator
    self.authDependency = authdependency
  }
  
  // MARK: - Coordinator Methods
  
  func start() {
    let secondaryOnBoardingVC = SecondaryOnBoardingViewController(coordinator: self)
    navigationController.show(secondaryOnBoardingVC, sender: nil)
  }
  
  func goToSignIn() {
    let coordinator = authDependency.signinCoordinator(navigationController)
    addChildCoordinator(coordinator)
    coordinator.start()
  }
}
