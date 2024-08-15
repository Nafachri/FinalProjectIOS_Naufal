//
//  MidtransViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 13/08/24.
//

import UIKit
import MidtransKit


class MidtransViewController: UIViewController, MidtransUIPaymentViewControllerDelegate {
  
  weak var coordinator: MidtransCoordinator!
  
  init(coordinator: MidtransCoordinator!){
    self.coordinator = coordinator
    super.init(nibName: "MidtransViewController", bundle: .module)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  
  @IBAction func buttonTapped(_ sender: UIButton) {
      
    MidtransMerchantClient.shared().requestTransacation(withCurrentToken: "ad895074-8a1e-4c8d-b06a-e3d11766015f") { (response, error) in
        if (response != nil){
            //initialize MidtransUIPaymentViewController
            let vc = MidtransUIPaymentViewController.init(token: response)
            //set you ViewController as delegate
            vc?.paymentDelegate = self
            //present the payment page
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


  }
  
  func paymentViewController(_ viewController: MidtransUIPaymentViewController!, paymentFailed error: (any Error)!) {
    print("payment failed")

  }
  
  func paymentViewController_paymentCanceled(_ viewController: MidtransUIPaymentViewController!) {
    print("payment cancelled")
  }
  

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
