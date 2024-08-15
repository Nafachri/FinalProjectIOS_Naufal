//
//  IDR Formatter.swift
//  Utils
//
//  Created by Naufal Al-Fachri on 15/08/24.
//

import Foundation

public func formatCurrency(_ amountString: String) -> String {
    let inputFormatter = NumberFormatter()
    inputFormatter.numberStyle = .decimal
    inputFormatter.locale = Locale(identifier: "en_US") // Use a locale that supports decimal points
    inputFormatter.usesGroupingSeparator = false // Disable commas in the input
    
    guard let number = inputFormatter.number(from: amountString) else {
        return "Invalid amount"
    }
    
    let currencyFormatter = NumberFormatter()
    currencyFormatter.numberStyle = .currency
    currencyFormatter.currencyCode = "IDR"
    currencyFormatter.locale = Locale(identifier: "id_ID") // Indonesian locale
    currencyFormatter.usesGroupingSeparator = true // Disable commas in the output

    return currencyFormatter.string(from: number) ?? ""
}
