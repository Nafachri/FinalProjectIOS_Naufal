//
//  ProfileModule.swift
//  ProfileFeature
//
//  Created by Naufal Al-Fachri on 05/08/24.
//

import UIKit
import Dependency
import Networking
import Coordinator

public class ProfileModule: ProfileDependency {
  
  // MARK: - Initializers
  public init() {}
  
  // MARK: - Coordinator Generation
  public func profileCoordinator(_ navigationController: UINavigationController) -> any Coordinator {
    ProfileCoordinator(navigationController: navigationController)
  }
}
