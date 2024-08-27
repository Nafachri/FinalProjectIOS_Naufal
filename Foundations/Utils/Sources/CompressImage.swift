//
//  CompressImage.swift
//  Utils
//
//  Created by Naufal Al-Fachri on 26/08/24.
//
import UIKit

public extension UIImage {

 func compressToSize(kb: Int) -> Data {
        guard kb > 10 else { return Data() }
        let maxSize = kb * 1024
        var compression: CGFloat = 1.0
        let step: CGFloat = 0.01
        var holderImage = self
        var complete = false
        
        while !complete {
            guard let data = holderImage.jpegData(compressionQuality: compression) else { break }
            let dataSize = data.count
            if dataSize < maxSize {
                complete = true
                return data
            } else {
                compression -= step
            }
            guard let newImage = holderImage.resized(withPercentage: compression) else { break }
            holderImage = newImage
        }
        
        return Data()
    }
  
  func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
          let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
          let format = imageRendererFormat
          format.opaque = isOpaque
          return UIGraphicsImageRenderer(size: canvas, format: format).image { _ in draw(in: CGRect(origin: .zero, size: canvas))
          }
      }
}
