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
import TheNorthCoreDataManager
import TNUI
import NetworkManager

// MARK: - PaymentCoordinator

class PaymentCoordinator: PaymentCoordinatorable {
  
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
    let paymentVC = PaymentViewController(coordinator: self)
    navigationController.pushViewController(paymentVC, animated: true)
  }
  
  func startPresent(userData: ProfileResponse) {
    let paymentVC = PaymentViewController(coordinator: self)
    paymentVC.userData = userData
    paymentVC.typeTransaction = .topup
    navigationController.setViewControllers([paymentVC], animated: false)
    let tabBarCoordinator = getParentCoordinator(from: self, with: "TabbarCoordinator") as? TabbarCoordinatorable
    tabBarCoordinator?.tabbarController.present(navigationController, animated: true)
  }
  
  func start(with selectedData: ListContactResponseData) {
    let paymentVC = PaymentViewController(coordinator: self)
    paymentVC.selectedData = selectedData
    navigationController.pushViewController(paymentVC, animated: true)
  }
  
  func start(quickSendData: QuickSendModel) {
    let paymentVC = PaymentViewController(coordinator: self)
    paymentVC.quickSendData = quickSendData
    navigationController.pushViewController(paymentVC, animated: true)
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
  
  func goToMidtrans(token: String) {
    let coordinator = MidtransCoordinator(navigationController: navigationController)
    addChildCoordinator(coordinator)
    coordinator.start(token: token)
  }
}
