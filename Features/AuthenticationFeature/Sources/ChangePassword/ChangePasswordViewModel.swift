//
//  ChangePasswordViewModel.swift
//  AuthenticationFeature
//
//  Created by Naufal Al-Fachri on 04/08/24.
//

import RxSwift
import RxRelay
import RxCocoa
import NetworkManager

class ChangePasswordViewModel {
  
  // MARK: - Properties
  
  private let APIService = APIManager.shared
  
  let email = BehaviorRelay<String>(value: "")
  let newPassword = BehaviorRelay<String>(value: "")
  let confirmPassword = BehaviorRelay<String>(value: "")
  let confirmButton = PublishSubject<Void>()
  
  var emailError: Driver<String?>!
  var newPasswordError: Driver<String?>!
  var confirmPasswordError: Driver<String?>!
  var disableConfirmButton: Driver<Bool>!
  
  let isLoading = BehaviorRelay<Bool>(value: false)
  let errorMessage = PublishSubject<String>()
  let isSuccess = PublishSubject<Bool>()
  
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializer
  
  init() {
    setupChangePasswordBinding()
  }
  
  // MARK: - Setup Binding
  
  func setupChangePasswordBinding() {
    confirmButton
      .subscribe(onNext: { [weak self] in
        guard let self = self else { return }
        let email = self.email.value
        let newPassword = self.newPassword.value
        let confirmPassword = self.confirmPassword.value
        
        guard !email.isEmpty, !newPassword.isEmpty, !confirmPassword.isEmpty else {
          self.errorMessage.onNext("All fields must be filled.")
          return
        }
        
        guard newPassword == confirmPassword else {
          self.errorMessage.onNext("Password and Confirm Password do not match.")
          return
        }
        
        let forgotPasswordParam = ForgotPasswordParam(email: email, password: newPassword)
        self.isLoading.accept(true)
        
        self.APIService.fetchRequest(endpoint: .forgotPassword(param: forgotPasswordParam), expecting: GlobalMessageResponse.self) { [weak self] result in
          guard let self = self else { return }
          self.isLoading.accept(false)
          
          switch result {
          case .success(_):
            self.isSuccess.onNext(true)
          case .failure(let error):
            self.errorMessage.onNext(error.localizedDescription)
          }
        }
      })
      .disposed(by: disposeBag)
  }
}
