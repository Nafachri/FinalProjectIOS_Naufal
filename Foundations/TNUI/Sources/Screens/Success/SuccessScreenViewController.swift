//
//  SuccessScreenViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 12/08/24.

import UIKit
import Lottie
import Utils
import RxSwift

public class SuccessScreenViewController: UIViewController {
  
  var transactionName: String?
  var transactionAmount: String?
  var transactionDate: String?
  var transactionTitle: String?
  var transactionId: String?
  var transactionType: String?
  
  @IBOutlet weak var animationView: LottieAnimationView!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var transactionTitleLabel: UILabel!
  @IBOutlet weak var transactionIdValueLabel: UILabel!
  @IBOutlet weak var transactionNameValueLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var transactionDateValueLabel: UILabel!
  @IBOutlet weak var transactionAmountValueLabel: UILabel!

  @IBOutlet weak var saveButton: UIButton!
  @IBOutlet weak var shareButton: UIButton!
  
  public init(transactionName: String, transactionAmount: String, transactionDate: String, transactionTitle: String, transactionId: String, transactionType: String) {
    self.transactionName = transactionName
    self.transactionAmount = transactionAmount
    self.transactionDate = transactionDate
    self.transactionTitle = transactionTitle
    self.transactionId = transactionId
    self.transactionType = transactionType
    super.init(nibName: "SuccessScreenViewController", bundle: .module)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()

    if let path = Bundle.module.path(forResource: "success-animation", ofType: "json") {
      let animation = LottieAnimation.filepath(path)
      animationView.animation = animation
    }
    
    animationView.animationSpeed = 1.0
    animationView.play()
    
    
    // Safely unwrap optionals and set labels
    transactionNameValueLabel.text = transactionName ?? "N/A"
    transactionAmountValueLabel.text = transactionAmount
    transactionDateValueLabel.text = transactionDate ?? "N/A"
    transactionTitleLabel.text = transactionTitle ?? "N/A"
    transactionIdValueLabel.text = transactionId ?? "N/A"
    
    // Set nameLabel based on transactionType
    switch transactionType {
    case "pay":
      nameLabel.text = "Recipient Name : "
    case "topup":
      nameLabel.isHidden = true
    default:
      break
    }
  }
  
  @IBAction func saveButtonTapped(_ sender: UIButton) {
    captureScreenshotAndSave(from: self)
  }
  
  @IBAction func shareButtonTapped(_ sender: UIButton) {
    SharingUtility.shareCurrentView(from: self, view: self.view)
  }
}

public extension SuccessScreenViewController {
  static var checkoutNotification: NSNotification.Name {
    NSNotification.Name("SuccessScreenCheckoutNotification")
  }
}

