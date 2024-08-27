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

enum LoadingState: String {
  case loading
  case finished
  case failed
}

class ContactsViewModel {
  
  // MARK: - Properties
  private let apiService = APIManager.shared
  private let keychain = KeychainSwift()
  
  let listOfContact = BehaviorRelay<ListContactResponse>(value: [])
  let isLoading = BehaviorRelay<LoadingState>(value: .loading)
  let errorMessage = PublishSubject<String?>()
  let isSuccess = PublishSubject<Bool>()
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initialization
  init() {}
  
  // MARK: - Public Methods
    func fetchContacts() {
      isLoading.accept(.loading)
        apiService.fetchRequest(endpoint: .listContact, expecting: ListContactResponse.self) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
              self.isLoading.accept(.finished)
                self.listOfContact.accept(response)
                self.isSuccess.onNext(true)
            case .failure(let error):
              self.isLoading.accept(.failed)
                self.errorMessage.onNext(error.localizedDescription)
                self.isSuccess.onNext(false)
            }
        }
    }
}
