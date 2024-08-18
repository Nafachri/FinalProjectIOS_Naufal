//
//  HistoryCollectionViewCell.swift
//  The North
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import UIKit
import TheNorthCoreDataManager

class HistoryCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }
  func setupUI() {
    super.layer.cornerRadius = 8
  }
  
  func populate(_ history: HistoryModel) {
    let avatarName = history.contact?.avatar ?? "home-history-dummy"
    let username = history.contact?.username ?? "Unknown"
    let createdDate = history.created_date ?? "Unknown Date"
    let amount = history.amount ?? "0"
    let transactionType = history.type ?? "pay"
    
    avatarImage.image = UIImage(named: avatarName, in: .module, with: nil)
    nameLabel.text = username
    dateLabel.text = createdDate
    
    if transactionType == "pay" {
      amountLabel.text = "- \(amount)"
    } else {
      amountLabel.text = "+ \(amount)"
    }
  }
}
