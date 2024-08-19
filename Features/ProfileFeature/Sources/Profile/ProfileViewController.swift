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
import TheNorthCoreDataManager

class ProfileViewController: UIViewController {
  var disposeBag = DisposeBag()
  var viewModel: ProfileViewModel
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var phoneNumberField: UITextField!
  @IBOutlet weak var editButton: UIButton!
  @IBOutlet weak var confirmButton: UIButton!
  weak var coordinator: ProfileCoordinator!
  let coreDataManager = CoreDataManager.shared
  var userData: [UserModel] = []
  
  
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
    fetchUser()
    title = "profiles"
  }
  
  func setupUI() {
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
  
  private func fetchUser() {

      do {
          // Fetch the data from Core Data
        userData = try coreDataManager.fetch(entity: UserModel.self)
          
          // Print the fetched user data for debugging
          for user in userData {
            emailField.text = user.email
            phoneNumberField.text = user.phoneNumber
            usernameLabel.text = user.username
          }
          
      } catch {
          print("Failed to fetch users: \(error.localizedDescription)")
      }
  }

}
