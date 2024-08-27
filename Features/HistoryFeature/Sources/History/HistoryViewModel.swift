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

// MARK: - Enums

enum LoadingState: String {
  case loading
  case finished
  case failed
}

// MARK: - HistoryViewModel

class HistoryViewModel {
  
  // MARK: - Properties

  private let APIService = APIManager.shared
  private let disposeBag = DisposeBag()

  var historyData = BehaviorRelay<HistoryResponse?>(value: nil)
  
  let isLoading = BehaviorRelay<LoadingState>(value: .loading)
  let errorMessage = PublishSubject<String?>()
  let isSuccess = PublishSubject<Bool>()
  
  // MARK: - Initializer
  
  init() {}
  
  // MARK: - Methods
  
  func fetchHistory() {
    isLoading.accept(.loading)
    APIService.fetchRequest(endpoint: .history, expecting: HistoryResponse.self) { [weak self] result in
      guard let self = self else { return }
      self.isLoading.accept(.finished)
      switch result {
      case .success(let response):
        self.historyData.accept(response)
      case .failure(let error):
        self.errorMessage.onNext(error.localizedDescription)
      }
    }
  }
}
