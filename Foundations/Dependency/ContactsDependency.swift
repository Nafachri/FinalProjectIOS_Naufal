//
//  ContactsDependency.swift
//  ContactsFeature
//
//  Created by Naufal Al-Fachri on 07/08/24.
//

import UIKit
import Coordinator

public protocol Modelable {
  
}

public protocol ContactsDependency{
  func contactsCoordinator(_ navigationController: UINavigationController, onSelect:((Modelable) -> Void)?) -> ContactsCoordinatorable
  func contactDetailCoordinator(_ navigationController: UINavigationController) -> ContactsCoordinatorable
}
