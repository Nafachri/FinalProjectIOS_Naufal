//
//  ProfileModule.swift
//  AuthenticationFeature
//
//  Created by Naufal Al-Fachri on 05/08/24.
//

import UIKit
import Dependency
import Networking
import Coordinator

public class ProfileModule: ProfileDependency {
  
  public func profileCoordinator(_ navigationController: UINavigationController) -> Coordinator {
    ProfileCoordinator(navigationController: navigationController)
  }
  
  public init() {}
  
}
                              
