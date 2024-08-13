//
//  HistoryTableViewCell.swift
//  The North
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import UIKit
import TNUI

class HistoryTableViewCell: UITableViewCell {
  
  @IBOutlet weak var containerView: FormView!
  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .none
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
  func populate(_ history: History){
    avatarImage.image = UIImage(named: history.image ?? "", in: .module, with: nil)
    nameLabel.text = history.name
    dateLabel.text = history.date
    amountLabel.text = history.amount
    
    if history.amount.hasPrefix("-") {
      containerView.backgroundColor = UIColor.red.withAlphaComponent(0.2)
    } else if history.amount.hasPrefix("+") {
      containerView.backgroundColor = UIColor.green.withAlphaComponent(0.2)
    } else {
      containerView.backgroundColor = .clear
    }
  }
  
}
