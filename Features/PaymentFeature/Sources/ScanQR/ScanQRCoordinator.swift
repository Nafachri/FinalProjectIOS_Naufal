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
    let scanQRVC = ScanQRViewController(coordinator: self)
    let tabBarCoordinator = getParentCoordinator(from: self, with: "TabbarCoordinator") as? TabbarCoordinatorable
    tabBarCoordinator?.tabbarController
      .present(scanQRVC, animated: true)
  }
  
  func showSuccess() {
    let successVC = SuccessScreenViewController()
    let tabBarCoordinator = getParentCoordinator(from: self, with: "TabbarCoordinator") as? TabbarCoordinatorable
    tabBarCoordinator?.tabbarController.present(successVC, animated: true)
  }
}
