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
  func payRequestCoordinator(_ navigationController: UINavigationController) -> Coordinator
}
