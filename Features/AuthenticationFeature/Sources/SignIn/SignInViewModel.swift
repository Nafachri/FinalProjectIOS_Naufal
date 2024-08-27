//
//  SignInViewModel.swift
//  AuthenticationFeature
//
//  Created by Naufal Al-Fachri on 03/08/24.
//

import RxSwift
import RxRelay
import RxCocoa
import Foundation
import NetworkManager
import KeychainSwift

class SignInViewModel {
  
  // MARK: - Properties
  
  private let APIService = APIManager.shared
  private let keychain = KeychainSwift()
  private let disposeBag = DisposeBag()
  
  // Input
  let email = BehaviorRelay<String>(value: "")
  let password = BehaviorRelay<String>(value: "")
  let signIn = PublishSubject<Void>()
  
  // Output
  var emailError: Driver<String?>!
  var passwordError: Driver<String?>!
  var disableSignInButton: Driver<Bool>!
  
  // State
  let isLoading = BehaviorRelay<Bool>(value: false)
  let errorMessage = PublishSubject<String>()
  let isSuccess = PublishSubject<Bool>()
  
  // MARK: - Initializer
  
  init() {
    setupSigninBinding()
  }
  
  // MARK: - Binding Setup
  
  func setupSigninBinding() {
    signIn
      .subscribe { [weak self] _ in
        guard let self = self else { return }
        
        let email = email.value
        let password = password.value
        let loginParam = LoginParam(email: email, password: password)
        
        guard !email.isEmpty, !password.isEmpty else {
          errorMessage.onNext("Username and password cannot be emptied.")
          return
        }
        
        self.isLoading.accept(true)
        
        APIService.fetchRequest(endpoint: .login(param: loginParam), expecting: LoginResponse.self) { [weak self] result in
          guard let self = self else { return }
          self.isLoading.accept(false)
          
          switch result {
          case .success(let response):
            self.keychain.set(response.token, forKey: "userToken")
            self.isSuccess.onNext(true)
          case .failure(let error):
            self.errorMessage.onNext(error.localizedDescription)
          }
        }
      }
      .disposed(by: disposeBag)
  }
}
