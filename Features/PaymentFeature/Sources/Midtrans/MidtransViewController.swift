//
//  MidtransViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 13/08/24.
//

import UIKit
import MidtransKit
import RxSwift
import RxRelay
import TNUI
import Utils

class MidtransViewController: UIViewController {
  
  // MARK: - Properties
  weak var coordinator: MidtransCoordinator!
  var token: String?
  
  // MARK: - Initializer
  init(coordinator: MidtransCoordinator!) {
    self.coordinator = coordinator
    super.init(nibName: "MidtransViewController", bundle: .module)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    requestTransactionToken()
  }
  
  // MARK: - Payment Methods
  private func requestTransactionToken() {
    MidtransMerchantClient.shared().requestTransacation(withCurrentToken: token ?? "") { [weak self] (response, error) in
      guard let self = self else { return }
      if let response = response {
        let paymentVC = MidtransUIPaymentViewController(token: response)
        paymentVC?.paymentDelegate = self
        if let paymentVC = paymentVC {
          self.present(paymentVC, animated: true, completion: nil)
        }
      } else if let error = error {
        print("Error: \(error.localizedDescription)")
      }
    }
  }
  
  // MARK: - Success Screen
  private func showSuccessScreen(result: MidtransTransactionResult) {
    let transactionAmount: NSNumber? = result.grossAmount
    let formattedAmount = formatToIDR(transactionAmount)
    let newAmount = formattedAmount.currencyFormattedToInteger()
    let transactionDate = Date.now.formatted(.dateTime.year().month().day())
    
    let successVC = SuccessScreenViewController(
      transactionName: "",
      transactionAmount: String(newAmount),
      transactionDate: transactionDate,
      transactionTitle: "Top Up Success",
      transactionId: result.orderId ?? "",
      transactionType: "topup"
    )
    
    if let topController = UIApplication.shared.topMostViewController() {
      topController.present(successVC, animated: true) {
        NotificationCenter.default.post(
          name: SuccessScreenViewController.checkoutNotification,
          object: result
        )
      }
    } else {
      print("Unable to find the topmost view controller.")
    }
  }
}

// MARK: - MidtransUIPaymentViewControllerDelegate
extension MidtransViewController: MidtransUIPaymentViewControllerDelegate {
  
  func paymentViewController(_ viewController: MidtransUIPaymentViewController!, paymentPending result: MidtransTransactionResult!) {
    print("Payment pending")
  }
  
  func paymentViewController(_ viewController: MidtransUIPaymentViewController!, paymentDeny result: MidtransTransactionResult!) {
    print("Payment denied")
  }
  
  func paymentViewController(_ viewController: MidtransUIPaymentViewController!, paymentSuccess result: MidtransTransactionResult!) {
    print("Payment success")
    self.dismiss(animated: true) {
      self.showSuccessScreen(result: result)
    }
  }
  
  func paymentViewController(_ viewController: MidtransUIPaymentViewController!, paymentFailed error: (any Error)!) {
    print("Payment failed: \(error.localizedDescription)")
  }
  
  func paymentViewController_paymentCanceled(_ viewController: MidtransUIPaymentViewController!) {
    print("Payment cancelled")
  }
}
