//
//  SettingModule.swift
//  SettingFeature
//
//  Created by Naufal Al-Fachri on 05/08/24.
//

import UIKit
import Dependency
import Networking
import Coordinator

public class SettingModule: SettingDependency {
  
  public func settingCoordinator(_ navigationController: UINavigationController) -> any Coordinator {
    SettingCoordinator(navigationController: navigationController)
  }
  
  public init() {}
  
}
