//
//  HistoryDependency.swift
//  Dependency
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import UIKit
import Networking
import Coordinator

public protocol HistoryDependency {
  func historyCoordinator(_ navigationController: UINavigationController) -> HistoryCoordinatorable
  func historyDetailCoordinator(_ navigationController: UINavigationController) -> HistoryCoordinatorable
}
