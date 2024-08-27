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
import Kingfisher

// MARK: - Enum Definitions

public enum TypeTransaction: String {
  case topup = "topup"
  case transfer = "pay"
}

// MARK: - PaymentViewController

class PaymentViewController: UIViewController {
  
  // MARK: - Outlets
  
  @IBOutlet weak var phoneNumber: UILabel!
  @IBOutlet weak var username: UILabel!
  @IBOutlet weak var avatar: UIImageView!
  @IBOutlet weak var contactView: UIView!
  @IBOutlet var numberButtons: [UIButton]!
  @IBOutlet weak var dotButton: UIButton!
  @IBOutlet weak var deleteButton: UIButton!
  @IBOutlet weak var amountTextField: UITextField!
  @IBOutlet weak var payButton: UIButton!
  
  // MARK: - Properties
  
  weak var coordinator: PaymentCoordinator!
  var coredata = CoreDataManager.shared
  
  let disposeBag = DisposeBag()
  var viewModel = PaymentViewModel()
  var selectedData: ListContactResponseData?
  var quickSendData: QuickSendModel?
  var userData: ProfileResponse?
  
  var typeTransaction: TypeTransaction = .transfer
  
  // MARK: - Initializers
  
  init(coordinator: PaymentCoordinator!, viewModel: PaymentViewModel = .init()){
    self.coordinator = coordinator
    self.viewModel = viewModel
    super.init(nibName: "PaymentViewController", bundle: .module)
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
  
  // MARK: - Setup
  
  func setupUI() {
    avatar.layer.cornerRadius = avatar.frame.size.width / 2
    avatar.clipsToBounds = true
    payButton.tintColor = .white
    
    contactView.layer.cornerRadius = 10
    payButton.layer.cornerRadius = 10
    payButton.setTitle(typeTransaction.rawValue, for: .normal)
    
    if let quickSend = quickSendData {
      let url = URL(string: quickSend.avatar ?? "contact-dummy")
      avatar.kf.setImage(with: url)
      phoneNumber.text = quickSend.phoneNumber
      username.text = quickSend.username
    } else if let selectedContact = selectedData {
      let url = URL(string: selectedContact.avatar)
      avatar.kf.setImage(with: url)
      phoneNumber.text = selectedContact.phoneNumber
      username.text = selectedContact.name
    } else if let userContact = userData {
      let url = URL(string: userContact.avatar)
      avatar.kf.setImage(with: url)
      phoneNumber.text = userContact.phoneNumber
      username.text = userContact.name
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
        var recipientName = ""
        if let nameSelectedData = self.selectedData?.name {
          recipientName = nameSelectedData
        } else if let nameUserData = self.userData?.name {
          recipientName = nameUserData
        } else if let nameQuickSend = self.quickSendData?.username {
          recipientName = nameQuickSend
        }
        
        let newAmount = amount.currencyFormattedToInteger()
        
        guard newAmount > 0 else { return }
        
        switch self.typeTransaction {
        case .transfer:
          self.showAlertPayment(message: "Send to : \(recipientName) \(amount)?", amount: newAmount, recipientName: recipientName)
        case .topup:
          self.showAlertTopUp(message: "Top Up \(amount)?", amount: newAmount, recipientName: recipientName)
        }
      }).disposed(by: disposeBag)
    
    viewModel.responseTransaction
      .subscribe(onNext: { [weak self] data in
        guard let self = self else { return }
        
        let transactionAmount = data?.amount
        let transactionDate = data?.timestamp
        let transactionTitle = "Payment Success"
        let transactionId = data?.orderId
        let transactionType = "pay"
        let transactionName = data?.name
        
        self.dismiss(animated: true) {
          self.coordinator?.showSuccess(
            transactionName: transactionName ?? "",
            transactionAmount: transactionAmount ?? "",
            transactionDate: transactionDate ?? "",
            transactionTitle: transactionTitle,
            transactionId: transactionId ?? "",
            transactionType: transactionType
          )
        }
        NotificationCenter.default.post(
          name: SuccessScreenViewController.checkoutNotification,
          object: data
        )
      }).disposed(by: disposeBag)
    
    viewModel.responseTopUp
      .subscribe(onNext: { [weak self] data in
        guard let self = self else { return }
        self.dismiss(animated: true)
        self.coordinator.goToMidtrans(token: data.token)
      }).disposed(by: disposeBag)
  }
  
  // MARK: - Alert Presentation
  
  func showAlertPayment(message: String, amount: Int, recipientName: String) {
    let alert = UIAlertController(title: "Are you sure?", message: message, preferredStyle: .alert)
    
    // Confirm action
    let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
      self.viewModel.payRequest(param: TransferParam(amount: amount, recipientUsername: recipientName))
      alert.dismiss(animated: true, completion: nil)
    }
    
    // Cancel action
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
      alert.dismiss(animated: true, completion: nil)
    }
    
    alert.addAction(confirmAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true)
  }
  
  func showAlertTopUp(message: String, amount: Int, recipientName: String) {
    let alert = UIAlertController(title: "Are you sure?", message: message, preferredStyle: .alert)
    
    // Confirm action
    let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
      self.viewModel.topupRequest(param: TopUpParam(amount: amount))
      alert.dismiss(animated: true, completion: nil)
    }
    
    // Cancel action
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
      alert.dismiss(animated: true, completion: nil)
    }
    
    alert.addAction(confirmAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true)
  }
}

// MARK: - UIApplication Extension

extension UIApplication {
  func topMostViewController() -> UIViewController? {
    guard let windowScene = connectedScenes.first(where: { $0 is UIWindowScene }) as? UIWindowScene else {
      return nil
    }
    
    var topController = windowScene.windows.first(where: \.isKeyWindow)?.rootViewController
    
    while let presented = topController?.presentedViewController {
      topController = presented
    }
    
    return topController
  }
}
