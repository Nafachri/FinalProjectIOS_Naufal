//
//  GenerateQRViewController.swift
//  PaymentFeature
//
//  Created by Naufal Al-Fachri on 12/08/24.
//

import UIKit
import RxSwift
import RxRelay

class GenerateQRViewController: UIViewController {
  var disposeBag = DisposeBag()
  
  
  @IBOutlet weak var uiView: UIView!
  @IBOutlet weak var amountTextField: UITextField!
  @IBOutlet weak var qrImageView: UIImageView!
  let toolbar = UIToolbar()
  weak var coordinator: GenerateQRCoordinator!
  var viewModel: GenerateQRViewModel
  
  let transactionId: String = "085883749172"
  let userName: String = "Nafachri"
  
  
  init(coordinator: GenerateQRCoordinator!, viewModel: GenerateQRViewModel = GenerateQRViewModel()){
    self.coordinator = coordinator
    self.viewModel = viewModel
    super.init(nibName: "GenerateQRViewController", bundle: .module)
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
    uiView.layer.cornerRadius = 20
    amountTextField.keyboardType = .numberPad
    toolbar.sizeToFit()
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))

    toolbar.setItems([flexibleSpace, doneButton], animated: false)
    amountTextField.inputAccessoryView = toolbar


    guard let qrImageView = qrImageView else {
      return
    }
//    MARK: Changes here
//    qrImageView.image = generateQRCode(from: "0")
    qrImageView.image = generateQRCode(from: "{}")


  }
  
  func setupBinding(){
    amountTextField.rx.text
      .orEmpty
      .valueToCurrencyFormatted()
      .bind(to: amountTextField.rx.text)
      .disposed(by: disposeBag)
    
    amountTextField.rx.text.orEmpty
      .currencyFormattedToValue()
      .bind(to: viewModel.amount)
      .disposed(by: disposeBag)
    
    viewModel.amount
      .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .subscribe(onNext: { [weak self] value in
        guard let self else { return }
        // Create user data object
        let userData: [String: Any] = [
            "transactionId": self.transactionId,
            "userName": self.userName,
            "amount": value
        ]
        
        // Convert to JSON string
        if let jsonData = try? JSONSerialization.data(withJSONObject: userData, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            self.qrImageView.image = self.generateQRCode(from: jsonString)
        }
//        MARK: Changes here!
//        qrImageView.image = generateQRCode(from: value)
      }).disposed(by: disposeBag)
  }
  
  func generateQRCode(from string: String) -> UIImage? {
    let data = string.data(using: String.Encoding.ascii)
    if let filter = CIFilter(name: "CIQRCodeGenerator") {
      filter.setValue(data, forKey: "inputMessage")
      let transform = CGAffineTransform(scaleX: UIScreen.main.scale * 4, y: UIScreen.main.scale * 4)
      if let output = filter.outputImage?.transformed(by: transform) {
        return UIImage(ciImage: output)
      }
    }
    return nil
  }
  
  @objc func doneButtonTapped() {
      amountTextField.resignFirstResponder()
  }
}


