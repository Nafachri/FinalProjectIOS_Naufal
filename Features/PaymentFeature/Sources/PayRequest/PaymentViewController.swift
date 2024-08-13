//
//  PaymentViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 03/08/24.
//

import UIKit
import RxSwift
import RxRelay
import Utils
import TNUI

class PaymentViewController: UIViewController {
  
  @IBOutlet weak var contactView: UIView!
  @IBOutlet var numberButtons: [UIButton]!
  @IBOutlet weak var dotButton: UIButton!
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var amountTextField: UITextField!
  @IBOutlet weak var payButton: UIButton!
  
  weak var coordinator: PaymentCoordinator!
  let disposeBag = DisposeBag()
  var viewModel = PaymentViewModel()
  
  
  init(coordinator: PaymentCoordinator!, viewModel: PaymentViewModel = .init()){
    self.coordinator = coordinator
    self.viewModel = viewModel
    super.init(nibName: "PaymentViewController", bundle: .module)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupBinding()
  }
  
  func setupUI() {
    contactView.layer.cornerRadius = 10
    payButton.layer.cornerRadius = 10
  }
  
  func setupBinding() {
    // Bind number buttons
    numberButtons.forEach { button in
      button.rx.tap
        .map { button.titleLabel?.text ?? "" }
        .bind(to: viewModel.numberTapped)
        .disposed(by: disposeBag)
    }
    
    // Bind dot button
    dotButton.rx.tap
      .bind(to: viewModel.dotTapped)
      .disposed(by: disposeBag)
    
    // Bind delete button
    deleteButton.rx.tap
      .bind(to: viewModel.deleteTapped)
      .disposed(by: disposeBag)
    
    // Bind Pay button
    payButton.rx.tap
      .bind(to: viewModel.payButtonTapped)
      .disposed(by: disposeBag)
    
    // Bind input text to label
    viewModel.inputText
      .bind(to: amountTextField.rx.text)
      .disposed(by: disposeBag)
    
    // Handle pay button output
    viewModel.payButtonOutput
      .subscribe(onNext: { [weak self] message in
        self?.showAlert(message: message)
      })
      .disposed(by: disposeBag)
  }
  
  func showAlert(message: String) {
    let alert = UIAlertController(title: "Payment", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
  
  //  MARK: show success view controller
  
  //  func showSuccessViewController() {
  //    let successScreenViewController = TNUI.SuccessScreenViewController()
  //    if let sheet = successScreenViewController.sheetPresentationController {
  //      sheet.detents = [.medium(), .large()] // Adjust the sizes as needed
  //      sheet.prefersGrabberVisible = true
  //    }
  //
  //    present(successScreenViewController, animated: true, completion: nil)
  //
  //  }
}

