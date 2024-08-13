//
//  Constants.swift
//  The North
//
//  Created by Naufal Al-Fachri on 12/08/24.
//

import Foundation

public struct Constants {
  static var moneyFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencySymbol = "IDR"
    formatter.locale = Locale(identifier: "id_ID") 
    formatter.maximumFractionDigits = 0
    return formatter
  }()
}
