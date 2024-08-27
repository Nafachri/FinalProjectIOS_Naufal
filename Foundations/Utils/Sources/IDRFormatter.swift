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
    currencyFormatter.currencySymbol = "Rp "
    currencyFormatter.usesGroupingSeparator = true // Disable commas in the output

    return currencyFormatter.string(from: number) ?? ""
}


public func formatToIDR(_ amount: NSNumber?) -> String {
    guard let amount = amount else {
        return "Invalid amount" // Handle the case where amount is nil
    }
    
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .currency
    numberFormatter.locale = Locale(identifier: "id_ID") // Locale for Indonesia
    numberFormatter.currencyCode = "IDR" // Set the currency code to IDR
    numberFormatter.currencySymbol = "Rp " // Optional: Set the symbol if needed
    numberFormatter.usesGroupingSeparator = true // Enable grouping separators (commas)

    return numberFormatter.string(from: amount) ?? "\(amount)"
}


