//
//  GenerateTransactionID.swift
//  Utils
//
//  Created by Naufal Al-Fachri on 19/08/24.
//

import Foundation

public func generateTransactionID() -> String {
  let randomID = Int.random(in: 100000...999999)
  return "transaction-\(randomID)"
}
