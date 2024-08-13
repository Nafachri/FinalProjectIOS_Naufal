//
//  GenerateQRCoordinator.swift
//  The North
//
//  Created by Naufal Al-Fachri on 12/08/24.
//

import Foundation
import Coordinator
import UIKit

class GenerateQRCoordinator: Coordinator {
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
    let generateQRVC = GenerateQRViewController(coordinator: self)
    let tabBarCoordinator = getParentCoordinator(from: self, with: "TabbarCoordinator") as? TabbarCoordinatorable
    tabBarCoordinator?.tabbarController
      .present(generateQRVC, animated: true)
  }
}
