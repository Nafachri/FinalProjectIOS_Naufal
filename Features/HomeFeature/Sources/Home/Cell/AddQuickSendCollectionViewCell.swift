//
//  AddQuickSendCollectionViewCell.swift
//  HomeFeature
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import UIKit
import TheNorthCoreDataManager

class AddQuickSendCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var uiImage: UIImageView!
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }
  
  func setupUI() {
    super.layer.cornerRadius = 8
  }
  
  func populate(_ quickSend: QuickSendModel) {
      if let avatarName = quickSend.avatar, !avatarName.isEmpty {
          uiImage.image = UIImage(named: avatarName, in: .module, with: nil)
      } else {
          uiImage.image = UIImage(named: "home-contact-dummy2", in: .module, with: nil)
      }
  }
}
