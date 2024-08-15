//
//  ProfileViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 02/08/24.
//

import UIKit
import Services
import RxSwift
import RxRelay

class ProfileViewController: UIViewController {
  var disposeBag = DisposeBag()
  var viewModel: ProfileViewModel
  @IBOutlet weak var topUpButton: UIButton!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var phoneNumberField: UITextField!
  @IBOutlet weak var editButton: UIButton!
  @IBOutlet weak var confirmButton: UIButton!
  weak var coordinator: ProfileCoordinator!
  
  
  init(coordinator: ProfileCoordinator!, viewModel: ProfileViewModel = ProfileViewModel(profile: ProfileService())) {
    self.coordinator = coordinator
    self.viewModel = viewModel
    super.init(nibName: "ProfileViewController", bundle: .module)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    title = "profiles"
  }
  
  func setupUI() {
    topUpButton.layer.cornerRadius = 10
    emailField.isEnabled = false
    phoneNumberField.isEnabled = false
    editButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
  }
  @IBAction func editButtonTapped(_ sender: UIButton) {
    editButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
    emailField.isEnabled = true
    phoneNumberField.isEnabled = true
    confirmButton.isHidden = false
  }
  @IBAction func confirmButtonTapped(_ sender: UIButton) {
    editButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
    emailField.isEnabled = false
    phoneNumberField.isEnabled = false
    confirmButton.isHidden = true
  }
}
