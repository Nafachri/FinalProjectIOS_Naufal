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
  
  // MARK: - Properties

  weak var navigationController: UINavigationController!
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  var tabBarDependency: TabBarDependency
  
  // MARK: - Initializer

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
  
  // MARK: - Start Method
  
  func start() {
    let signInViewController = SignInViewController(coordinator: self)
    navigationController.setViewControllers([signInViewController], animated: true)
    startWithRoot(navigationController)
  }
  
  // MARK: - Navigation Methods

  func showOnBoarding() {
    let appCoordinator = getParentCoordinator(from: self, with: "AppCoordinator") as? AppCoordinatorable
    appCoordinator?.showOnBoarding()
  }
  
  func goToDashboard() {
    let tabBarCoordinator = tabBarDependency.tabBarCoordinator(navigationController)
    let appCoordinator = getParentCoordinator(from: self, with: "AppCoordinator")
    appCoordinator?.addChildCoordinator(tabBarCoordinator)
    tabBarCoordinator.start()
  }
}
