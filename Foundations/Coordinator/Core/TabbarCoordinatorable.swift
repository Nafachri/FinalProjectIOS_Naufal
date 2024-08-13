//
//  TabbarCoordinatorable.swift
//  Coordinator
//
//  Created by Naufal Al-Fachri on 09/08/24.
//

import UIKit

public protocol TabbarCoordinatorable: Coordinator {
  var tabbarController: UITabBarController { get set }
}
