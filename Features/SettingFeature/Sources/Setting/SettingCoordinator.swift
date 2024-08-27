//
//  SettingCoordinator.swift
//  SettingFeature
//
//  Created by Naufal Al-Fachri on 05/08/24.
//

import Foundation
import Coordinator
import UIKit
import Dependency

class SettingCoordinator: SettingCoordinatorable {
  
  // MARK: - Properties
  weak var navigationController: UINavigationController!
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  // MARK: - Initializers
  init(navigationController: UINavigationController,
       childCoordinators: [Coordinator] = [],
       parentCoordinator: Coordinator? = nil
  ) {
    self.navigationController = navigationController
    self.childCoordinators = childCoordinators
    self.parentCoordinator = parentCoordinator
  }
  
  // MARK: - Coordinator Methods
  func start() {
    let appCoordinator = getParentCoordinator(from: self, with: "AppCoordinator") as? AppCoordinatorable
    appCoordinator?.showOnBoarding()
  }
  
  func startPresent() {
    let settingVC = SettingViewController(coordinator: self)
    navigationController.setViewControllers([settingVC], animated: false)
    let tabBarCoordinator = getParentCoordinator(from: self, with: "TabbarCoordinator") as? TabbarCoordinatorable
    tabBarCoordinator?.tabbarController
      .present(navigationController, animated: true)
  }
  
  func showOnBoarding() {
    let appCoordinator = getParentCoordinator(from: self, with: "AppCoordinator") as? AppCoordinatorable
    appCoordinator?.showOnBoarding()
  }
}
