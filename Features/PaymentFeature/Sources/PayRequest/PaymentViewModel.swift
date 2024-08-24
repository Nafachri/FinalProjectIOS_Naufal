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
import NetworkManager
import MidtransKit

class PaymentViewModel {
  private let APIService = APIManager.shared
  private let disposeBag = DisposeBag()
  
  let numberTapped = PublishSubject<String>()
  let dotTapped = PublishSubject<Void>()
  let deleteTapped = PublishSubject<Void>()
  let payButtonTapped = PublishSubject<Void>()
  let responseTransaction = PublishSubject<TransferResponse>()
  
  let responseTopUp = PublishSubject<TopUpResponse>()

  
  let inputText: Observable<String>
  let payButtonOutput: Observable<String>
  
  let isSuccess = PublishSubject<Bool>()
  let isLoading = BehaviorRelay<Bool>(value: false)
  let errorMessage = PublishSubject<String?>()
  
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


// MARK:  API Request
extension PaymentViewModel {
  
  // MARK: payRequest
  func payRequest(param: TransferParam){
    isLoading.accept(true)
    APIService.fetchRequest(endpoint: .transfer(param: param), expecting: TransferResponse.self) { [weak self]
      result in
      guard let self else { return }
      isLoading.accept(false)
      switch result {
      case .success(let response):
        responseTransaction.onNext(response)
      case .failure(let error):
        errorMessage.onNext(error.localizedDescription)
      }
    }
  }
  
  // MARK: topupRequest
  func topupRequest(param: TopUpParam){
    isLoading.accept(true)
    APIService.fetchRequest(endpoint: .topup(param: param), expecting: TopUpResponse.self) { [weak self]
      result in
      guard let self else { return }
      isLoading.accept(false)
      switch result {
      case .success(let response):
        responseTopUp.onNext(response)
      case .failure(let error):
        errorMessage.onNext(error.localizedDescription)
      }
    }
  }
  
  
}

