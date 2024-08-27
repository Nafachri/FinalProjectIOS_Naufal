//
//  MainOnBoardingViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 07/08/24.
//

import UIKit

// MARK: - MainOnBoardingViewController

class MainOnBoardingViewController: UIViewController {
  
  // MARK: - Outlets
  
  @IBOutlet weak var letsgoButton: UIButton!
  
  // MARK: - Properties
  
  weak var coordinator: MainOnBoardingCoordinator!
  
  // MARK: - Initializers
  
  init(coordinator: MainOnBoardingCoordinator!) {
    self.coordinator = coordinator
    super.init(nibName: "MainOnBoardingViewController", bundle: .module)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  // MARK: - UI Setup
  
  private func setupUI() {
    letsgoButton.layer.cornerRadius = 8
  }
  
  // MARK: - Actions
  
  @IBAction func letsgoButtonTapped(_ sender: UIButton) {
    coordinator.letsGo()
  }
}
