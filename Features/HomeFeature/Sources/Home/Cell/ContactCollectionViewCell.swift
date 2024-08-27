//
//  ContactCollectionViewCell.swift
//  The North
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import UIKit
import TheNorthCoreDataManager

// MARK: - ContactCollectionViewCell

class ContactCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Outlets
  
  @IBOutlet weak var avatarImage: UIImageView!
  
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
  
  func populate(_ contact: ContactModel) {
    avatarImage.image = UIImage(named: "home-contact-dummy", in: .module, with: nil)
  }
}
