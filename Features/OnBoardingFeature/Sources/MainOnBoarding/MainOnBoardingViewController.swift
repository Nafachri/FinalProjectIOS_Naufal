//
//  MainOnBoardingViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 07/08/24.
//

import UIKit

class MainOnBoardingViewController: UIViewController {
  
  @IBOutlet weak var letsgoButton: UIButton!
  weak var coordinator: MainOnBoardingCoordinator!
  
  init(coordinator: MainOnBoardingCoordinator!){
    self.coordinator = coordinator
    super.init(nibName: "MainOnBoardingViewController", bundle: .module)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

    override func viewDidLoad() {
        super.viewDidLoad()
      letsgoButton.layer.cornerRadius = 8
      
 
    }
  @IBAction func letsgoButtonTapped(_ sender: UIButton) {
    coordinator.letsGo()
  }
}
