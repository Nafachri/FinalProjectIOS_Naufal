//
//  OnBoardingDependency.swift
//  Dependency
//
//  Created by Naufal Al-Fachri on 07/08/24.
//

import UIKit
import Networking
import Coordinator

public protocol OnBoardingDependency {
  func onBoardingCoordinator(_ navigationController: UINavigationController) -> Coordinator
}
