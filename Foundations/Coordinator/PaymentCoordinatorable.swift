//
//  PaymentCoordinatorable.swift
//  Coordinator
//
//  Created by Naufal Al-Fachri on 18/08/24.
//

import Foundation
import TheNorthCoreDataManager

public protocol PaymentCoordinatorable: Coordinator {
  func start(with selectedData: ContactModel)
}

