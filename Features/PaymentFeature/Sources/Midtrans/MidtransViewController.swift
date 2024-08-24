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


class MidtransViewController: UIViewController, MidtransUIPaymentViewControllerDelegate {
  
  weak var coordinator: MidtransCoordinator!
  
  var token: String?
  init(coordinator: MidtransCoordinator!){
    self.coordinator = coordinator
    super.init(nibName: "MidtransViewController", bundle: .module)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    MidtransMerchantClient.shared().requestTransacation(withCurrentToken: token ?? "") { (response, error) in
        if (response != nil){
            let vc = MidtransUIPaymentViewController.init(token: response)
            vc?.paymentDelegate = self
            self.present(vc!, animated: true, completion: nil)
        } else {
            print("error \(error!)");
        }
    }

  }
  
  func paymentViewController(_ viewController: MidtransUIPaymentViewController!, paymentPending result: MidtransTransactionResult!) {
    print("payment pending")
  }
  
  func paymentViewController(_ viewController: MidtransUIPaymentViewController!, paymentDeny result: MidtransTransactionResult!) {
    print("payment denied")
  }
  
  func paymentViewController(_ viewController: MidtransUIPaymentViewController!, paymentSuccess result: MidtransTransactionResult!) {
    print("payment success")
    self.dismiss(animated: true)
    NotificationCenter.default.post(name: SuccessScreenViewController.chekcoutNotification, object: nil)

  }
  
  func paymentViewController(_ viewController: MidtransUIPaymentViewController!, paymentFailed error: (any Error)!) {
    print("payment failed")

  }
  
  func paymentViewController_paymentCanceled(_ viewController: MidtransUIPaymentViewController!) {
    print("payment cancelled")
  }
}
