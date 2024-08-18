//
//  HistoryDetailCoordinatorable.swift
//  Coordinator
//
//  Created by Naufal Al-Fachri on 18/08/24.
//

import Foundation
import TheNorthCoreDataManager

public protocol HistoryDetailCoordinatorable: Coordinator {
  func startPresent(with selectedData: HistoryModel)
  func start(with selectedData: HistoryModel)
}
