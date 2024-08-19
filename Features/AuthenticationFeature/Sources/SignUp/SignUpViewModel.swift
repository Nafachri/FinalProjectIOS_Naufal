//
//  SignUpViewModel.swift
//  Services
//
//  Created by Naufal Al-Fachri on 05/08/24.
//

import RxSwift
import RxRelay
import RxCocoa
import Services

class SignUpViewModel {
  private let authentication: AuthenticationServiceable
  
  let username = BehaviorRelay<String>(value: "")
  let email = BehaviorRelay<String>(value: "")
  let phoneNumber = BehaviorRelay<String>(value: "")
  let password = BehaviorRelay<String>(value: "")
  let confirmPassword = BehaviorRelay<String>(value: "")
  let signUp = PublishSubject<Void>()
  
  var usernameError: Driver<String?>!
  var emailError: Driver<String?>!
  var phoneNumberError: Driver<String?>!
  var passwordError: Driver<String?>!
  var confirmPasswordError: Driver<String?>!
  
  let isLoading = BehaviorRelay<Bool>(value: false)
  let errorMessage = BehaviorRelay<String?>(value: nil)
  let isSuccess = BehaviorRelay<Bool>(value: false)
  
  private let disposeBag = DisposeBag()
  
  init(authentication: AuthenticationServiceable) {
    self.authentication = authentication
    setupSignupBinding()
  }
  
  func setupSignupBinding() {
    signUp.subscribe { [weak self] _ in
      guard let self = self else { return }
      let username = username.value
      let email = email.value
      let phoneNumber = phoneNumber.value
      let password = password.value
      let confirmPassword = confirmPassword.value
      guard !username.isEmpty,
            !email.isEmpty,
            !phoneNumber.isEmpty,
            !password.isEmpty,
      !confirmPassword.isEmpty else {
        errorMessage.accept("all fields must be filled.")
        return
      }
      
      self.isLoading.accept(true)
      authentication.signUp(username: username, email: email, phoneNumber: phoneNumber, password: password, confirmPassword: confirmPassword) { result in
        self.isLoading.accept(false)
        switch result {
        case .success(let value):
          print(value.data)
        case .failure(let error):
          print(error.localizedDescription)
        }
      }
    }
    .disposed(by: disposeBag)
  }
}
