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
  
  func populate(_ quickSend: ContactModel){
    uiImage.image = UIImage(named: quickSend.avatar ?? "home-contact-dummy", in: .module, with: nil)
  }
}
