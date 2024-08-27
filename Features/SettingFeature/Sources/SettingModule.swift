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
  
  // MARK: - Public Methods
  public func settingCoordinator(_ navigationController: UINavigationController) -> SettingCoordinatorable {
    SettingCoordinator(navigationController: navigationController
    // Uncomment if needed
    // , onboardingDependency: onboardingDependency
    )
  }
  
  public init() {}
}
