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
  var disposeBag = DisposeBag()
  
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var signinButton: UIButton!
  @IBOutlet weak var forgotPasswordButton: UIButton!
  @IBOutlet weak var signUpButton: UIButton!
  weak var coordinator: SignInCoordinator!
  
  var viewModel: SignInViewModel
  
  let alertController = UIAlertController(title: "Signing", message: "Signin in..", preferredStyle: .alert)
  let alertErrorController = UIAlertController(title: "Failed", message: "Signin in failed..", preferredStyle: .alert)
  
  init(coordinator: SignInCoordinator!, viewModel: SignInViewModel = SignInViewModel()) {
    self.coordinator = coordinator
    self.viewModel = viewModel
    super.init(nibName: "SignInViewController", bundle: .module)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupBinding()
  }
  
  private func setupUI(){
    let emailPlaceholder = "enter email"
    let passwordPlaceholder = "enter password"
    let attributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
    
    // Email/Username TextField
    emailField.attributedPlaceholder = NSAttributedString(string: emailPlaceholder, attributes: attributes)
    // Password TextField
    passwordField.attributedPlaceholder = NSAttributedString(string: passwordPlaceholder, attributes: attributes)
    // Sign In Button
    signinButton.layer.cornerRadius = 10
    let okButton = UIAlertAction(title: "Dismiss", style: .cancel) { [weak self] _ in
      guard let self else { return }
      alertErrorController.dismiss(animated: true)
    }
    alertErrorController.addAction(okButton)
  }
  
  func setupBinding(){
    // receive update when isLoading changed
    viewModel.isLoading
      .subscribe{ [weak self] isLoading in
        DispatchQueue.main.asyncAfter(deadline: .now()){
          self?.showLoading(isLoading: isLoading)
        }
      }
      .disposed(by: disposeBag)
    
    // email textfield
    emailField.rx.text.orEmpty
      .bind(to: viewModel.email)
      .disposed(by: disposeBag)
    
    passwordField.rx.text.orEmpty
      .bind(to: viewModel.password)
      .disposed(by: disposeBag)
    
    // send action when button tapped
    signinButton.rx
      .tap
      .bind(to: viewModel.signIn)
      .disposed(by: disposeBag)
    
    // setup error binding
    viewModel.errorMessage
      .subscribe(onNext: { [weak self] errorMessage in
        guard let self else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
          self.showError(errorMessage)
        }
      })
      .disposed(by: disposeBag)
    
    // setup isSuccess
    viewModel.isSuccess
      .subscribe(onNext: { [weak self] value in
        guard let self, value else { return }
        coordinator.goToDashboard()
      })
      .disposed(by: disposeBag)
  }
  
  func showLoading(isLoading: Bool) {
    if isLoading  {
      present(alertController, animated: true)
    } else {
      alertController.dismiss(animated: true)
    }
  }
  
  func showError(_ message: String) {
    alertErrorController.message = message
    present(alertErrorController, animated: true)
  }
  
  @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
    let changePasswordVC = ChangePasswordViewController(nibName: "ChangePasswordViewController", bundle: .module)
    show(changePasswordVC, sender: self)
  }
  @IBAction func signupButtonTapped(_ sender: UIButton) {
    let signupVC = SignUpViewController(nibName: "SignUpViewController", bundle: .module)
    show(signupVC, sender: self)
  }
  @IBAction func signInButtonTapped(_ sender: UIButton) {
//    coordinator.goToDashboard()
  }
}

private extension UITextField {
  func setPlaceholder(text: String, color: UIColor) {
    let attributes = [NSAttributedString.Key.foregroundColor: color]
    self.attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)
  }
}
