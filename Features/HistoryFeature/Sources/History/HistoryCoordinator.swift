//
//  HistoryCoordinator.swift
//  Dependency
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import Foundation
import Coordinator
import UIKit

class HistoryCoordinator: Coordinator {
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
  
  //  func start() {
  //    let historyVC = HistoryViewController(coordinator: self)
  //    navigationController.setViewControllers([historyVC], animated: true)
  //    startWithRoot(navigationController)
  //  }
  
  func start() {
    let historyVC = HistoryViewController(coordinator: self)
    navigationController.pushViewController(historyVC, animated: true)
  }
  
  func goToHistoryDetail() {
    let coordinator = HistoryDetailCoordinator(navigationController: navigationController)
    addChildCoordinator(coordinator)
    coordinator.start()
  }
}
