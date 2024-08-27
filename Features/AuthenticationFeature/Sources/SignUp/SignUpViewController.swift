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
  
  // MARK: - Properties
  
  var disposeBag = DisposeBag()
  weak var coordinator: SignInCoordinator!
  
  // MARK: UI Elements
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var phoneNumberTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var confirmPasswordTextField: UITextField!
  @IBOutlet weak var fullnameTextField: UITextField!
  @IBOutlet weak var signUpButton: UIButton!
  
  var viewModel = SignUpViewModel()
  let alertController = UIAlertController(title: "Sign Up", message: "Sign up..", preferredStyle: .alert)
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupBinding()
    setupNavigationBar()
  }
  
  // MARK: - UI Setup
  private func setupUI() {
    let _ = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
    
    usernameTextField.setPlaceholder(text: "enter username", color: .lightGray)
    fullnameTextField.setPlaceholder(text: "enter fullname", color: .lightGray)
    emailTextField.setPlaceholder(text: "enter email", color: .lightGray)
    phoneNumberTextField.setPlaceholder(text: "enter phone number", color: .lightGray)
    passwordTextField.setPlaceholder(text: "enter password", color: .lightGray)
    confirmPasswordTextField.setPlaceholder(text: "enter confirm password", color: .lightGray)
    
    signUpButton.layer.cornerRadius = 10
  }
  
  // MARK: - Navigation Bar
  private func setupNavigationBar() {
    self.navigationController?.navigationBar.tintColor = .label
  }
  
  // MARK: - Binding
  func setupBinding() {
    viewModel.isLoading
      .subscribe { [weak self] isLoading in
        guard let self = self else { return }
        self.showLoading(isLoading: isLoading)
      }
      .disposed(by: disposeBag)
    
    usernameTextField.rx.text.orEmpty
      .bind(to: viewModel.username)
      .disposed(by: disposeBag)
    
    fullnameTextField.rx.text.orEmpty
      .bind(to: viewModel.fullName)
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
    
    signUpButton.rx.tap
      .bind { [weak self] in
        guard let self = self else { return }
        let password = self.viewModel.password.value
        let confirmPassword = self.viewModel.confirmPassword.value
        
        if password != confirmPassword {
          self.showAlert(title: "Error", message: "Passwords do not match.")
        } else {
          self.viewModel.signUp.onNext(())
        }
      }
      .disposed(by: disposeBag)
    
    viewModel.errorMessage
      .subscribe(onNext: { [weak self] errorMessage in
        guard let self = self, let errorMessage = errorMessage else { return }
        self.showAlert(title: "Error", message: errorMessage)
      })
      .disposed(by: disposeBag)
    
    viewModel.isSuccess
      .subscribe(onNext: { [weak self] value in
        guard let self = self, value else { return }
        self.navigationController?.popToRootViewController(animated: true)
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - Helper Methods
  func showLoading(isLoading: Bool) {
    if isLoading {
      present(alertController, animated: true)
    } else {
      alertController.dismiss(animated: true)
    }
  }
  
  private func showAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }
}

private extension UITextField {
  func setPlaceholder(text: String, color: UIColor) {
    let attributes = [NSAttributedString.Key.foregroundColor: color]
    self.attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)
  }
}
