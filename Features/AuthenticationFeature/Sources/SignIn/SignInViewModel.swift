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
  
  let email = BehaviorRelay<String>(value: "")
  let password = BehaviorRelay<String>(value: "")
  let signIn = PublishSubject<Void>()
  
  
  var emailError: Driver<String?>!
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
      let email = email.value
      let password = password.value
      guard !email.isEmpty,
            !password.isEmpty else {
        errorMessage.accept("username and password cannot be emptied.")
        return
      }

      self.isLoading.accept(true)
      authentication.signIn(email: email, password: password) { result in
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
