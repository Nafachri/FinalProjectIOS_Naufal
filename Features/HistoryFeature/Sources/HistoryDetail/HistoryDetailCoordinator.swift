//
//  HistoryDetailCoordinator.swift
//  The North
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import Foundation
import Foundation
import Coordinator
import UIKit
import Dependency
import TheNorthCoreDataManager
import NetworkManager

class HistoryDetailCoordinator: HistoryDetailCoordinatorable {
  weak var navigationController: UINavigationController!
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  init(navigationController: UINavigationController,
       childCoordinators: [Coordinator] = [],
       parentCoordinator: Coordinator? = nil
  ) {
    self.navigationController = navigationController
    self.childCoordinators = childCoordinators
    self.parentCoordinator = parentCoordinator
  }
  
  func start(){
    let historyDetailVC = HistoryDetailViewController(coordinator: self)
    navigationController.pushViewController(historyDetailVC, animated: true)
  }
  
  func start(with selectedData: TransactionResponse){
    let historyDetailVC = HistoryDetailViewController(coordinator: self)
    historyDetailVC.selectedData = selectedData
    navigationController.pushViewController(historyDetailVC, animated: true)
  }
  
  func startPresent(with selectedData: TransactionResponse) {
    let historyDetailVC =
    HistoryDetailViewController(coordinator: self)
    historyDetailVC.selectedData = selectedData
    navigationController.setViewControllers([historyDetailVC], animated: false)
    let tabBarCoordinator = getParentCoordinator(from: self, with: "TabbarCoordinator") as? TabbarCoordinatorable
    tabBarCoordinator?.tabbarController
      .present(navigationController, animated: true)
  }
}
