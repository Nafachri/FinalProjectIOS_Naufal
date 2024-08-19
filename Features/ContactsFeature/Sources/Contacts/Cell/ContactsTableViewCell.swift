//
//  ContactsTableViewCell.swift
//  The North
//
//  Created by Naufal Al-Fachri on 07/08/24.
//

import UIKit
import TNUI
import TheNorthCoreDataManager



class ContactsTableViewCell: UITableViewCell {
  
  @IBOutlet weak var containerView: FormView!
  @IBOutlet weak var contactImage: UIImageView!
  @IBOutlet weak var contactNameLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .none
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
  func populate(with contact: ContactModel) {
    if let avatarName = contact.avatar, !avatarName.isEmpty {
      contactImage.image = UIImage(named: avatarName, in: .module, with: nil)
    } else {
      contactImage.image = UIImage(named: "contact-profile", in: .module, with: nil)
    }
    contactNameLabel.text = contact.username
    containerView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
  }
  
}
