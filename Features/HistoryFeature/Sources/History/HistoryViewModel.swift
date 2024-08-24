//
//  HistoryViewModel.swift
//  HistoryFeature
//
//  Created by Naufal Al-Fachri on 22/08/24.
//

import RxSwift
import RxRelay
import RxCocoa
import NetworkManager

class HistoryViewModel {
  private let APIService = APIManager.shared
  private let disposeBag = DisposeBag()

  var historyData = BehaviorRelay<HistoryResponse?>(value: nil)
  
  let isLoading = BehaviorRelay<Bool>(value: false)
  let errorMessage = PublishSubject<String?>()
  let isSuccess = PublishSubject<Bool>()
  
  init() {}
  
  func fetchHistory() {
    isLoading.accept(true)
    APIService.fetchRequest(endpoint: .history, expecting: HistoryResponse.self) { [weak self] result in
      guard let self else { return }
      isLoading.accept(false)
      switch result {
      case .success(let response):
        historyData.accept(response)
      case .failure(let error):
        errorMessage.onNext(error.localizedDescription)
      }
    }
  }
}
