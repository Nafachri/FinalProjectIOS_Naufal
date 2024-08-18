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
    let buttonTaps = Observable.merge(
      numberTapped,
      dotTapped.map { "." },
      deleteTapped.map { "" }
    )
    
    inputText = buttonTaps.scan("") { currentText, tappedValue in
      if tappedValue.isEmpty {
        return String(currentText.dropLast())
      } else if tappedValue == "." {
        return currentText.contains(".") ? currentText : currentText + tappedValue
      } else {
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
          .withLatestFrom(inputText)
          .map {$0}
          .observe(on: MainScheduler.instance)
  }
}
