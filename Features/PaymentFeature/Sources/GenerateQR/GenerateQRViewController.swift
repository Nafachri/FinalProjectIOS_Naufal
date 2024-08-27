//
//  GenerateQRViewController.swift
//  PaymentFeature
//
//  Created by Naufal Al-Fachri on 12/08/24.
//

import UIKit
import RxSwift
import RxRelay
import NetworkManager
import Kingfisher

class GenerateQRViewController: UIViewController {
  
  // MARK: - Properties
  var disposeBag = DisposeBag()
  weak var coordinator: GenerateQRCoordinator!
  var viewModel: GenerateQRViewModel
  
  // MARK: - IBOutlets
  @IBOutlet weak var uiView: UIView!
  @IBOutlet weak var amountTextField: UITextField!
  @IBOutlet weak var qrImageView: UIImageView!
  @IBOutlet weak var generateQRButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var askfriendLabel: UILabel!
  
  // MARK: - UI Components
  let toolbar = UIToolbar()
  var loadingOverlay: UIView = {
      let overlay = UIView()
      overlay.backgroundColor = UIColor(white: 0, alpha: 0.7)
      overlay.translatesAutoresizingMaskIntoConstraints = false
      overlay.isHidden = true
      return overlay
  }()
  var activityIndicator: UIActivityIndicatorView = {
      let indicator = UIActivityIndicatorView(style: .large)
      indicator.color = .white
      indicator.translatesAutoresizingMaskIntoConstraints = false
      return indicator
  }()
  
  // MARK: - Initializer
  init(coordinator: GenerateQRCoordinator!, viewModel: GenerateQRViewModel = GenerateQRViewModel()) {
    self.coordinator = coordinator
    self.viewModel = viewModel
    super.init(nibName: "GenerateQRViewController", bundle: .module)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupBinding()
    setupLoadingOverlay()
  }
  
  // MARK: - Setup Methods
  private func setupUI() {
    generateQRButton.isHidden = amountTextField.text == nil
    qrImageView.isHidden = true
    cancelButton.isHidden = true
    askfriendLabel.isHidden = true
    uiView.layer.cornerRadius = 20
    
    // Setup toolbar
    amountTextField.keyboardType = .numberPad
    toolbar.sizeToFit()
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
    toolbar.setItems([flexibleSpace, doneButton], animated: false)
    amountTextField.inputAccessoryView = toolbar
  }
  
  private func setupLoadingOverlay() {
      // Add the loading overlay and the activity indicator to the view hierarchy
      loadingOverlay.addSubview(activityIndicator)
      view.addSubview(loadingOverlay)
      
      // Set up constraints for loadingOverlay and activityIndicator
      NSLayoutConstraint.activate([
          loadingOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          loadingOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          loadingOverlay.topAnchor.constraint(equalTo: view.topAnchor),
          loadingOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
          
          activityIndicator.centerXAnchor.constraint(equalTo: loadingOverlay.centerXAnchor),
          activityIndicator.centerYAnchor.constraint(equalTo: loadingOverlay.centerYAnchor)
      ])
  }
  private func setupBinding() {
    amountTextField.rx.text
      .orEmpty
      .valueToCurrencyFormatted()
      .bind(to: amountTextField.rx.text)
      .disposed(by: disposeBag)
    
    amountTextField.rx.text.orEmpty
      .currencyFormattedToValue()
      .bind(to: viewModel.amount)
      .disposed(by: disposeBag)
    
    // Binding isLoading to show/hide loading overlay
    viewModel.isLoading
        .bind(onNext: { [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                self.showLoadingOverlay()
            } else {
                self.hideLoadingOverlay()
            }
        })
        .disposed(by: disposeBag)
    
    // Subscribe to responseGenerateQR and update UI accordingly
    viewModel.responseGenerateQR.subscribe(onNext: { [weak self] result in
        guard let self = self, let result = result else { return }
        let url = URL(string: result.qrCodeUrl)
        DispatchQueue.main.async {
            self.qrImageView.kf.setImage(with: url)
            self.qrImageView.isHidden = false
        }
    }).disposed(by: disposeBag)
  }
  
  // MARK: - Helper Methods
  private func showLoadingOverlay() {
      loadingOverlay.isHidden = false
      activityIndicator.startAnimating()
  }

  private func hideLoadingOverlay() {
      loadingOverlay.isHidden = true
      activityIndicator.stopAnimating()
  }
  
  // MARK: - Actions
  @IBAction func qrButtonTapped(_ sender: UIButton) {
    generateQRButton.isHidden = true
    qrImageView.isHidden = false
    askfriendLabel.isHidden = false
    cancelButton.isHidden = false
    
    let newAmount = amountTextField.text?.currencyFormattedToInteger()
    let param = GenerateQRParam(amount: String(newAmount ?? 0))
    viewModel.generateQR(param: param)
  }
  
  @IBAction func cancelButtonTapped(_ sender: UIButton) {
    generateQRButton.isHidden = false
    qrImageView.isHidden = true
    qrImageView.image = UIImage(named: "qr")
    cancelButton.isHidden = true
    askfriendLabel.isHidden = true
  }
  
  @objc private func doneButtonTapped() {
    amountTextField.resignFirstResponder()
  }
  
  // MARK: - Helper Methods
  private func generateQRCode(from string: String) -> UIImage? {
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
}
