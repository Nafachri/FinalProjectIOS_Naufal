//
//  Constants.swift
//  The North
//
//  Created by Naufal Al-Fachri on 12/08/24.
//

import Foundation

public struct Constants {
  static let moneyFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = Locale(identifier: "id_ID") // Change as needed
    formatter.currencyCode = "IDR" // Change as needed
    return formatter
  }()
}
