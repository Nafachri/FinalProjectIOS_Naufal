//
//  ContactsDependency.swift
//  ContactsFeature
//
//  Created by Naufal Al-Fachri on 07/08/24.
//

import UIKit
import Networking
import Coordinator

public protocol ContactsDependency{
  func contactsCoordinator(_ navigationController: UINavigationController) -> Coordinator
  func contactDetailCoordinator(_ navigationController: UINavigationController) -> Coordinator
}
