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
  
//  var onboardingDependency: OnBoardingDependency
//  
//  public init(onboardingDependency: OnBoardingDependency){
//    self.onboardingDependency = onboardingDependency
//  }
  
  public func settingCoordinator(_ navigationController: UINavigationController) ->  SettingCoordinatorable {
    SettingCoordinator(navigationController: navigationController
//                       onboardingDependency: onboardingDependency
    )
  }
  public init (){}
}
