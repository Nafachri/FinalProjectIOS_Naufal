//
//  MidtransCoordinatorable.swift
//  Coordinator
//
//  Created by Naufal Al-Fachri on 23/08/24.
//

import Foundation

public protocol MidtransCoordinatorable: Coordinator {
  func start(token: String)
}

