//
//  PayRequestCoordinatorable.swift
//  Coordinator
//
//  Created by Naufal Al-Fachri on 11/08/24.
//

import Foundation
import TheNorthCoreDataManager

public protocol PayRequestCoordinatorable: Coordinator {
  func startPresent()
  func start(quickSendData: QuickSendModel)
  func start(with selectedData: ContactModel)
  func start(userData: UserModel)
}
