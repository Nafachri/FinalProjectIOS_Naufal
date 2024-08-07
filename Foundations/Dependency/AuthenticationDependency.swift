//
//  AuthenticationDependency.swift
//  The North
//
//  Created by Naufal Al-Fachri on 03/08/24.
//

import UIKit
import Networking
import Coordinator

public protocol AuthenticationDependency {
  func signinCoordinator(_ navigationController: UINavigationController) -> Coordinator
}
