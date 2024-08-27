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
import TNUI

// MARK: - MidtransCoordinator

class MidtransCoordinator: MidtransCoordinatorable {
  
  // MARK: - Properties
  
  weak var navigationController: UINavigationController!
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  
  // MARK: - Initializer
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Methods
  
  func start() {
    let midtransVC = MidtransViewController(coordinator: self)
    let tabBarCoordinator = getParentCoordinator(from: self, with: "TabbarCoordinator") as? TabbarCoordinatorable
    tabBarCoordinator?.tabbarController
      .present(midtransVC, animated: true)
  }
  
  func start(token: String) {
    let midtransVC = MidtransViewController(coordinator: self)
    midtransVC.token = token
    let tabBarCoordinator = getParentCoordinator(from: self, with: "TabbarCoordinator") as? TabbarCoordinatorable
    tabBarCoordinator?.tabbarController
      .present(midtransVC, animated: true)
  }
  
  func showSuccess(transactionName: String, transactionAmount: String, transactionDate: String, transactionTitle: String, transactionId: String, transactionType: String) {
    let successVC = SuccessScreenViewController(
      transactionName: transactionName,
      transactionAmount: transactionAmount,
      transactionDate: transactionDate,
      transactionTitle: transactionTitle,
      transactionId: transactionId,
      transactionType: transactionType
    )

    if let topController = UIApplication.shared.topMostViewController() {
      topController.present(successVC, animated: true, completion: nil)
    } else {
      print("Unable to find the topmost view controller.")
    }
  }
}
