//
//  ContactsViewModel.swift
//  ContactsFeature
//
//  Created by Naufal Al-Fachri on 22/08/24.
//

import RxSwift
import RxRelay
import RxCocoa
import NetworkManager
import KeychainSwift

class ContactsViewModel {
  private let APIService = APIManager.shared
  private let keychain = KeychainSwift()
  
  var listOfContact = BehaviorRelay<ListContactResponse>(value: [])
  let isLoading = BehaviorRelay<Bool>(value: false)
  let errorMessage = PublishSubject<String?>()
  let isSuccess = PublishSubject<Bool>()
  
  private let disposeBag = DisposeBag()
  
  init() {}
  
  func fetchContact() {
    APIService.fetchRequest(endpoint: .listContact, expecting: ListContactResponse.self) { [weak self] result in
      guard let self else { return }
      isLoading.accept(false)
      switch result {
      case .success(let response):
        listOfContact.accept(response)
      case .failure(let error):
        errorMessage.onNext(error.localizedDescription)
      }
    }
  }
  
}
