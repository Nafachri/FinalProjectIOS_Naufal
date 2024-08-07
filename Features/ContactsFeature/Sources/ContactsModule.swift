//
//  ContactsModule.swift
//  ContactsFeature
//
//  Created by Naufal Al-Fachri on 07/08/24.
//

import UIKit
import Dependency
import Networking
import Coordinator

public class ContactsModule: ContactsDependency {
  
  public func contactsCoordinator(_ navigationController: UINavigationController) -> any Coordinator {
    ContactsCoordinator(navigationController: navigationController)
  }
  
  public init() {}
  
}
