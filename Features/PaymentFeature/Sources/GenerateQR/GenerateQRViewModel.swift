//
//  GenerateQRViewModel.swift
//  PaymentFeature
//
//  Created by Naufal Al-Fachri on 12/08/24.
//

import RxSwift
import RxRelay
import RxCocoa
import Foundation
import NetworkManager

// MARK: - GenerateQRViewModel

class GenerateQRViewModel {
  
  // MARK: - Properties
  
  private let APIService = APIManager.shared
  private let disposeBag = DisposeBag()
  
  let amount = BehaviorRelay<String>(value: "")
  let isSuccess = PublishSubject<Bool>()
  let isLoading = BehaviorRelay<Bool>(value: false)
  let errorMessage = PublishSubject<String?>()
  let responseGenerateQR = PublishSubject<GenerateQRResponse?>()
  var previousAmount: Int?
  
  // MARK: - Initializer
  
  init() {}
  
  // MARK: - Methods
  
  func generateQR(param: GenerateQRParam) {
    isLoading.accept(true)
    APIService.fetchRequest(endpoint: .generateQR(param: param), expecting: GenerateQRResponse.self) { [weak self] result in
      guard let self = self else { return }
      isLoading.accept(false)
      switch result {
      case .success(let response):
        responseGenerateQR.onNext(response)
      case .failure(let error):
        errorMessage.onNext(error.localizedDescription)
      }
    }
  }
}
