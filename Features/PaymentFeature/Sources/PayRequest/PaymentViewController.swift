//
//  PaymentViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 03/08/24.
//

import UIKit
import RxSwift
import RxRelay
import TNUI
import TheNorthCoreDataManager
import Utils

class PaymentViewController: UIViewController {
  
  @IBOutlet weak var phoneNumber: UILabel!
  @IBOutlet weak var username: UILabel!
  @IBOutlet weak var avatar: UIImageView!
  @IBOutlet weak var contactView: UIView!
  @IBOutlet var numberButtons: [UIButton]!
  @IBOutlet weak var dotButton: UIButton!
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var amountTextField: UITextField!
  @IBOutlet weak var payButton: UIButton!
  
  weak var coordinator: PaymentCoordinator!
  let disposeBag = DisposeBag()
  var viewModel = PaymentViewModel()
  var selectedData: ContactModel?
  var coredata = CoreDataManager.shared
  
  
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
    phoneNumber.text = selectedData?.phoneNumber
    username.text = selectedData?.username
  }
  
  func setupBinding() {
    numberButtons.forEach { button in
      button.rx.tap
        .map { button.titleLabel?.text ?? "" }
        .bind(to: viewModel.numberTapped)
        .disposed(by: disposeBag)
    }
    
    dotButton.rx.tap
      .bind(to: viewModel.dotTapped)
      .disposed(by: disposeBag)
    
    deleteButton.rx.tap
      .bind(to: viewModel.deleteTapped)
      .disposed(by: disposeBag)
    
    payButton.rx.tap
      .bind(to: viewModel.payButtonTapped)
      .disposed(by: disposeBag)
    
    viewModel.inputText
      .bind(to: amountTextField.rx.text)
      .disposed(by: disposeBag)
    
    viewModel.payButtonOutput
      .subscribe(onNext: { [weak self] value in
        let transactionDate = Date.now.formatted(.dateTime.year().month().day())
        let transactionTitle = "Payment Success"
        let transactionType = "pay"
        let transactionName = self?.selectedData?.username
        let transactionId = generateTransactionID()
        let message = "confirm the payment of \(value) ?"
        
        self?.showAlert(message: message, transactionName: transactionName ?? "", transactionAmount: value, transactionDate: transactionDate, transactionTitle: transactionTitle, transactionId: transactionId, transactionType: transactionType)
      })
      .disposed(by: disposeBag)
  }
  
  func showAlert(message: String, transactionName: String, transactionAmount: String, transactionDate: String, transactionTitle: String, transactionId: String, transactionType: String) {
    let alert = UIAlertController(title: "Are you sure?", message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "Confirm", style: .default) { _ in
      self.dismiss(animated: true) { [self] in
        
        guard let selectedContact = self.selectedData else {
          print("Selected contact data is missing")
          return
        }
        
        let properties: [String: Any] = [
          "amount": transactionAmount,
          "created_date": transactionDate,
          "id": transactionId,
          "type": transactionType,
          "contact": selectedContact
        ]
        
        do {
          try coredata.create(entity: HistoryModel.self, properties: properties)
        } catch {
          print("Failed to save history entry: \(error)")
        }
        self.coordinator.showSuccess(transactionName: transactionName, transactionAmount: transactionAmount, transactionDate: transactionDate, transactionTitle: transactionTitle, transactionId: transactionId, transactionType: transactionType)
      }
    }
    alert.addAction(action)
    present(alert, animated: true)
  }
}


