//
//  ScanQRViewController.swift
//  PaymentFeature
//
//  Created by Naufal Al-Fachri on 11/08/24.
//

import UIKit
import AVFoundation
import Utils
import TNUI
import NetworkManager
import RxSwift


class ScanQRViewController: UIViewController {
  
  // MARK: - Properties
  weak var coordinator: ScanQRCoordinator!
  var viewModel: ScanQRViewModel?
  var disposeBag = DisposeBag()
  private var captureSession: AVCaptureSession!
  private var preview = UIView()
  private var qrCodeFrameView = UIView()
  var qrCodeLabel = UILabel()
  
  private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
    let layer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    layer.frame = preview.bounds
    layer.videoGravity = .resizeAspectFill
    layer.setAffineTransform(self.videoRotationTransform())
    return layer
  }()

  private var lastScannedCode: String?
  
  // MARK: - Initializers
  init(coordinator: ScanQRCoordinator!, viewModel: ScanQRViewModel = ScanQRViewModel()){
    self.coordinator = coordinator
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setupScanQR()
    setupBinding()
  }
  
  private func setup() {
    view.addSubview(preview)
    view.addSubview(qrCodeFrameView)
    view.bringSubviewToFront(qrCodeFrameView)
    view.addSubview(qrCodeLabel)

    preview.frame = view.bounds
    qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
    qrCodeFrameView.layer.borderWidth = 2
    qrCodeFrameView.isHidden = true
  }
  
  private func setupBinding() {
      viewModel?.responsePayScanQR
          .subscribe(onNext: { [weak self] data in
              guard let self = self else { return }
              
              let transactionDate = Date.now.formatted(.dateTime.year().month().day())
              let transactionTitle = "Payment Success"
              let transactionId = ""
              let transactionType = "pay"
              let transactionName = data?.recipient ?? "Unknown"
              let transactionAmount = data?.amount

              self.dismiss(animated: true) {
                  self.coordinator?.showSuccess(
                      transactionName: transactionName,
                      transactionAmount: transactionAmount ?? "",
                      transactionDate: transactionDate,
                      transactionTitle: transactionTitle,
                      transactionId: transactionId,
                      transactionType: transactionType
                  )
              }
              
              NotificationCenter.default.post(
                  name: SuccessScreenViewController.checkoutNotification,
                  object: data
              )
          })
          .disposed(by: disposeBag)
  }

  
  private func setupScanQR() {
    guard let captureDevice = AVCaptureDevice.default(for: .video) else {
      print("Camera not available")
      return
    }
    
    do {
      let input = try AVCaptureDeviceInput(device: captureDevice)
      captureSession = AVCaptureSession()
      captureSession?.addInput(input)
      
      let output = AVCaptureMetadataOutput()
      captureSession?.addOutput(output)
      
      output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
      output.metadataObjectTypes = [.qr]
      preview.layer.addSublayer(previewLayer)
      DispatchQueue.global(qos: .userInitiated).async {
        self.captureSession?.startRunning()
      }
    } catch {
      print("Error setting up capture session: \(error.localizedDescription)")
    }
  }
  
  // MARK: - Utility Methods
  
  private func videoRotationTransform() -> CGAffineTransform {
    let orientation = UIDevice.current.orientation
    var angle: CGFloat = 0
    
    switch orientation {
    case .landscapeLeft:
      angle = .pi / 2
    case .landscapeRight:
      angle = -.pi / 2
    case .portraitUpsideDown:
      angle = .pi
    case .portrait, .unknown, .faceUp, .faceDown:
      angle = 0
    @unknown default:
      angle = 0
    }
    return CGAffineTransform(rotationAngle: angle)
  }
  
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension ScanQRViewController: AVCaptureMetadataOutputObjectsDelegate {
  
  func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    if let metadataObject = metadataObjects.first {
      guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
      
      if let stringValue = readableObject.stringValue {
        if stringValue != lastScannedCode {
          lastScannedCode = stringValue
          self.captureSession?.stopRunning()
          showAlert(message: "Pay: \(String(describing: extractAmount(from: stringValue)))?", value: stringValue)
        }
      }
      
      if let barCodeObject = previewLayer.transformedMetadataObject(for: metadataObject) {
        let qrCodeFrame = barCodeObject.bounds
        DispatchQueue.main.async {
          self.qrCodeLabel.isHidden = true
          self.qrCodeFrameView.isHidden = false
          self.qrCodeFrameView.frame = qrCodeFrame
          self.qrCodeLabel.frame = CGRect(x: self.qrCodeFrameView.frame.minX, y: self.qrCodeFrameView.frame.minY-60, width: 300, height: 60)
        }
      } else {
        DispatchQueue.main.async {
          self.qrCodeFrameView.isHidden = true
        }
      }
    }
  }
}

// MARK: - Alert & Helpers

extension ScanQRViewController {
  
  func showAlert(message: String, value: String) {
    let alert = UIAlertController(title: "Are you sure?", message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "Confirm", style: .default) { _ in
      self.viewModel?.payScanQR(param: PayQRParam(qrCodeData: value))
      alert.dismiss(animated: true, completion: nil)
    }
    alert.addAction(action)
    present(alert, animated: true)
  }
  
  func extractAmount(from input: String) -> String? {
      let components = input.split(separator: ":")
      guard components.count >= 3 else {
          return nil
      }
      return String(components.last!)
  }
}
