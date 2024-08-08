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
  
  public func payRequestCoordinator(_ navigationController: UINavigationController) ->  Coordinator {
    PayRequestCoordinator(navigationController: navigationController)
  }
  public init() {}
}
