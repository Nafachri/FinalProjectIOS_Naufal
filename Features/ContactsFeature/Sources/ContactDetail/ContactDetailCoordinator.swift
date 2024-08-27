//
//  ContactDetailCoordinator.swift
//  ContactsFeature
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import Foundation
import Coordinator
import Dependency
import UIKit
import TheNorthCoreDataManager
import NetworkManager

class ContactDetailCoordinator: ContactDetailCoordinatorable {
  
  // MARK: - Properties
  weak var navigationController: UINavigationController!
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  private let paymentDependency: PayRequestDependency
    
  // MARK: - Initialization
  init(navigationController: UINavigationController,
       childCoordinators: [Coordinator] = [],
       parentCoordinator: Coordinator? = nil,
       paymentDependency: PayRequestDependency) {
      self.navigationController = navigationController
      self.childCoordinators = childCoordinators
      self.parentCoordinator = parentCoordinator
      self.paymentDependency = paymentDependency
  }
  
  
  
  // MARK: - Public Methods
  func start() {
    _ = pushContactDetailViewController()
  }
  
  func start(with selectedData: ListContactResponseData) {
      let contactDetailVC = pushContactDetailViewController()
      contactDetailVC.selectedData = selectedData
  }
  
  func startPresent(with selectedData: ListContactResponseData) {
      presentContactDetailViewController(with: selectedData)
  }
  
  func startPresent(quickSendData: QuickSendModel) {
      presentContactDetailViewController(quickSendData: quickSendData)
  }
  
  func goToPayment(with selectedData: ListContactResponseData) {
      navigateToPayment(with: selectedData)
  }
  
  func goToPayment(quickSendData: QuickSendModel) {
      navigateToPayment(quickSendData: quickSendData)
  }
  
  // MARK: - Private Methods
  private func pushContactDetailViewController() -> ContactDetailViewController {
      let contactDetailVC = ContactDetailViewController(coordinator: self)
      navigationController.pushViewController(contactDetailVC, animated: true)
      return contactDetailVC
  }
  
  private func presentContactDetailViewController(with selectedData: ListContactResponseData? = nil, quickSendData: QuickSendModel? = nil) {
      let contactDetailVC = ContactDetailViewController(coordinator: self)
      if let selectedData = selectedData {
          contactDetailVC.selectedData = selectedData
      }
      if let quickSendData = quickSendData {
          contactDetailVC.quickSendData = quickSendData
      }
      navigationController.setViewControllers([contactDetailVC], animated: false)
      
      if let tabBarCoordinator = getParentCoordinator(from: self, with: "TabbarCoordinator") as? TabbarCoordinatorable {
          tabBarCoordinator.tabbarController.present(navigationController, animated: true)
      }
  }
  
  private func navigateToPayment(with selectedData: ListContactResponseData? = nil, quickSendData: QuickSendModel? = nil) {
      let coordinator = paymentDependency.paymentCoordinator(navigationController)
      addChildCoordinator(coordinator)
      
      if let selectedData = selectedData {
          coordinator.start(with: selectedData)
      }
      
      if let quickSendData = quickSendData {
          coordinator.start(quickSendData: quickSendData)
      }
  }
  
  internal func addChildCoordinator(_ coordinator: Coordinator) {
      childCoordinators.append(coordinator)
  }
}
