//
//  Observable + currency.swift
//  The North
//
//  Created by Naufal Al-Fachri on 12/08/24.
//

import RxSwift
import Foundation

public extension ObservableType where Element == String {
  func currencyFormattedToValue() -> Observable<String> {
    return asObservable().map { currencyString in
      let formatter = Constants.moneyFormatter
      let value = formatter.number(from: currencyString)?.doubleValue ?? 0.00
      return String(value)
    }
  }
  
  
  func valueToCurrencyFormatted() -> Observable<String> {
    return asObservable().map { valueString in
      let formatter = Constants.moneyFormatter
      let cleanedValue = valueString.removingNonNumericCharacters()
      let number = NSNumber(value: (cleanedValue as NSString).doubleValue)
      
      guard number != 0 else {
        return "IDR 0"
      }
      
      if let formattedString = formatter.string(from: number) {
        return formattedString.replacingOccurrences(of: "Rp", with: "Rp ")
      } else {
        return "Rp 0"
      }
    }
  }
  
  // New function that converts a formatted currency string back to an integer
  func currencyFormattedToInteger() -> Observable<Int> {
      return asObservable().map { valueString in
          // Remove non-numeric characters from the currency string
          let cleanedValue = valueString.removingNonNumericCharacters()
          // Convert the cleaned string to an integer
          let number = (cleanedValue as NSString).integerValue
          return number
      }
  }
}

public extension String {
  func removingNonNumericCharacters() -> String {
    let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
    return regex.stringByReplacingMatches(in: self, options: [], range: NSRange(location: 0, length: self.count), withTemplate: "")
  }
}
