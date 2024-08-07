//
//  ContactsTableViewCell.swift
//  The North
//
//  Created by Naufal Al-Fachri on 07/08/24.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {

  @IBOutlet weak var contactImage: UIImageView!
  @IBOutlet weak var contactNameLabel: UILabel!
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
