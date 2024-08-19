//
//  ContactDetailCoordinatorable.swift
//  Coordinator
//
//  Created by Naufal Al-Fachri on 18/08/24.
//

import Foundation
import TheNorthCoreDataManager

public protocol ContactDetailCoordinatorable: Coordinator {
  func start(with selectedData: ContactModel)
  func startPresent(with selectedData: ContactModel)
  func startPresent(quickSendData: QuickSendModel)
  
  
}
