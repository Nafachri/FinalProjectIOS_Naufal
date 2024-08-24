//
//  SignUpViewModel.swift
//  Services
//
//  Created by Naufal Al-Fachri on 05/08/24.
//

import RxSwift
import RxRelay
import RxCocoa
import NetworkManager
import KeychainSwift

class SignUpViewModel {
  private let APIService = APIManager.shared
  private let keychain = KeychainSwift()
  
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
  let errorMessage = PublishSubject<String?>()
  let isSuccess = PublishSubject<Bool>()
  
  private let disposeBag = DisposeBag()
  
  init() {
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
      let signupParam = RegisterParam(username: username, email: email, phoneNumber: phoneNumber, password: password)
      
      guard !username.isEmpty,
            !email.isEmpty,
            !phoneNumber.isEmpty,
            !password.isEmpty,
            !confirmPassword.isEmpty else {
          errorMessage.onNext("All fields must be filled.")
          return
      }
      guard password == confirmPassword else {
          errorMessage.onNext("Passwords do not match.")
          return
      }
      
      self.isLoading.accept(true)
      APIService.fetchRequest(endpoint: .register(param: signupParam), expecting: GlobalMessageResponse.self) {
          [weak self] result in
        guard let self else { return }
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
