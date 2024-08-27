//
//  ContactsTableViewCell.swift
//  The North
//
//  Created by Naufal Al-Fachri on 07/08/24.
//

import UIKit
import TNUI
import TheNorthCoreDataManager
import NetworkManager
import Kingfisher


class ContactsTableViewCell: UITableViewCell {
  
  // MARK: - Outlets
  @IBOutlet weak var containerView: FormView!
  @IBOutlet weak var contactImage: UIImageView!
  @IBOutlet weak var contactNameLabel: UILabel!
  
  // MARK: - Lifecycle
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }
  
  // MARK: - Setup
   private func setupUI() {
       selectionStyle = .none
       configureContactImage()
       configureContainerView()
   }
 
   private func configureContactImage() {
       contactImage.layer.cornerRadius = contactImage.frame.size.width / 2
       contactImage.clipsToBounds = true
   }
 
   private func configureContainerView() {
       containerView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
   }
  
  func populate(with contact: ListContactResponseData) {
    contactNameLabel.text = contact.name
    if let url = URL(string: contact.avatar) {
        contactImage.kf.setImage(with: url)
    }
  }
}
