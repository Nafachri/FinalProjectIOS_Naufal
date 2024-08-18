//
//  ContactsDependency.swift
//  ContactsFeature
//
//  Created by Naufal Al-Fachri on 07/08/24.
//

import UIKit
import Coordinator

public protocol ContactsDependency{
  func contactsCoordinator(_ navigationController: UINavigationController) -> ContactsCoordinatorable
  func contactDetailCoordinator(_ navigationController: UINavigationController) -> ContactDetailCoordinatorable
}
