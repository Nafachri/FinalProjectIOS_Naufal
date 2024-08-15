//
//  TakeScreenshotAndSave.swift
//  Utils
//
//  Created by Naufal Al-Fachri on 15/08/24.
//

import UIKit

public func captureScreenshotAndSave(from viewController: UIViewController) {
  // Show the initial alert asking if the user wants to save the image
  let saveAlert = UIAlertController(
    title: "Save Image",
    message: "Save image to photo gallery?",
    preferredStyle: .alert
  )
  
  let saveAction = UIAlertAction(
    title: "Save",
    style: .default
  ) { _ in
    // Capture and save the screenshot
    if let screenshot = captureScreenshot() {
      saveScreenshot(screenshot) {
        showAlert(
          title: "Success",
          message: "Screenshot saved to photo library.",
          from: viewController
        )
      }
    }
  }
  
  let cancelAction = UIAlertAction(
    title: "Cancel",
    style: .default
  )
  
  saveAlert.addAction(saveAction)
  saveAlert.addAction(cancelAction)
  
  // Present the save alert
  viewController.present(saveAlert, animated: true, completion: nil)
}

// Capture a screenshot of the entire screen
private func captureScreenshot() -> UIImage? {
  guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
        let keyWindow = windowScene.windows.first(where: \.isKeyWindow) else { return nil }
  
  UIGraphicsBeginImageContextWithOptions(keyWindow.bounds.size, false, UIScreen.main.scale)
  keyWindow.drawHierarchy(in: keyWindow.bounds, afterScreenUpdates: true)
  let screenshot = UIGraphicsGetImageFromCurrentImageContext()
  UIGraphicsEndImageContext()
  
  return screenshot
}

// Save the screenshot to the photo library
private func saveScreenshot(_ screenshot: UIImage, completion: @escaping () -> Void) {
  UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil)
  DispatchQueue.main.async {
    completion()
  }
}

// Show an alert with the given title and message
private func showAlert(title: String, message: String, from viewController: UIViewController) {
  let successAlert = UIAlertController(
    title: title,
    message: message,
    preferredStyle: .alert
  )
  successAlert.addAction(UIAlertAction(title: "OK", style: .default))
  viewController.present(successAlert, animated: true, completion: nil)
}




