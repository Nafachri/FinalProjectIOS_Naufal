//
//  ProfileViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 02/08/24.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa
import TheNorthCoreDataManager
import NetworkManager
import Kingfisher

class ProfileViewController: UIViewController {
  var disposeBag = DisposeBag()
  var viewModel: ProfileViewModel
  @IBOutlet weak var avatar: UIImageView!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var phoneNumberField: UITextField!
  @IBOutlet weak var editButton: UIButton!
  @IBOutlet weak var confirmButton: UIButton!
  weak var coordinator: ProfileCoordinator!
  let coreDataManager = CoreDataManager.shared
  var userData: ProfileResponse?
  
  
  init(coordinator: ProfileCoordinator!, viewModel: ProfileViewModel = ProfileViewModel()) {
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
    setupBinding()
    title = "profiles"
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    viewModel.fetchProfile()
  }
  
  func setupUI() {
    emailField.isEnabled = false
    phoneNumberField.isEnabled = false
    editButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
  }
  
  func setupBinding() {
    viewModel.profileData
      .subscribe(onNext: { [weak self] result in
        guard let self else {return}
        guard let profileData = result else {return}
        self.userData = profileData
        let url = URL(string: profileData.avatar)
        self.avatar.kf.setImage(with: url)        
        self.usernameLabel.text = profileData.name
        self.emailField.text = profileData.email
        self.phoneNumberField.text = profileData.phoneNumber
      })
      .disposed(by: disposeBag)
    viewModel.isSuccessUpdate
      .subscribe(onNext: { [weak self] isSuccess in
        guard let self, isSuccess else { return }
        if isSuccess == true {
          viewModel.fetchProfile()
        }
      }).disposed(by: disposeBag)
    
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
    
    viewModel.uploadProfileData(param: ProfileParam(username: usernameLabel.text, phoneNumber: phoneNumberField.text, email: emailField.text, avatar: UIImage(named: "profileavatar")))
  }
}
