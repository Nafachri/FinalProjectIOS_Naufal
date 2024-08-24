//
//  ContactDetailCoordinatorable.swift
//  Coordinator
//
//  Created by Naufal Al-Fachri on 18/08/24.
//

import Foundation
import TheNorthCoreDataManager
import NetworkManager

public protocol ContactDetailCoordinatorable: Coordinator {
  func start(with selectedData: ListContactResponseData)
  func startPresent(with selectedData: ListContactResponseData)
  func startPresent(quickSendData: QuickSendModel)
}
