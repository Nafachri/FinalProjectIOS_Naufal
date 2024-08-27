//
//  AddQuickSendCollectionViewCell.swift
//  HomeFeature
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import UIKit
import TheNorthCoreDataManager
import Kingfisher

// MARK: - AddQuickSendCollectionViewCell

class AddQuickSendCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Outlets
  
  @IBOutlet weak var uiImage: UIImageView!
  
  // MARK: - Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }
  
  // MARK: - Setup Methods
  
  private func setupUI() {
    super.layer.cornerRadius = 8
  }
  
  // MARK: - Configuration
  
  func populate(_ quickSend: QuickSendModel) {
    let url = URL(string: quickSend.avatar ?? "home-contact-dummy2")
    uiImage?.kf.setImage(with: url)
  }
}
