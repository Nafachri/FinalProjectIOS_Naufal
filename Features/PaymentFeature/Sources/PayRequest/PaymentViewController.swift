////
////  PaymentViewController.swift
////  The North
////
////  Created by Naufal Al-Fachri on 03/08/24.
////
//

import UIKit
import RxSwift
import RxRelay
import TNUI
import TheNorthCoreDataManager
import Utils
import CoreData

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
  var quickSendData: QuickSendModel?
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
    
    if let quickSend = quickSendData {
      phoneNumber.text = quickSend.phoneNumber
      username.text = quickSend.username
      let avatarImageName = quickSend.avatar ?? "contact-dummy"
      avatar.image = UIImage(named: avatarImageName, in: .module, with: nil)
      
    } else if let selectedContact = selectedData {
      phoneNumber.text = selectedContact.phoneNumber
      username.text = selectedContact.username
      let avatarImageName = selectedContact.avatar ?? "contact-dummy"
      avatar.image = UIImage(named: avatarImageName, in: .module, with: nil)
      
    }
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
      .subscribe(onNext: { [weak self] amount in
        guard let self = self else { return }
        
        let transactionDate = Date.now.formatted(.dateTime.year().month().day())
        let transactionTitle = "Payment Success"
        let transactionType = "pay"
        let transactionName = self.selectedData?.username ?? self.quickSendData?.username ?? ""
        let transactionId = generateTransactionID()
        let message = "Confirm the payment of \(amount)?"
        
        self.showAlert(message: message, transactionName: transactionName, transactionAmount: amount, transactionDate: transactionDate, transactionTitle: transactionTitle, transactionId: transactionId, transactionType: transactionType)
      })
      .disposed(by: disposeBag)
  }
  
  func showAlert(message: String, transactionName: String, transactionAmount: String, transactionDate: String, transactionTitle: String, transactionId: String, transactionType: String) {
    let alert = UIAlertController(title: "Are you sure?", message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "Confirm", style: .default) { _ in
      self.dismiss(animated: true) {
        let contact = self.selectedData ?? self.quickSendData
        
        guard let contact = contact else {
          print("No contact data available")
          return
        }
        
        let context = CoreDataManager.shared.context
        let contactForCoreData: ContactModel
        
        if let contactModel = contact as? ContactModel {
          contactForCoreData = contactModel
        } else if let quickSendModel = contact as? QuickSendModel {
          // Create a new ContactModel object from QuickSendModel
          contactForCoreData = ContactModel(context: context)
          contactForCoreData.phoneNumber = quickSendModel.phoneNumber
          contactForCoreData.username = quickSendModel.username
          contactForCoreData.avatar = quickSendModel.avatar
          // Set other properties if needed
        } else {
          print("Unsupported contact type")
          return
        }
        
        let properties: [String: Any] = [
          "amount": transactionAmount,
          "created_date": transactionDate,
          "id": transactionId,
          "type": transactionType,
          "contact": contactForCoreData
        ]
        
        do {
          // Ensure HistoryModel is correctly created with properties
          let _ = try CoreDataManager.shared.create(entity: HistoryModel.self, properties: properties)
          
          // Call success coordinator
          self.coordinator.showSuccess(transactionName: transactionName, transactionAmount: transactionAmount, transactionDate: transactionDate, transactionTitle: transactionTitle, transactionId: transactionId, transactionType: transactionType)
          
        } catch {
          print("Failed to save history entry: \(error)")
        }
      }
    }
    alert.addAction(action)
    present(alert, animated: true)
  }
}
