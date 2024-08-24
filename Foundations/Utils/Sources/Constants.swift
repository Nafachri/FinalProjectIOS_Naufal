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

public extension String {

    // Function that converts a formatted currency string back to an integer
    func currencyFormattedToInteger() -> Int {
        // Remove non-numeric characters from the currency string
        let cleanedValue = self.removingNonNumericCharacters()
        // Convert the cleaned string to an integer
        let number = (cleanedValue as NSString).integerValue
        return number
    }
}
