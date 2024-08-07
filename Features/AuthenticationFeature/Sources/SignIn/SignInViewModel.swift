//
//  SignInViewModel.swift
//  AuthenticationFeature
//
//  Created by Naufal Al-Fachri on 03/08/24.
//

import RxSwift
import RxRelay
import RxCocoa
import Services

class SignInViewModel {
  private let authentication: AuthenticationServiceable
  
  let username = BehaviorRelay<String>(value: "")
  let password = BehaviorRelay<String>(value: "")
  let signIn = PublishSubject<Void>()
  
  
  var usernameError: Driver<String?>!
  var passwordError: Driver<String?>!
  var disableSignInButton: Driver<Bool>!
  
  
    let isLoading = BehaviorRelay<Bool>(value: false)
    let errorMessage = BehaviorRelay<String?>(value: nil)
    let isSuccess = BehaviorRelay<Bool>(value: false)
  
  private let disposeBag = DisposeBag()
  
  init(authentication: AuthenticationServiceable) {
    self.authentication = authentication
    setupSigninBinding()
  }
  
  func setupSigninBinding() {
    signIn.subscribe { [weak self] _ in
      guard let self = self else { return }
      let username = username.value
      let password = password.value
      guard !username.isEmpty,
            !password.isEmpty else {
        errorMessage.accept("username and password cannot be emptied.")
        return
      }

      self.isLoading.accept(true)
      authentication.signIn(username: username, password: password) { result in
        self.isLoading.accept(false)
        switch result {
        case .success(let value):
          print(value.message)
        case .failure(let error):
          print(error.localizedDescription)
        }
      }
    }
    .disposed(by: disposeBag)
    
  }}
