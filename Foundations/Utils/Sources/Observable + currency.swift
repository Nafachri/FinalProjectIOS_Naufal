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
  
// MARK: Cara Mas Amin GPT
//  func valueToCurrencyFormatted() -> Observable<String> {
//      return self.map { valueString in
//          let formatter = Constants.moneyFormatter
//          let cleanedValue = valueString.removingNonNumericCharacters()
//          let number = NSNumber(value: (cleanedValue as NSString).doubleValue)
//          
//          guard number != 0 else {
//              return "IDR 0.00"
//          }
//          
//          return formatter.string(from: number) ?? "IDR 0.00"
//      }
//  }
  
//  MARK: Cara Chat GPT
  func valueToCurrencyFormatted() -> Observable<String> {
    return asObservable().map { valueString in
      let formatter = Constants.moneyFormatter
      let cleanedValue = valueString.removingNonNumericCharacters()
      let number = NSNumber(value: (cleanedValue as NSString).doubleValue)
      
      guard number != 0 else {
        return "IDR 0"
      }
      
      return formatter.string(from: number) ?? "IDR 0"
    }
  }
}

private extension String {
  func removingNonNumericCharacters() -> String {
    let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
    return regex.stringByReplacingMatches(in: self, options: [], range: NSRange(location: 0, length: self.count), withTemplate: "")
  }
}


//public extension ObservableType where Element == String {
//
//    func currencyFormattedToValue() -> Observable<String> {
//        return asObservable().flatMap { currencyString -> Observable<String> in
//          let formatter = Constants.moneyFormatter
//          let value = Double(truncating: formatter.number(from: currencyString) ?? 0.00)
//          return Observable.just("\(value)")
//        }
//    }
//
//    func valueToCurrencyFormatted() -> Observable<String> {
//        return asObservable().flatMap { valueString -> Observable<String> in
//          let formatter = Constants.moneyFormatter
//          var amountWithPrefix = valueString
//          var number: NSNumber!
//
//          let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
//          amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, valueString.count), withTemplate: "")
//
//          let double = (amountWithPrefix as NSString).doubleValue
//          number = NSNumber(value: (double))
//
//          guard number != 0 as NSNumber else {
//            return Observable.just("IDR 0.00")
//          }
//          return Observable.just(formatter.string(from: number)!)
//      }
//  }
//}
