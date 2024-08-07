//
//  HandleDeeplink.swift
//  FoodApp
//
//  Created by Phincon on 24/07/24.
//

import Foundation

public protocol HandleDeeplink {
  func handleDeepLink(_ url: URL) -> Bool
}
