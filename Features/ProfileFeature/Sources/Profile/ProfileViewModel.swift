//
//  ProfileViewModel.swift
//  ProfileFeature
//
//  Created by Naufal Al-Fachri on 05/08/24.
//

import RxSwift
import RxRelay
import RxCocoa
import Services

class ProfileViewModel {
  private let profile: ProfileServiceable
  
  let username = BehaviorRelay<String>(value: "")
  let email = BehaviorRelay<String>(value: "")
  let phoneNumber = BehaviorRelay<String>(value: "")
  let confirmEdit = PublishSubject<Void>()
  
  var usernameError: Driver<String?>!
  var emailError: Driver<String?>!
  var phoneNumberError: Driver<String?>!
  var showConfirmButton: Driver<Bool>!
  
  private let disposeBag = DisposeBag()
  
  init(profile: ProfileServiceable){
    self.profile = profile
  }
  
  func setupProfileBinding() {
    usernameError = username
      .map { (username: String) -> String? in
        username.isEmpty ? "Username cannot be emptied" : nil
      }
      .asDriver(onErrorJustReturn: nil)
    
    emailError = email
      .map { (email: String) -> String? in
        email.isEmpty ? "Email cannot be emptied" : nil
      }
      .asDriver(onErrorJustReturn: nil)
    
    phoneNumberError = phoneNumber
      .map { (phoneNumber: String) -> String? in
        phoneNumber.isEmpty ? "Phone Number cannot be emptied" : nil
      }
      .asDriver(onErrorJustReturn: nil)
//    confirmEdit.subscribe { [weak self] _ in
//      guard let self = self else { return }
////      let username = username.value
////      let email = email.value
////      let phoneNumber = phoneNumber.value
//      usernameError =
////      guard !username.isEmpty ||
////            !email.isEmpty ||
////            !phoneNumber.isEmpty else {
////        emailError.
////              return
////      }
//    }
    
//    confirmEdit
      
      
      
    
  }
}

