//
//  SecondaryOnBoardingCollectionViewCell.swift
//  The North
//
//  Created by Naufal Al-Fachri on 07/08/24.
//

import UIKit

class SecondaryOnBoardingCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var onBoardingImage: UIImageView!
  @IBOutlet weak var onBoardingTitle: UILabel!
  @IBOutlet weak var onBoardingSubTitle: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
    }
  func populate(_ onboarding: OnBoarding){
    onBoardingImage.image = UIImage(named: onboarding.image, in: .module, with: nil)
    onBoardingTitle.text = onboarding.title
    onBoardingSubTitle.text = onboarding.subTitle
  }
}
