//
//  PayRequestDependency.swift
//  HomeFeature
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import UIKit
import Networking
import Coordinator

public protocol PayRequestDependency {
  func paymentCoordinator(_ navigationController: UINavigationController) -> PaymentCoordinatorable
  func scanQRCoordinator(_ navigationController: UINavigationController) -> Coordinator
  func generateQRCoordinator(_ navigationController: UINavigationController) ->
      Coordinator
  func midtransCoordinator(_ navigationController: UINavigationController) -> Coordinator
}


