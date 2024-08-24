//
//  HistoryCollectionViewCell.swift
//  The North
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import UIKit
import TheNorthCoreDataManager
import NetworkManager

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
  
  func populate(_ history: TransactionResponse) {
    let avatarName = "home-history-dummy"
    let username = history.name
    let createdDate = history.timestamp
    let amount = history.amount
    
    avatarImage.image = UIImage(named: avatarName, in: .module, with: nil)
    nameLabel.text = username
    dateLabel.text = createdDate
    amountLabel.text = String(amount)
  }
}
