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
  private let APIService = APIManager.shared
  private let keychain = KeychainSwift()
  
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
  
  init() {
    setupSigninBinding()
  }
  
  func setupSigninBinding() {
    signIn.subscribe { [weak self] _ in
      guard let self = self else { return }
      let email = email.value
      let password = password.value
      let loginParam = LoginParam(email: email, password: password)
      guard !email.isEmpty,
            !password.isEmpty else {
        errorMessage.onNext("username and password cannot be emptied.")
        return
      }
      
      self.isLoading.accept(true)
      APIService.fetchRequest(endpoint: .login(param: loginParam), expecting: LoginResponse.self) {
        [weak self] result in
        guard let self else {return}
        isLoading.accept(false)
        switch result {
        case .success(let response):
          keychain.set(response.token, forKey: "userToken")
          print(response)
          isSuccess.onNext(true)
//          APIService.fetchRequest(endpoint: .profile, expecting: ProfileResponse.self){
//            [weak self] result in guard let self else {return}
//            switch result {
//            case .success(_):
//              keychain.set(response.token, forKey: "userToken")
//              print(response)
//              isSuccess.onNext(true)
//            case .failure(let error):
//              errorMessage.onNext(error.localizedDescription)
//            }
//          }
        case .failure(let error):
          errorMessage.onNext(error.localizedDescription)
        }
      }
    }
    .disposed(by: disposeBag)
    
  }
}
