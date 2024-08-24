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
import CoreData
import NetworkManager

public enum TypeTransaction: String {
  case topup = "Top Up"
  case transfer = "Pay"
}

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
  var coredata = CoreDataManager.shared
  
  let disposeBag = DisposeBag()
  var viewModel = PaymentViewModel()
  var selectedData: ListContactResponseData?
  var quickSendData: QuickSendModel?
  var userData: ProfileResponse?
  
  var typeTransaction: TypeTransaction = .transfer
  
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
    payButton.setTitle(typeTransaction.rawValue, for: .normal)
    
    if let quickSend = quickSendData {
      phoneNumber.text = quickSend.phoneNumber
      username.text = quickSend.username
      //      let avatarImageName = (quickSend.avatar?.isEmpty ?? true) ?"contact-dummy" : quickSend.avatar
      avatar.image = UIImage(named: "contact-dummy", in: .module, with: nil)
      
    } else if let selectedContact = selectedData {
      phoneNumber.text = selectedContact.phoneNumber
      username.text = selectedContact.name
      //      let avatarImageName = (selectedContact.avatar.isEmpty) ? "contact-dummy" : selectedContact.avatar
      avatar.image = UIImage(named: "contact-dummy", in: .module, with: nil)
    }
    //    else if let userContact = userData {
    //      phoneNumber.text = userContact.phoneNumber
    //      username.text = userContact.username
    //      let avatarImageName = userContact.avatar ?? "contact-dummy"
    //      avatar.image = UIImage(named: avatarImageName, in: .module, with: nil)
    //    }
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
        guard let self = self else {return}
        var recipientName = ""
        if let nameSelectedData = selectedData?.name {
          recipientName = nameSelectedData
        } else if let nameUserData = userData?.name {
          recipientName = nameUserData
        } else if let nameQuickSend = quickSendData?.username {
          recipientName = nameQuickSend
        }
        
        let newAmount = amount.currencyFormattedToInteger()
        
        guard newAmount > 0 else { return }
        
        switch typeTransaction {
        case .transfer:
          showAlertPayment(message: "Send to : \(recipientName) \(amount)?", amount: newAmount, recipientName: recipientName)
        case .topup:
          showAlertTopUp(message: "Top Up : \(newAmount)?", amount: newAmount, recipientName: recipientName)
        }
        
        
        
      }).disposed(by: disposeBag)
    
    
    viewModel.responseTransaction
      .subscribe(onNext: {[weak self] data in
        guard let self else {return}
        self.dismiss(animated: true)
        coordinator.showSuccess(transactionName: data.name, transactionAmount: data.amount, transactionDate: data.timestamp , transactionTitle: data.type.uppercased(), transactionId: data.orderId, transactionType: data.type)
      }).disposed(by: disposeBag)
    
    viewModel.responseTopUp
      .subscribe(onNext: {[weak self] data in
        guard let self else {return}
        self.dismiss(animated: true)
//        viewModel.midtransSdk(token: data.token)
        coordinator.goToMidtrans(token: data.token)
//        coordinator.showSuccess(transactionName: data.name, transactionAmount: data.amount, transactionDate: data.timestamp , transactionTitle: data.type.uppercased(), transactionId: data.orderId, transactionType: data.type)
      }).disposed(by: disposeBag)
    
    
    
    
    //    viewModel.payButtonOutput
    //        .subscribe(onNext: { [weak self] amount in
    //            guard let self = self else { return }
    //
    //            let transactionDate = Date.now.formatted(.dateTime.year().month().day())
    //            let transactionId = generateTransactionID()
    //
    //            // Check if userData exists to determine top-up or payment
    //            let isTopUp = self.userData != nil
    //
    //            let transactionTitle = isTopUp ? "Top Up Success" : "Payment Success"
    //            let transactionType = isTopUp ? "topup" : "pay"
    //            let transactionName = self.selectedData?.username ?? self.quickSendData?.username ?? self.userData?.username ?? ""
    //            let message = isTopUp ? "Confirm the top up of \(amount)?" : "Confirm the payment of \(amount)?"
    //
    //            // Showing alert based on the type of transaction
    //            self.showAlert(
    //                message: message,
    //                transactionName: transactionName,
    //                transactionAmount: amount,
    //                transactionDate: transactionDate,
    //                transactionTitle: transactionTitle,
    //                transactionId: transactionId,
    //                transactionType: transactionType
    //            )
    //        })
    //        .disposed(by: disposeBag)
  }
  
  func showAlertPayment(message: String, amount: Int, recipientName: String){
    let alert = UIAlertController(title: "Are you sure?", message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "Confirm", style: .default) { _ in
      self.viewModel.payRequest(param: TransferParam(amount: amount, recipientUsername: recipientName))
      
    }
    alert.addAction(action)
    present(alert, animated: true)
  }
  
  func showAlertTopUp(message: String, amount: Int, recipientName: String){
    let alert = UIAlertController(title: "Are you sure?", message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "Confirm", style: .default) { _ in
      self.viewModel.topupRequest(param: TopUpParam(amount: amount))
      
    }
    alert.addAction(action)
    present(alert, animated: true)
  }
  
  //  func showAlert(message: String, transactionName: String, transactionAmount: String, transactionDate: String, transactionTitle: String, transactionId: String, transactionType: String) {
  //
  //      let alert = UIAlertController(title: "Are you sure?", message: message, preferredStyle: .alert)
  //      let action = UIAlertAction(title: "Confirm", style: .default) { _ in
  //          self.dismiss(animated: true) {
  //              // Resolve the contact data (either selectedData, quickSendData, or userData)
  //              guard let contact = self.selectedData ?? self.quickSendData ?? self.userData else {
  //                  print("No contact data available")
  //                  return
  //              }
  //
  //              // Create or retrieve the Core Data contact object
  //              let context = CoreDataManager.shared.context
  //              let contactForCoreData: ContactModel
  //
  //              // Cast contact to the specific model type and map properties
  //              if let contactModel = contact as? ContactModel {
  //                  contactForCoreData = contactModel
  //              } else if let quickSendModel = contact as? QuickSendModel {
  //                  contactForCoreData = ContactModel(context: context)
  //                  contactForCoreData.phoneNumber = quickSendModel.phoneNumber
  //                  contactForCoreData.username = quickSendModel.username
  //                  contactForCoreData.avatar = quickSendModel.avatar
  //              } else if let userModel = contact as? UserModel {
  //                  contactForCoreData = ContactModel(context: context)
  //                  contactForCoreData.phoneNumber = userModel.phoneNumber
  //                  contactForCoreData.username = userModel.username
  //                  contactForCoreData.avatar = userModel.avatar
  //              } else {
  //                  print("Unsupported contact type")
  //                  return
  //              }
  //
  //              let properties: [String: Any] = [
  //                  "amount": transactionAmount,
  //                  "created_date": transactionDate,
  //                  "id": transactionId,
  //                  "type": transactionType,
  //                  "contact": contactForCoreData
  //              ]
  //
  //              do {
  //                  let _ = try CoreDataManager.shared.create(entity: HistoryModel.self, properties: properties)
  //
  ////                  self.coordinator.showSuccess(transactionName: transactionName, transactionAmount: transactionAmount, transactionDate: transactionDate, transactionTitle: transactionTitle, transactionId: transactionId, transactionType: transactionType)
  //
  //              } catch {
  //                  print("Failed to save history entry: \(error)")
  //              }
  //          }
  //      }
  //
  //      alert.addAction(action)
  //      present(alert, animated: true)
  //  }
}
