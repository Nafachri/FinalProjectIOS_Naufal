//
//  Ext+UIView.swift
//  TNUI
//
//  Created by Naufal Al-Fachri on 13/08/24.
//

import Foundation
import UIKit

public extension UIView {
    func makeCornerRadius(_ radius: CGFloat, maskedCorner: CACornerMask?) {
        layer.cornerRadius = radius
        layer.maskedCorners = maskedCorner ?? [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        clipsToBounds = true
    }


    func addBorderLine(width: CGFloat = 1,
                       color: UIColor = .foodGrey3) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }

    func addShadow(color: UIColor = .foodBlack80,
                   offset: CGSize = CGSize(width: 0, height: 3),
                   opacity: Float = 0.5,
                   radius: CGFloat = 2,
                   path: UIBezierPath? = nil) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowPath = path?.cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }

    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView ?? UIView()
    }


}
