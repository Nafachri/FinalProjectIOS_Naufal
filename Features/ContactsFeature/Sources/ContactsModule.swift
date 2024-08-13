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
  
   var paymentDependency: PayRequestDependency!
  
  public init(paymentDependency: PayRequestDependency){
    self.paymentDependency = paymentDependency
  }
  
  public func contactsCoordinator(_ navigationController: UINavigationController) -> any ContactsCoordinatorable {
    ContactsCoordinator(navigationController: navigationController, paymentDependency: paymentDependency)
  }
  
  public func contactDetailCoordinator(_ navigationController: UINavigationController) -> any ContactsCoordinatorable {
    ContactDetailCoordinator(navigationController: navigationController, paymentDependency: paymentDependency)
  }
  
//  public func paymentCoordinator(_ navigationController: UINavigationController) -> any Coordinator {
//    paymentCoordinator.payRequestCoordinator(navigationController)
//  }
  
  
  
}
