//
//  SignInCoordinator.swift
//  AuthenticationFeature
//
//  Created by Naufal Al-Fachri on 05/08/24.
//

import Foundation
import Coordinator
import Dependency
import UIKit

class SignInCoordinator: Coordinator {
  weak var navigationController: UINavigationController!
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  var tabBarDependency: TabBarDependency
  
  init(navigationController: UINavigationController,
       childCoordinators: [Coordinator] = [],
       parentCoordinator: Coordinator? = nil,
       tabBarDependency: TabBarDependency
  ) {
    self.navigationController = navigationController
    self.childCoordinators = childCoordinators
    self.parentCoordinator = parentCoordinator
    self.tabBarDependency = tabBarDependency
  }
  
  func start() {
    let signInViewController = SignInViewController(coordinator: self)
    navigationController.setViewControllers([signInViewController], animated: true)
    startWithRoot(navigationController)
  }
  
  func goToDashboard() {
    let tabBarCoordinator = tabBarDependency.tabBarCoordinator(navigationController)
    let appCoordinator = getParentCoordinator(from: self, with: "AppCoordinator")
    appCoordinator?.addChildCoordinator(tabBarCoordinator)
    tabBarCoordinator.start()
  }
}
