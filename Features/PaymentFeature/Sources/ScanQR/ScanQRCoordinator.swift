//
//  ScanQRCoordinator.swift
//  The North
//
//  Created by Naufal Al-Fachri on 12/08/24.
//

import Foundation
import Coordinator
import UIKit
import TNUI

class ScanQRCoordinator: Coordinator {
  
  // MARK: - Properties
  weak var navigationController: UINavigationController!
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  // MARK: - Initializer
  init(navigationController: UINavigationController,
       childCoordinators: [Coordinator] = [],
       parentCoordinator: Coordinator? = nil) {
    self.navigationController = navigationController
    self.childCoordinators = childCoordinators
    self.parentCoordinator = parentCoordinator
  }
  
  // MARK: - Coordinator Methods
  func start() {
    let scanQRVC = ScanQRViewController(coordinator: self)
    let tabBarCoordinator = getParentCoordinator(from: self, with: "TabbarCoordinator") as? TabbarCoordinatorable
    tabBarCoordinator?.tabbarController.present(scanQRVC, animated: true)
  }
  
  func showSuccess(transactionName: String,
                   transactionAmount: String,
                   transactionDate: String,
                   transactionTitle: String,
                   transactionId: String,
                   transactionType: String) {
    let successVC = SuccessScreenViewController(
      transactionName: transactionName,
      transactionAmount: transactionAmount,
      transactionDate: transactionDate,
      transactionTitle: transactionTitle,
      transactionId: transactionId,
      transactionType: transactionType
    )
    
    let tabBarCoordinator = getParentCoordinator(from: self, with: "TabbarCoordinator") as? TabbarCoordinatorable
    tabBarCoordinator?.tabbarController.present(successVC, animated: true)
  }
}
