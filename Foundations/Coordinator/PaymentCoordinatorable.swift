//
//  PaymentCoordinatorable.swift
//  Coordinator
//
//  Created by Naufal Al-Fachri on 18/08/24.
//

import Foundation
import TheNorthCoreDataManager
import NetworkManager

public protocol PaymentCoordinatorable: Coordinator {
  func startPresent(userData: ProfileResponse)
  func start(with selectedData: ListContactResponseData)
  func start(quickSendData: QuickSendModel)
}

