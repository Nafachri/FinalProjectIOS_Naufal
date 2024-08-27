//
//  HistoryCoordinator.swift
//  Dependency
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import Foundation
import Coordinator
import UIKit
import TheNorthCoreDataManager
import NetworkManager

class HistoryCoordinator: HistoryCoordinatorable {
  
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
    let historyVC = HistoryViewController(coordinator: self)
    navigationController.setViewControllers([historyVC], animated: false)
  }
  
  func startPresent() {
    let historyVC = HistoryViewController(coordinator: self)
    navigationController.setViewControllers([historyVC], animated: false)
    let tabBarCoordinator = getParentCoordinator(from: self, with: "TabbarCoordinator") as? TabbarCoordinatorable
    tabBarCoordinator?.tabbarController
      .present(navigationController, animated: true)
  }
  
  func goToHistoryDetail(with selectedData: TransactionResponse) {
    let coordinator = HistoryDetailCoordinator(navigationController: navigationController)
    addChildCoordinator(coordinator)
    coordinator.start(with: selectedData)
  }
}
