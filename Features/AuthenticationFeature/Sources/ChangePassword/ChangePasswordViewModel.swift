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
    
    func setupChangePasswordBinding(){
        confirmButton
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                let email = email.value
                let newPassword = newPassword.value
                let confirmPassword = confirmPassword.value
                let changePasswordParam = ChangePasswordParam(email: email, newPassword: newPassword, confirmPassword: confirmPassword)
                
                guard !email.isEmpty, !newPassword.isEmpty, !confirmPassword.isEmpty else {
                    errorMessage.onNext("all fields must be filled.")
                    return
                }
                
                guard newPassword == confirmPassword else {
                    errorMessage.onNext("Passwords do not match.")
                    return
                }
                
                self.isLoading.accept(true)
                
                APIService.fetchRequest(endpoint: .changePassword(param: changePasswordParam), expecting: GlobalMessageResponse.self) { [weak self] result in
                    guard let self else { return }
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
