//
//  ContactCollectionViewCell.swift
//  The North
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import UIKit

class ContactCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var avatarImage: UIImageView!
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }
  
  func setupUI() {
    super.layer.cornerRadius = 8
  }
  
  func populate(_ contact: Contact){
    avatarImage.image =  UIImage(named: contact.image, in: .module, with: nil)
  }
}
