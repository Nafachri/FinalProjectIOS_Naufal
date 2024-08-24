//
//  HomeViewModel.swift
//  The North
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import RxSwift
import RxRelay
import RxCocoa
import NetworkManager

class HomeViewModel {
  private let APIService = APIManager.shared
  private let disposeBag = DisposeBag()
  
  var fullname = BehaviorRelay<String>(value: "")
  var userBalance = BehaviorRelay<String>(value: "")
  
  let topup = PublishSubject<Void>()
  let isSuccess = PublishSubject<Bool>()
  let isLoading = BehaviorRelay<Bool>(value: false)
  let errorMessage = PublishSubject<String?>()
  
  var profileData = BehaviorRelay<ProfileResponse?>(value: nil)
  var historyData = BehaviorRelay<HistoryResponse?>(value: nil)
  
  
  init(){
//    fetchHistory()
//    fetchProfile()
  }
  
    func fetchProfile() {
      isLoading.accept(true)
      APIService.fetchRequest(endpoint: .profile, expecting: ProfileResponse.self) { [weak self] result in
        guard let self else { return }
        isLoading.accept(false)
        switch result {
        case .success(let response):
          profileData.accept(response)
        case .failure(let error):
          errorMessage.onNext(error.localizedDescription)
        }
      }
    }
  
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
