//
//  HistoryTableViewCell.swift
//  The North
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import UIKit
import TNUI
import TheNorthCoreDataManager
import NetworkManager
import Utils
import Kingfisher

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
  
  func populate(_ history: TransactionResponse) {
    if history.type == "topup" {
      containerView.backgroundColor = UIColor.green.withAlphaComponent(0.2)
    } else {
      containerView.backgroundColor = UIColor.red.withAlphaComponent(0.2)
    }
    
    let url = URL(string: history.avatar)
    avatarImage.kf.setImage(with: url)
    avatarImage.layer.cornerRadius = 28
    
    nameLabel.text = history.name
    dateLabel.text = history.timestamp
    amountLabel.text = history.amount

  }
}
