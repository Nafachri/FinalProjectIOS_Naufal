//
//  SettingDependency.swift
//  ProfileFeature
//
//  Created by Naufal Al-Fachri on 05/08/24.
//

import UIKit
import Networking
import Coordinator

public protocol SettingDependency {
  func settingCoordinator(_ navigationController: UINavigationController) -> Coordinator
}
