//
//  AddQuickSendCollectionViewCell.swift
//  HomeFeature
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import UIKit
import TheNorthCoreDataManager
import Kingfisher

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
    let url = URL(string: quickSend.avatar ?? "home-contact-dummy2")
      uiImage?.kf.setImage(with: url)
  }
}
