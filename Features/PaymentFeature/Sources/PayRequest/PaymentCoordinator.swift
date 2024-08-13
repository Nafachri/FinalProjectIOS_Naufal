//
//  PayRequestCoordinator.swift
//  HomeFeature
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import Foundation
import Coordinator
import UIKit
import Dependency

class PaymentCoordinator: Coordinator {
  weak var navigationController: UINavigationController!
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start(){
    let paymentVC = PaymentViewController(coordinator: self)
    navigationController.pushViewController(paymentVC, animated: true)
  }  
}
