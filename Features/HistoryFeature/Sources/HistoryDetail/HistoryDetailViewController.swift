//
//  HistoryDetailViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import UIKit
import SnapKit
import TheNorthCoreDataManager
import NetworkManager
import Utils
import Kingfisher


class HistoryDetailViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var uiView: UIView!
  @IBOutlet weak var avatar: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  
  weak var coordinator: HistoryDetailCoordinator!
  var selectedData: TransactionResponse?
  
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
    avatar.layer.cornerRadius = avatar.frame.size.width / 2
    avatar.clipsToBounds = true
    

  }
  
  private func setupContainerView() {
    uiView.snp.makeConstraints { make in
      make.height.equalTo(190)
    }
    uiView.layer.cornerRadius = 30
  }
  
  private func populateData() {
    if selectedData?.type == "topup" {
      uiView.backgroundColor = UIColor(hex: "#266A61")
    } else {
      uiView.backgroundColor = UIColor(hex: "#C20000")
    }
    
    let url = URL(string: selectedData?.avatar ?? "avatar-detail-dummy")
    let createdDate = selectedData?.timestamp
    let amount = selectedData?.amount
    nameLabel.text = selectedData?.name
    avatar.kf.setImage(with: url)
    dateLabel.text = createdDate
    amountLabel.text = amount
    
  }
}
