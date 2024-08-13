//
//  TabBarDependency.swift
//  Dependency
//
//  Created by Naufal Al-Fachri on 09/08/24.
//
import UIKit
import Coordinator

public protocol TabBarDependency {
  func tabBarCoordinator(_ navigationController: UINavigationController) -> Coordinator
}
