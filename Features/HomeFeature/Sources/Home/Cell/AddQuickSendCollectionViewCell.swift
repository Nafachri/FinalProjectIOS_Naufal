//
//  AddQuickSendCollectionViewCell.swift
//  HomeFeature
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import UIKit

class AddQuickSendCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var uiImage: UIImageView!
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }
  
  func setupUI() {
    super.layer.cornerRadius = 8
  }
  
  func populate(_ quickSend: AddQuickSend){
    uiImage.image = UIImage(named: quickSend.image, in: .module, with: nil)
  }
}
