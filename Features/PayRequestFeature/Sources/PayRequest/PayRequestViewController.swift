//
//  PayRequestViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 03/08/24.
//

import UIKit

class PayRequestViewController: UIViewController {
  
  weak var coordinator: PayRequestCoordinator!
  
  init(coordinator: PayRequestCoordinator!){
    self.coordinator = coordinator
    super.init(nibName: "PayRequestViewController", bundle: .module)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
