//
//  PaymentViewModel.swift
//  PaymentFeature
//
//  Created by Naufal Al-Fachri on 13/08/24.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import Utils

class PaymentViewModel {
  
  // Input observables
  let numberTapped = PublishSubject<String>()
  let dotTapped = PublishSubject<Void>()
  let deleteTapped = PublishSubject<Void>()
  let payButtonTapped = PublishSubject<Void>()
  
  let inputText: Observable<String>
  let payButtonOutput: Observable<String>
  
  init() {
    // Merge number, dot, and delete taps
    let buttonTaps = Observable.merge(
      numberTapped,
      dotTapped.map { "." },
      deleteTapped.map { "" }
    )
    
    // Accumulate text input and format it as a currency
    inputText = buttonTaps.scan("") { currentText, tappedValue in
      if tappedValue.isEmpty { // Handle delete
        return String(currentText.dropLast())
      } else if tappedValue == "." { // Handle dot
        return currentText.contains(".") ? currentText : currentText + tappedValue
      } else { // Handle numbers
        return currentText + tappedValue
      }
    }
    .startWith("")
    .flatMapLatest { text in
      Observable.just(text)
        .valueToCurrencyFormatted()
        .observe(on: MainScheduler.instance)
      
    }
        payButtonOutput = payButtonTapped
          .withLatestFrom(inputText) // Combine with the latest inputText
          .map { "Final Input: \($0)" } // Format the message
          .observe(on: MainScheduler.instance)
  }
}
