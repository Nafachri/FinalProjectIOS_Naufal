//
//  PayRequestModule.swift
//  HomeFeature
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import UIKit
import Dependency
import Networking
import Coordinator

public class PayRequestModule: PayRequestDependency {
  
  public init() {}

  public func generateQRCoordinator(_ navigationController: UINavigationController) -> Coordinator {
    GenerateQRCoordinator(navigationController: navigationController)
  }
  
  public func scanQRCoordinator(_ navigationController: UINavigationController) -> Coordinator {
    ScanQRCoordinator(navigationController: navigationController)
  }
  
  public func payRequestCoordinator(_ navigationController: UINavigationController) ->  Coordinator {
    PaymentCoordinator(navigationController: navigationController)
  }
}