//
//  MidtransDependency.swift
//  Coordinator
//
//  Created by Naufal Al-Fachri on 23/08/24.
//

import UIKit
import Networking
import Coordinator

public protocol MidtransDependency {
  func midtransCoordinator(_ navigationController: UINavigationController) -> MidtransCoordinatorable
}
