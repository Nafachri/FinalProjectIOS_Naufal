//
//  PayRequestCoordinator.swift
//  HomeFeature
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import Foundation
import Coordinator
import UIKit

class PayRequestCoordinator: Coordinator {
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
//    let payRequestVC = PayRequestViewController(coordinator: self)
//    navigationController.setViewControllers([payRequestVC], animated: true)
//    startWithRoot(navigationController)
//  }
  
  func start(){
    let payRequestVC = PayRequestViewController(coordinator: self)
    navigationController.pushViewController(payRequestVC, animated: true)
  }
}
