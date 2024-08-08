//
//  HistoryModule.swift
//  Dependency
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import UIKit
import Dependency
import Networking
import Coordinator

public class HistoryModule: HistoryDependency {
  
  public func historyCoordinator(_ navigationController: UINavigationController) -> any Coordinator {
    HistoryCoordinator(navigationController: navigationController)
  }
  
  public func historyDetailCoordinator(_ navigationController: UINavigationController) -> any Coordinator {
    HistoryDetailCoordinator(navigationController: navigationController)
  }
  
  public init() {}
}
