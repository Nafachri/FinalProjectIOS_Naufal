//
//  TakeScreenshotAndShare.swift
//  Utils
//
//  Created by Naufal Al-Fachri on 15/08/24.
//

import UIKit

public class SharingUtility {
    
    // Static method to share the current view
   public static func shareCurrentView(from viewController: UIViewController, view: UIView) {
        guard let imageToShare = captureViewAsImage(view: view) else {
            print("Failed to capture image from the view.")
            return
        }

        let textToShare = "Check this out!"
        let items: [Any] = [textToShare, imageToShare]

        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        activityViewController.excludedActivityTypes = [
            .assignToContact,
            .print,
        ]
        
        viewController.present(activityViewController, animated: true, completion: nil)
    }
    
    // Helper function to capture the view as an image
    private static func captureViewAsImage(view: UIView) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        return renderer.image { context in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
    }
}
