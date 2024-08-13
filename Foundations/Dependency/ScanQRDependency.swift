//
//  ScanQRDependency.swift
//  Dependency
//
//  Created by Naufal Al-Fachri on 12/08/24.
//

import UIKit
import Networking
import Coordinator

public protocol ScanQRDependency {
  func scanQRCoordinator(_ navigationController: UINavigationController) -> Coordinator
}
