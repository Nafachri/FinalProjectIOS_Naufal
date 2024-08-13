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
import Foundation

class SignInViewModel {
  private let authentication: AuthenticationServiceable
  
  let email = BehaviorRelay<String>(value: "")
  let password = BehaviorRelay<String>(value: "")
  let signIn = PublishSubject<Void>()
  
  
  var emailError: Driver<String?>!
  var passwordError: Driver<String?>!
  var disableSignInButton: Driver<Bool>!
  
  
  let isLoading = BehaviorRelay<Bool>(value: false)
  let errorMessage = PublishSubject<String>()
  let isSuccess = PublishSubject<Bool>()
  
  private let disposeBag = DisposeBag()
  
  init(authentication: AuthenticationServiceable) {
    self.authentication = authentication
    setupSigninBinding()
  }
  
  func setupSigninBinding() {
    
    
    signIn.subscribe { [weak self] _ in
      guard let self = self else { return }
//      isLoading.accept(true)
//      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//        self.isLoading.accept(false)
//        self.isSuccess.onNext(true)
//      }
      let email = email.value
      let password = password.value
      guard !email.isEmpty,
            !password.isEmpty else {
        errorMessage.onNext("username and password cannot be emptied.")
        return
      }
      
      self.isLoading.accept(true)
      authentication.signIn(email: email, password: password) { [weak self] result in
        guard let self else {return}
        isLoading.accept(false)
        switch result {
        case .success(_):
          isSuccess.onNext(true)
        case .failure(let error):
          errorMessage.onNext(error.localizedDescription)
        }
      }
    }
    .disposed(by: disposeBag)
    
  }
}
