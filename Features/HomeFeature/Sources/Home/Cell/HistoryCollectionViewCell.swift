//
//  HistoryCollectionViewCell.swift
//  The North
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import UIKit

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
  
  func populate(_ history: History){
    avatarImage.image = UIImage(named: history.image, in: .module, with: nil)
    nameLabel.text = history.name
    dateLabel.text = history.date
    amountLabel.text = history.amount
  }
}
