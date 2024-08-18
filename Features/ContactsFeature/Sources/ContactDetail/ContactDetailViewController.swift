//
//  ContactDetailViewController.swift
//  ContactsFeature
//
//  Created by Naufal Al-Fachri on 07/08/24.
//

import UIKit
import Dependency
import TheNorthCoreDataManager

class ContactDetailViewController: UIViewController {
  
  @IBOutlet weak var sendButton: UIButton!
  @IBOutlet weak var avatar: UIImageView!
  @IBOutlet weak var username: UILabel!
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var phoneNumber: UITextField!
  weak var coordinator: ContactDetailCoordinator!
  var selectedData: ContactModel?
  
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
      // TODO: Set Avatar
      username.text = selectedData?.username
      email.text = selectedData?.email
      phoneNumber.text = selectedData?.phoneNumber
    }
  
  func setupUI() {
    sendButton.layer.cornerRadius = 8
  }
  @IBAction func sendButtonTapped(_ sender: UIButton) {
    coordinator.goToPayment(with: selectedData!)
  }
}
