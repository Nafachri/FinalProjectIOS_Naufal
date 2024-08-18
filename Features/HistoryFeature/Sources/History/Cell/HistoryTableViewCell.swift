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
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
  func populate(_ history: HistoryModel){
    avatarImage.image = UIImage(named: history.contact?.avatar ?? "", in: .module, with: nil)
    nameLabel.text = history.contact?.username
    dateLabel.text = history.created_date
    amountLabel.text = history.amount
    
    if ((history.amount?.hasPrefix("-")) != nil) {
      containerView.backgroundColor = UIColor.red.withAlphaComponent(0.2)
    } else if ((history.amount?.hasPrefix("+")) != nil) {
      containerView.backgroundColor = UIColor.green.withAlphaComponent(0.2)
    } else {
      containerView.backgroundColor = .clear
    }
  }
  
}
