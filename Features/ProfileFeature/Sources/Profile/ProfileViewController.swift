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
  
  // MARK: - Properties
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
  
  private let activityIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .large)
    indicator.color = .systemGreen
    indicator.translatesAutoresizingMaskIntoConstraints = false
    return indicator
  }()
  
  private let loadingOverlay: UIView = {
    let overlay = UIView()
    overlay.backgroundColor = UIColor.systemBackground
    overlay.translatesAutoresizingMaskIntoConstraints = false
    overlay.isHidden = true
    return overlay
  }()
  
  // MARK: - Initializers
  init(coordinator: ProfileCoordinator!, viewModel: ProfileViewModel = ProfileViewModel()) {
    self.coordinator = coordinator
    self.viewModel = viewModel
    super.init(nibName: "ProfileViewController", bundle: .module)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupBinding()
    setupAction()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.fetchProfile()
  }
  
  // MARK: - UI Setup
  func setupUI() {
    title = "Profiles"
    avatar.layer.cornerRadius = avatar.frame.size.width / 2
    avatar.clipsToBounds = true
    avatar.contentMode = .scaleToFill
    emailField.isEnabled = false
    phoneNumberField.isEnabled = false
    editButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
    
    view.addSubview(loadingOverlay)
    loadingOverlay.addSubview(activityIndicator)
    
    NSLayoutConstraint.activate([
      loadingOverlay.topAnchor.constraint(equalTo: view.topAnchor),
      loadingOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      loadingOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      loadingOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      activityIndicator.centerXAnchor.constraint(equalTo: loadingOverlay.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: loadingOverlay.centerYAnchor)
    ])
  }
  
  // MARK: - Binding
  func setupBinding() {
    viewModel.profileData
      .subscribe(onNext: { [weak self] result in
        guard let self = self else { return }
        guard let profileData = result else { return }
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
        guard let self = self, isSuccess else { return }
        self.viewModel.fetchProfile()
      })
      .disposed(by: disposeBag)
    
    viewModel.isLoading
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] isLoading in
        guard let self = self else { return }
        self.loadingOverlay.isHidden = !isLoading
        if isLoading {
          self.activityIndicator.startAnimating()
        } else {
          self.activityIndicator.stopAnimating()
        }
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - Actions
  private func setupAction() {
    editButton.rx.tap.subscribe { [weak self] _ in
      guard let self = self else { return }
      self.editButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
      self.emailField.isEnabled = true
      self.phoneNumberField.isEnabled = true
      self.confirmButton.isHidden = false
      
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeProfilePicture))
      self.avatar.addGestureRecognizer(tapGesture)
      self.avatar.isUserInteractionEnabled = true
    }
    .disposed(by: disposeBag)
    
    confirmButton.rx.tap.subscribe { [weak self] _ in
      guard let self = self else { return }
      self.editButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
      self.emailField.isEnabled = false
      self.phoneNumberField.isEnabled = false
      self.confirmButton.isHidden = true
      
      self.avatar.isUserInteractionEnabled = false
      self.viewModel.uploadProfileData(param: ProfileParam(
        username: usernameLabel.text,
        phoneNumber: phoneNumberField.text,
        email: emailField.text,
        avatar: avatar.image ?? UIImage()
      ))
    }
    .disposed(by: disposeBag)
  }
  
  // MARK: - Profile Picture
  @objc func changeProfilePicture() {
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    imagePickerController.sourceType = .photoLibrary
    imagePickerController.allowsEditing = true
    present(imagePickerController, animated: true)
  }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let editedImage = info[.editedImage] as? UIImage {
      avatar.image = editedImage
    } else if let originalImage = info[.originalImage] as? UIImage {
      avatar.image = originalImage
    }
    dismiss(animated: true)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true)
  }
}
