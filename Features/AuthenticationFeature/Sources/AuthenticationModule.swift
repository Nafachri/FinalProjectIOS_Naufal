//
//  AuthenticationModule.swift
//  The North
//
//  Created by Naufal Al-Fachri on 03/08/24.
//

import UIKit
import Dependency
import Networking
import Coordinator

public class AuthenticationModule: AuthenticationDependency {
  
  public func signinCoordinator(_ navigationController: UINavigationController) -> Coordinator {
    SignInCoordinator(navigationController: navigationController)
  }
  
  public init() {}
}
