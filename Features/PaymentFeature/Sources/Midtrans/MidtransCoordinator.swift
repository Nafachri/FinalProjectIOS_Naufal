//
//  MitdtransCoordinator.swift
//  The North
//
//  Created by Naufal Al-Fachri on 13/08/24.
//

import Foundation
import Coordinator
import UIKit
import Dependency

class MidtransCoordinator: Coordinator {
  weak var navigationController: UINavigationController!
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start(){
    let midtransVC = MidtransViewController(coordinator: self)
    let tabBarCoordinator = getParentCoordinator(from: self, with: "TabbarCoordinator") as? TabbarCoordinatorable
    tabBarCoordinator?.tabbarController
      .present(midtransVC, animated: true)
  }
}
