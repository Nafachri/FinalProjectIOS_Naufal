//
//  SettingCoordinator.swift
//  SettingFeature
//
//  Created by Naufal Al-Fachri on 05/08/24.
//

import Foundation
import Coordinator
import UIKit

class SettingCoordinator: SettingCoordinatorable {

  
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
    let settingViewController = SettingViewController(coordinator: self)
    navigationController.setViewControllers([settingViewController], animated: true)
    startWithRoot(navigationController)
  }
  
  func startPresent() {
    let settingVC = SettingViewController(coordinator: self)
    navigationController.setViewControllers([settingVC], animated: false)
    let tabBarCoordinator = getParentCoordinator(from: self, with: "TabbarCoordinator") as? TabbarCoordinatorable
    tabBarCoordinator?.tabbarController
      .present(navigationController, animated: true)
  }
}
