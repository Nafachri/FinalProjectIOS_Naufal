//
//  HistoryDetailViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import UIKit
import SnapKit
import TheNorthCoreDataManager


class HistoryDetailViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var uiView: UIView!
  @IBOutlet weak var avatar: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  
  weak var coordinator: HistoryDetailCoordinator!
  var selectedData: HistoryModel?
  
  // MARK: - Initializers
  init(coordinator: HistoryDetailCoordinator){
    self.coordinator = coordinator
    super.init(nibName: "HistoryDetailViewController", bundle: .module)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented" )
  }
  
  // MARK: - Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    title = "History Detail"
  }
  
  // MARK: - Private Methods
  private func setupUI() {
    setupContainerView()
    populateData()
  }
  
  private func setupContainerView() {
    uiView.snp.makeConstraints { make in
      make.height.equalTo(190)
    }
    uiView.layer.cornerRadius = 30
  }
  
  private func populateData() {
    let avatarName = selectedData?.contact?.avatar ?? "avatar-dummy"
    let username = selectedData?.contact?.username ?? "Unknown"
    let createdDate = selectedData?.created_date ?? "Unknown Date"
    let amount = selectedData?.amount ?? "0"
    let transactionType = selectedData?.type ?? "pay"
    
    avatar.image = UIImage(named: selectedData?.contact?.avatar ?? avatarName, in: .module, with: nil)
    nameLabel.text = username
    dateLabel.text = createdDate
    amountLabel.text = amount
    
    
    if transactionType == "pay" {
      amountLabel.text = "- \(amount)"
      uiView.backgroundColor = UIColor(hex: "#C20000")
    } else {
      amountLabel.text = "+ \(amount)"
      uiView.backgroundColor = UIColor(hex: "#266A61")
    }
  }
}
