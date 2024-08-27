//
//  ScanQRViewModel.swift
//  Utils
//
//  Created by Naufal Al-Fachri on 26/08/24.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import NetworkManager

class ScanQRViewModel {
  
  // MARK: - Properties
  private let APIService = APIManager.shared
  private let disposeBag = DisposeBag()
  
  let isSuccess = PublishSubject<Bool>()
  let isLoading = BehaviorRelay<Bool>(value: false)
  let errorMessage = PublishSubject<String?>()
  let responsePayScanQR = BehaviorRelay<PayQRResponse?>(value: nil)
  
  // MARK: - Initializer
  init() {}
  
  // MARK: - API Requests
  func payScanQR(param: PayQRParam) {
    isLoading.accept(true)
    APIService.fetchRequest(endpoint: .payQR(param: param), expecting: PayQRResponse.self) { [weak self] result in
      guard let self = self else { return }
      isLoading.accept(false)
      switch result {
      case .success(let response):
        responsePayScanQR.accept(response)
      case .failure(let error):
        errorMessage.onNext(error.localizedDescription)
      }
    }
  }
}
