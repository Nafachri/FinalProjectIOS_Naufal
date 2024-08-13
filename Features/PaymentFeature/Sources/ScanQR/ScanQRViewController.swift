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

class ScanQRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
  
  weak var coordinator: ScanQRCoordinator!
  
  init(coordinator: ScanQRCoordinator!){
    self.coordinator = coordinator
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private var captureSession: AVCaptureSession!
  private var preview = UIView()
  private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
    let layer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    layer.frame = preview.bounds
    layer.videoGravity = .resizeAspectFill
    layer.setAffineTransform(self.videoRotationTransform())
    return layer
  }()
  private var qrCodeFrameView = UIView()
  var qrCodeLabel = UILabel()
  
  private var lastScannedCode: String? // Track the last scanned QR code
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(preview)
    preview.frame = view.bounds
    qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
    qrCodeFrameView.layer.borderWidth = 2
    view.addSubview(qrCodeFrameView)
    view.bringSubviewToFront(qrCodeFrameView)
    qrCodeFrameView.isHidden = true
    view.addSubview(qrCodeLabel)
    
    // Check if the device has a camera
    setupScanQR()
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
  
  func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    if let metadataObject = metadataObjects.first {
      guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
      
      if let stringValue = readableObject.stringValue {
        // Check if the scanned code is different from the last scanned code
        if stringValue != lastScannedCode {
          lastScannedCode = stringValue
          self.captureSession?.stopRunning()
          DispatchQueue.main.async {
            self.qrCodeLabel.text = stringValue
            
            // Check if the scanned string is not "0"
            if stringValue != "0.0" {
              
              
            
              // Show the alert after the scanner is dismissed
              self.showAlert(message: "Scanned QR code is: \(stringValue)")
              
              //              }
            } else {
              // Handle the case where the string is "0.0"
              let alert = UIAlertController(title: "Invalid Code", message: "Please input the amount first!", preferredStyle: .alert)
              let action = UIAlertAction(title: "OK", style: .default) { _ in
//                self.dismiss(animated: true)
                self.lastScannedCode = nil
                DispatchQueue.global(qos: .background).async {
                  self.captureSession.startRunning()
                }
              }
              alert.addAction(action)
              self.present(alert, animated: true)

            }
          }
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
  
  func showAlert(message: String) {
    let alert = UIAlertController(title: "Are you sure?", message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "Confirm", style: .default) {_ in
      self.dismiss(animated: true) { [self] in
        self.coordinator.showSuccess()
      }
      
    }
    alert.addAction(action)
    present(alert, animated: true)
  }
}
