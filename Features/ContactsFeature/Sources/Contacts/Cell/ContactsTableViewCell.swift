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
  
  func populate(with contact: ListContactResponseData) {
    contactImage.layer.cornerRadius = 24
    contactNameLabel.text = contact.name
    let url = URL(string: contact.avatar)
    contactImage.kf.setImage(with: url)
    containerView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
  }
}
