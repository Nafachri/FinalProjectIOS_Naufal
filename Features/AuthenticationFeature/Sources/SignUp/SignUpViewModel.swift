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
  
  // MARK: - Properties
  private let APIService = APIManager.shared
  private let keychain = KeychainSwift()
  
  let username = BehaviorRelay<String>(value: "")
  let fullName = BehaviorRelay<String>(value: "")
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
  
  let arePasswordsMatching: Observable<Bool>
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializer
  init() {
    arePasswordsMatching = Observable.combineLatest(password, confirmPassword)
      .map { $0 == $1 }
      .distinctUntilChanged()
    
    setupSignupBinding()
  }
  
  // MARK: - Setup Bindings
  func setupSignupBinding() {
    signUp.subscribe { [weak self] _ in
      guard let self = self else { return }
      let username = self.username.value
      let fullName = self.fullName.value
      let email = self.email.value
      let phoneNumber = self.phoneNumber.value
      let password = self.password.value
      let confirmPassword = self.confirmPassword.value
      let signupParam = RegisterParam(username: username, fullName: fullName, email: email, phoneNumber: phoneNumber, password: password)
      
      // Validate input fields
      guard !username.isEmpty, !fullName.isEmpty, !email.isEmpty, !phoneNumber.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
        self.errorMessage.onNext("All fields must be filled.")
        return
      }
      
      // Validate password matching
      guard password == confirmPassword else {
        self.errorMessage.onNext("Passwords do not match.")
        return
      }
      
      self.isLoading.accept(true)
      APIService.fetchRequest(endpoint: .register(param: signupParam), expecting: GlobalMessageResponse.self) { [weak self] result in
        guard let self = self else { return }
        self.isLoading.accept(false)
        switch result {
        case .success(_):
          self.isSuccess.onNext(true)
        case .failure(let error):
          self.errorMessage.onNext(error.localizedDescription)
        }
      }
    }
    .disposed(by: disposeBag)
  }
}
