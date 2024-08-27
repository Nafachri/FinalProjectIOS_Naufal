//
//  HistoryCollectionViewCell.swift
//  The North
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import UIKit
import TheNorthCoreDataManager
import NetworkManager
import Kingfisher

// MARK: - HistoryCollectionViewCell

class HistoryCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Outlets
  
  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  
  // MARK: - Lifecycle
  
  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }
  
  // MARK: - Setup Methods
  
  private func setupUI() {
    super.layer.cornerRadius = 8
    avatarImage.layer.cornerRadius = avatarImage.frame.size.width / 2
    avatarImage.clipsToBounds = true
  }
  
  // MARK: - Configuration
  
  func populate(_ history: TransactionResponse) {
    let url = URL(string: history.avatar)
    avatarImage.kf.setImage(with: url)
    
    let username = history.name
    let createdDate = history.timestamp
    let amount = history.amount
    
    nameLabel.text = username
    dateLabel.text = createdDate
    amountLabel.text = String(amount)
  }
}
