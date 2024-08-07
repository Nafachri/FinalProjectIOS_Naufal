//
//  ProfileDependency.swift
//  AuthenticationFeature
//
//  Created by Naufal Al-Fachri on 05/08/24.
//

import UIKit
import Networking
import Coordinator

public protocol ProfileDependency {
  func profileCoordinator(_ navigationController: UINavigationController) -> Coordinator
}
