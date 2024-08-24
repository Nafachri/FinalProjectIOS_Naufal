//
//  ChangePasswordViewModel.swift
//  AuthenticationFeature
//
//  Created by Naufal Al-Fachri on 04/08/24.
//

import RxSwift
import RxRelay
import RxCocoa

class ChangePasswordViewModel {
  let email = BehaviorRelay<String>(value: "")
  let phoneNumber = BehaviorRelay<String>(value: "")
  let password = BehaviorRelay<String>(value: "")
  let confirmPassword = BehaviorRelay<String>(value: "")
  let confirmButton = PublishSubject<Void>()
  
  var emailError: Driver<String?>!
  var phoneNumberError: Driver<String?>!
  var passwordError: Driver<String?>!
  var confirmPasswordError: Driver<String?>!
  var disableConfirmButton: Driver<Bool>!
  
  let isLoading = BehaviorRelay<Bool>(value: false)
  let errorMessage = BehaviorRelay<String?>(value: nil)
  let isSuccess = BehaviorRelay<Bool>(value: false)
  
  private let disposeBag = DisposeBag()
  
  init() {
    setupChangePasswordBinding()
  }
  
  func setupChangePasswordBinding(){
    confirmButton.subscribe{ [weak self] _ in
      guard let self = self else { return }
      let email = email.value
      let phoneNumber = phoneNumber.value
      let password = password.value
      let confirmPassword = confirmPassword.value
      guard !email.isEmpty,
            !phoneNumber.isEmpty,
            !password.isEmpty,
            !confirmPassword.isEmpty else {
        errorMessage.accept("all fields must be filled.")
        return
      }
      self.isLoading.accept(true)
//      authentication.changePassword(email: email, phoneNumber: phoneNumber, password: password, confirmPassword: confirmPassword){result in
//      self.isLoading.accept(false)
//
//        switch result {
//        case .success(let value):
//          print(value.data!)
//        case .failure(let error):
//          print(error.localizedDescription)
//        }
//      }
    }
    .disposed(by: disposeBag)
  }
}
