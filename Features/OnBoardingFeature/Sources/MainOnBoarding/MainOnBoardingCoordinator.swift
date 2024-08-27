//
//  MainOnBoardingCoordinator.swift
//  The North
//
//  Created by Naufal Al-Fachri on 07/08/24.
//

import Foundation
import Coordinator
import UIKit

// MARK: - MainOnBoardingCoordinator

class MainOnBoardingCoordinator: Coordinator {
  
  // MARK: - Properties
  
  weak var navigationController: UINavigationController!
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  // MARK: - Initializer
  
  init(
    navigationController: UINavigationController,
    childCoordinators: [Coordinator] = [],
    parentCoordinator: Coordinator? = nil
  ) {
    self.navigationController = navigationController
    self.childCoordinators = childCoordinators
    self.parentCoordinator = parentCoordinator
  }
  
  // MARK: - Coordinator Methods
  
  func start() {
    let mainOnBoardingVC = MainOnBoardingViewController(coordinator: self)
    navigationController.setViewControllers([mainOnBoardingVC], animated: true)
    startWithRoot(navigationController)
  }
  
  func letsGo() {
    let coordinator = SecondaryOnBoardingCoordinator(
      navigationController: navigationController,
      authdependency: OnBoardingModule.authDependency
    )
    addChildCoordinator(coordinator)
    coordinator.start()
  }
}
