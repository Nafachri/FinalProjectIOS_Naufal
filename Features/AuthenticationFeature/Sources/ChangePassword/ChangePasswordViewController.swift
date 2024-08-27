//
//  ChangePasswordViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 02/08/24.
//

import UIKit
import RxSwift
import RxRelay

class ChangePasswordViewController: UIViewController {
  
  // MARK: - Properties
  
  var disposeBag = DisposeBag()
  var viewModel: ChangePasswordViewModel = ChangePasswordViewModel()
  let alertController = UIAlertController(title: "Change Password", message: "Please wait..", preferredStyle: .alert)
  
  // MARK: - IBOutlets
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var confirmPasswordTextField: UITextField!
  @IBOutlet weak var confirmButton: UIButton!
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupBinding()
    setupNavigationBar()
  }
  
  // MARK: - Setup Methods
  
  private func setupUI() {
    let attributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
    
    // Email TextField
    emailTextField.attributedPlaceholder = NSAttributedString(string: "enter email", attributes: attributes)
    // Password TextField
    passwordTextField.attributedPlaceholder = NSAttributedString(string: "enter password", attributes: attributes)
    // Confirm Password TextField
    confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string: "enter confirm password", attributes: attributes)
    // Confirm Button
    confirmButton.layer.cornerRadius = 10
  }
  
  // MARK: - Setup Navigation Bar Button Color
  private func setupNavigationBar() {
    // Set the back button color to .label
    self.navigationController?.navigationBar.tintColor = .label
  }
  
  // MARK: - Loading State Binding
  private func setupBinding() {
    viewModel.isLoading
      .subscribe { [weak self] isLoading in
        DispatchQueue.main.asyncAfter(deadline: .now()) {
          self?.showLoading(isLoading: isLoading)
        }
      }
      .disposed(by: disposeBag)
    
    // MARK: - Text Fields Binding
    
    emailTextField.rx.text.orEmpty
      .bind(to: viewModel.email)
      .disposed(by: disposeBag)
    
    passwordTextField.rx.text.orEmpty
      .bind(to: viewModel.newPassword)
      .disposed(by: disposeBag)
    
    confirmPasswordTextField.rx.text.orEmpty
      .bind(to: viewModel.confirmPassword)
      .disposed(by: disposeBag)
    
    // MARK: - Button Tap Binding
    
    confirmButton.rx
      .tap
      .bind(to: viewModel.confirmButton)
      .disposed(by: disposeBag)
    
    // MARK: - Error Handling
    
    viewModel.errorMessage
      .subscribe(onNext: { errorMessage in
        print("error: \(String(describing: errorMessage))")
      })
      .disposed(by: disposeBag)
    
    // MARK: - Success Handling
    
    viewModel.isSuccess
      .subscribe(onNext: { [weak self] value in
        guard let self, value else { return }
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
}

// MARK: - UITextField Extension
private extension UITextField {
  func setPlaceholder(text: String, color: UIColor) {
    let attributes = [NSAttributedString.Key.foregroundColor: color]
    self.attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)
  }
}
