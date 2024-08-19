//
//  HistoryTableViewCell.swift
//  The North
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import UIKit
import TNUI
import TheNorthCoreDataManager

class HistoryTableViewCell: UITableViewCell {
  
  @IBOutlet weak var containerView: FormView!
  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .none
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
  func populate(_ history: HistoryModel) {
    let avatarName = history.contact?.avatar ?? "avatar-dummy"
    let username = history.contact?.username ?? "Unknown"
    let createdDate = history.created_date ?? "Unknown Date"
    let amount = history.amount ?? "0"
    let transactionType = history.type ?? "pay"
    
    avatarImage.image = UIImage(named: avatarName, in: .module, with: nil)
    nameLabel.text = username
    dateLabel.text = createdDate
    
    if transactionType == "pay" {
      amountLabel.text = "- \(amount)"
      containerView.backgroundColor = UIColor.red.withAlphaComponent(0.2)
    } else {
      amountLabel.text = "+ \(amount)"
      containerView.backgroundColor = UIColor.green.withAlphaComponent(0.2)
    }
  }
  
}
