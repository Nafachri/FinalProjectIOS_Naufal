//
//  ContactsTableViewCell.swift
//  The North
//
//  Created by Naufal Al-Fachri on 07/08/24.
//

import UIKit
import TNUI
import TheNorthCoreDataManager
import TheNorthCoreDataModel


class ContactsTableViewCell: UITableViewCell {

  @IBOutlet weak var contactImage: UIImageView!
  @IBOutlet weak var contactNameLabel: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
  
  func populate(_ contact: ContactModel){
//    contactImage.image = UIImage(named: contact.image ?? "", in: .module, with: nil)
    contactNameLabel.text = contact.username
  }
    
}
