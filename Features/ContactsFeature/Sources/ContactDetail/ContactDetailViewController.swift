//
//  ContactDetailViewController.swift
//  ContactsFeature
//
//  Created by Naufal Al-Fachri on 07/08/24.
//

import UIKit

class ContactDetailViewController: UIViewController {
  
  @IBOutlet weak var sendButton: UIButton!
  weak var coordinator: ContactDetailCoordinator!
  
  init(coordinator: ContactDetailCoordinator!){
    self.coordinator = coordinator
    super.init(nibName: "ContactDetailViewController", bundle: .module)
  }
  
  required init?(coder: NSCoder){
    fatalError("init(coder:) has not been implemented")
  }

    override func viewDidLoad() {
        super.viewDidLoad()
      title = "contact detail"
      setupUI()
    }
  
  func setupUI() {
    sendButton.layer.cornerRadius = 8
  }
  @IBAction func sendButtonTapped(_ sender: UIButton) {
    coordinator.goToPayment()
  }
}
