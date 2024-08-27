//
//  GenerateQRCoordinator.swift
//  The North
//
//  Created by Naufal Al-Fachri on 12/08/24.
//

import Foundation
import Coordinator
import UIKit

// MARK: - GenerateQRCoordinator

class GenerateQRCoordinator: Coordinator {
  
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
    let generateQRVC = GenerateQRViewController(coordinator: self)
    let tabBarCoordinator = getParentCoordinator(from: self, with: "TabbarCoordinator") as? TabbarCoordinatorable
    tabBarCoordinator?.tabbarController
      .present(generateQRVC, animated: true)
  }
}
