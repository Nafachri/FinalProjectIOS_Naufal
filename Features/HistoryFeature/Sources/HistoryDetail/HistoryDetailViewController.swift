//
//  HistoryDetailViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import UIKit
import SnapKit


class HistoryDetailViewController: UIViewController {
  
  @IBOutlet weak var uiView: UIView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  
  weak var coordinator: HistoryDetailCoordinator!
  
  init(coordinator: HistoryDetailCoordinator){
    self.coordinator = coordinator
    super.init(nibName: "HistoryDetailViewController", bundle: .module)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented" )
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  func setupUI() {
    uiView.snp.makeConstraints { make in
      make.height.equalTo(190)
    }
    uiView.layer.cornerRadius = 30
  }
}
