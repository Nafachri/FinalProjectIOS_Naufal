//
//  SignUpViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 01/08/24.
//

import UIKit
import RxSwift
import RxRelay

class SignUpViewController: UIViewController {
  
  var disposeBag = DisposeBag()
  
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var phoneNumberTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var confirmPasswordTextField: UITextField!
  @IBOutlet weak var signUpButton: UIButton!
  weak var coordinator: SignInCoordinator!
  
  var viewModel = SignUpViewModel()
  
  let alertController = UIAlertController(title: "Sign Up", message: "Sign up..", preferredStyle: .alert)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupBinding()
  }
  
  private func setupUI(){
    let usernamePlaceholder = "enter username"
    let emailPlaceholder = "enter email"
    let phoneNumberPlaceholder = "enter phone number"
    let passwordPlaceholder = "enter password"
    let confirmPasswordPlaceholder = "enter confirm password"
    let attributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
    
    usernameTextField.attributedPlaceholder = NSAttributedString(string: usernamePlaceholder, attributes: attributes)
    emailTextField.attributedPlaceholder = NSAttributedString(string: emailPlaceholder, attributes: attributes)
    phoneNumberTextField.attributedPlaceholder = NSAttributedString(string: phoneNumberPlaceholder, attributes: attributes)
    passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordPlaceholder, attributes: attributes)
    confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: confirmPasswordPlaceholder, attributes: attributes)
    signUpButton.layer.cornerRadius = 10
  }
  
  func setupBinding(){
    viewModel.isLoading
      .subscribe{ [weak self] isLoading in
        guard let self else {return}
        self.showLoading(isLoading: isLoading)
      }
      .disposed(by: disposeBag)
    
    usernameTextField.rx.text.orEmpty
      .bind(to: viewModel.username)
      .disposed(by: disposeBag)
    
    emailTextField.rx.text.orEmpty
      .bind(to: viewModel.email)
      .disposed(by: disposeBag)
    
    phoneNumberTextField.rx.text.orEmpty
      .bind(to: viewModel.phoneNumber)
      .disposed(by: disposeBag)
    
    passwordTextField.rx.text.orEmpty
      .bind(to: viewModel.password)
      .disposed(by: disposeBag)
    
    confirmPasswordTextField.rx.text.orEmpty
      .bind(to: viewModel.confirmPassword)
      .disposed(by: disposeBag)
    
    signUpButton.rx
      .tap
      .bind(to: viewModel.signUp)
      .disposed(by: disposeBag)
    
    viewModel.errorMessage
      .subscribe(onNext: { errorMessage in
        print("error: \(String(describing: errorMessage))")
      })
      .disposed(by: disposeBag)
    
    viewModel.isSuccess
      .subscribe(onNext: { [weak self] value in
        guard let self, value else { return }
        self.navigationController?.popToRootViewController(animated: true)
      })
      .disposed(by: disposeBag)
    
  }
  
  func showLoading(isLoading: Bool) {
    if isLoading {
      present(alertController, animated: true)
    } else {
      alertController.dismiss(animated: true)
    }
  }
  
}
private extension UITextField {
  func setPlaceholder(text: String, color: UIColor) {
    let attributes = [NSAttributedString.Key.foregroundColor: color]
    self.attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)
  }
}
