//
//  HistoryCoordinatorable.swift
//  Coordinator
//
//  Created by Naufal Al-Fachri on 09/08/24.
//

import Foundation
import TheNorthCoreDataManager

public protocol HistoryCoordinatorable: Coordinator {
  func start()
  func startPresent()
}
