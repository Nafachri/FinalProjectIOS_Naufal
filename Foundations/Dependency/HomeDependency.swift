//
//  HomeDependency.swift
//  The North
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import UIKit
import Networking
import Coordinator

public protocol HomeDependency {
  func homeCoordinator(_ navigationController: UINavigationController) -> Coordinator
}
