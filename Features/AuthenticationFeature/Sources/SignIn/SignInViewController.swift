//
//  SignInViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 01/08/24.
//

import UIKit
import Services
import RxSwift
import RxRelay

class SignInViewController: UIViewController {
  var disposeBag = DisposeBag()
  
  @IBOutlet weak var usernameField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var signinButton: UIButton!
  @IBOutlet weak var forgotPasswordButton: UIButton!
  @IBOutlet weak var signUpButton: UIButton!
  weak var coordinator: SignInCoordinator!
  
  var viewModel: SignInViewModel
  
  let alertController = UIAlertController(title: "Signing", message: "Signin in..", preferredStyle: .alert)
  
  init(coordinator: SignInCoordinator!, viewModel: SignInViewModel = SignInViewModel(authentication: AuthenticationService())) {
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
    let usernamePlaceholder = "enter email or username"
    let passwordPlaceholder = "enter password"
    let attributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
    
    // Email/Username TextField
    usernameField.attributedPlaceholder = NSAttributedString(string: usernamePlaceholder, attributes: attributes)
    // Password TextField
    passwordField.attributedPlaceholder = NSAttributedString(string: passwordPlaceholder, attributes: attributes)
    // Sign In Button
    signinButton.layer.cornerRadius = 10
    
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
    
    // email or username textfield
    usernameField.rx.text.orEmpty
      .bind(to: viewModel.username)
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
      .subscribe(onNext: { errorMessage in
        print("error: \(String(describing: errorMessage))")
      })
      .disposed(by: disposeBag)
    
    // setup isSuccess
    viewModel.isSuccess
      .subscribe(onNext: { value in
        print(value)
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
  
  @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
    let changePasswordVC = ChangePasswordViewController(nibName: "ChangePasswordViewController", bundle: .module)
    show(changePasswordVC, sender: self)
  }
  @IBAction func signupButtonTapped(_ sender: UIButton) {
    let signupVC = SignUpViewController(nibName: "SignUpViewController", bundle: .module)
    show(signupVC, sender: self)
  }
}

private extension UITextField {
  func setPlaceholder(text: String, color: UIColor) {
    let attributes = [NSAttributedString.Key.foregroundColor: color]
    self.attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)
  }
}
