//
//  OnBoardingModule.swift
//  The North
//
//  Created by Naufal Al-Fachri on 07/08/24.
//

import UIKit
import Dependency
import Networking
import Coordinator

public class OnBoardingModule: OnBoardingDependency {
  
  static var authDependency: AuthenticationDependency!

 public init(authDependency: AuthenticationDependency){
    Self.authDependency = authDependency
  }
  
  public func onBoardingCoordinator(_ navigationController: UINavigationController) -> Coordinator {
    MainOnBoardingCoordinator(navigationController: navigationController)
  }  
}
