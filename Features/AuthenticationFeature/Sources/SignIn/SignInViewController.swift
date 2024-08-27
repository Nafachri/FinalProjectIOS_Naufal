//
//  SignInViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 01/08/24.
//

import UIKit
import RxSwift
import RxRelay

class SignInViewController: UIViewController {
  
  // MARK: - Properties
  
  var disposeBag = DisposeBag()
  
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var signinButton: UIButton!
  @IBOutlet weak var forgotPasswordButton: UIButton!
  @IBOutlet weak var signUpButton: UIButton!
  
  weak var coordinator: SignInCoordinator!
  var viewModel: SignInViewModel
  
  let alertController = UIAlertController(title: "Signing", message: "Signing in..", preferredStyle: .alert)
  let alertErrorController = UIAlertController(title: "Failed", message: "Sign in failed..", preferredStyle: .alert)
  
  // MARK: - Initializers
  
  init(coordinator: SignInCoordinator!, viewModel: SignInViewModel = SignInViewModel()) {
    self.coordinator = coordinator
    self.viewModel = viewModel
    super.init(nibName: "SignInViewController", bundle: .module)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupBinding()
  }
  
  // MARK: - UI Setup
  
  private func setupUI() {
    let emailPlaceholder = "Enter email"
    let passwordPlaceholder = "Enter password"
    let attributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
    
    emailField.attributedPlaceholder = NSAttributedString(string: emailPlaceholder, attributes: attributes)
    passwordField.attributedPlaceholder = NSAttributedString(string: passwordPlaceholder, attributes: attributes)
    
    signinButton.layer.cornerRadius = 10
    
    let okButton = UIAlertAction(title: "Dismiss", style: .cancel) { [weak self] _ in
      guard let self else { return }
      alertErrorController.dismiss(animated: true)
    }
    
    alertErrorController.addAction(okButton)
  }
  
  // MARK: - Binding Setup
  
  func setupBinding() {
    // Observe isLoading
    viewModel.isLoading
      .subscribe(onNext: { [weak self] isLoading in
        DispatchQueue.main.async {
          self?.showLoading(isLoading: isLoading)
        }
      })
      .disposed(by: disposeBag)
    
    // Bind email and password fields
    emailField.rx.text.orEmpty
      .bind(to: viewModel.email)
      .disposed(by: disposeBag)
    
    passwordField.rx.text.orEmpty
      .bind(to: viewModel.password)
      .disposed(by: disposeBag)
    
    // Bind signinButton tap action
    signinButton.rx.tap
      .bind(to: viewModel.signIn)
      .disposed(by: disposeBag)
    
    // Observe error messages
    viewModel.errorMessage
      .subscribe(onNext: { [weak self] errorMessage in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
          self?.showError(errorMessage)
        }
      })
      .disposed(by: disposeBag)
    
    // Observe success state
    viewModel.isSuccess
      .subscribe(onNext: { [weak self] value in
        guard let self, value else { return }
        coordinator.goToDashboard()
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
  
  func showError(_ message: String) {
    alertErrorController.message = message
    present(alertErrorController, animated: true)
  }
  
  // MARK: - Actions
  
  @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
    let changePasswordVC = ChangePasswordViewController(nibName: "ChangePasswordViewController", bundle: .module)
    show(changePasswordVC, sender: self)
  }
  
  @IBAction func signupButtonTapped(_ sender: UIButton) {
    let signupVC = SignUpViewController(nibName: "SignUpViewController", bundle: .module)
    show(signupVC, sender: self)
  }
  
  @IBAction func signInButtonTapped(_ sender: UIButton) {
    // coordinator.goToDashboard() // Commented out for now
  }
}

// MARK: - UITextField Extension

private extension UITextField {
  func setPlaceholder(text: String, color: UIColor) {
    let attributes = [NSAttributedString.Key.foregroundColor: color]
    self.attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)
  }
}
