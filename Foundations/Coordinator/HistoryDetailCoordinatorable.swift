//
//  HistoryDetailCoordinatorable.swift
//  Coordinator
//
//  Created by Naufal Al-Fachri on 18/08/24.
//

import Foundation
import TheNorthCoreDataManager
import NetworkManager

public protocol HistoryDetailCoordinatorable: Coordinator {
  func startPresent(with selectedData: TransactionResponse)
  func start(with selectedData: TransactionResponse)
}
