//
//  ContactDetailViewController.swift
//  ContactsFeature
//
//  Created by Naufal Al-Fachri on 07/08/24.
//

import UIKit
import Dependency
import TheNorthCoreDataManager
import NetworkManager

class ContactDetailViewController: UIViewController {
  
  // MARK: - Outlets
  @IBOutlet weak var addToQuickSendButton: UIButton!
  @IBOutlet weak var sendButton: UIButton!
  @IBOutlet weak var avatar: UIImageView!
  @IBOutlet weak var username: UILabel!
  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var phoneNumber: UITextField!
  
  // MARK: - Properties
  weak var coordinator: ContactDetailCoordinator!
  var quickSendModel: [QuickSendModel] = []
  var quickSendData: QuickSendModel?
  var selectedData: ListContactResponseData?
  
  // MARK: - Initialization
  init(coordinator: ContactDetailCoordinator) {
    self.coordinator = coordinator
    super.init(nibName: "ContactDetailViewController", bundle: .module)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    configureViewWithData()
  }
  
  // MARK: - UI Setup
  private func setupUI() {
    title = "Contact Detail"
    navigationController?.navigationBar.tintColor = .label
    setupUIElements()
  }
  
  private func setupUIElements() {
    sendButton.layer.cornerRadius = 8
    avatar.layer.cornerRadius = avatar.frame.size.width / 2
    avatar.clipsToBounds = true
  }
  
  private func configureViewWithData() {
    if let quickSend = quickSendData {
      configureView(with: quickSend)
      setAddToQuickSendButton(icon: "minus.square.fill")
    } else if let selectedItem = selectedData {
      configureView(with: selectedItem)
      setAddToQuickSendButton(icon: "plus.bubble.fill")
    }
  }
  
  
  private func configureView(with quickSend: QuickSendModel) {
    avatar.kf.setImage(with: URL(string: quickSend.avatar ?? "contact-profile"))
    username.text = quickSend.username
    email.text = quickSend.email
    phoneNumber.text = quickSend.phoneNumber
  }
  
  private func configureView(with selectedItem: ListContactResponseData) {
    avatar.kf.setImage(with: URL(string: selectedItem.avatar))
    username.text = selectedItem.name
    email.text = selectedItem.email
    phoneNumber.text = selectedItem.phoneNumber
  }
  
  private func setAddToQuickSendButton(icon: String) {
    addToQuickSendButton.setImage(UIImage(systemName: icon), for: .normal)
  }
  
  
  // MARK: - Actions
  @IBAction func sendButtonTapped(_ sender: UIButton) {
    if let quickSend = quickSendData {
      coordinator.goToPayment(quickSendData: quickSend)
    } else if let selectedItem = selectedData {
      coordinator.goToPayment(with: selectedItem)
    } else {
      print("No data available to proceed with payment.")
    }
  }
  
  @IBAction func addToQuickSendButtonTapped(_ sender: UIButton) {
    let alertTitle = quickSendData != nil ? "Remove contact" : "Add contact to Quick Send"
    let alertMessage = quickSendData != nil ? "Remove contact from Quick Send?" : "Add contact to Quick Send?"
    presentAddToQuickSendAlert(title: alertTitle, message: alertMessage)
  }
  
  // MARK: - Quick Send Management
  private func presentAddToQuickSendAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
      self?.manageQuickSend()
    })
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(alert, animated: true)
  }
  
  private func manageQuickSend() {
    quickSendData != nil ? removeFromQuickSend() : addToQuickSend()
  }
  
  private func addToQuickSend() {
    do {
      let quickSendModel = try CoreDataManager.shared.fetch(entity: QuickSendModel.self)
      
      guard let selectedItem = selectedData else {
        print("No data available to add to Quick Send.")
        return
      }
      
      if quickSendModel.contains(where: { $0.id == selectedItem.id }) {
        presentErrorAlert(message: "Contact already exists in Quick Send")
        return
      }
      
      if quickSendModel.count >= 6, let lastItem = quickSendModel.last {
        try CoreDataManager.shared.delete(entity: lastItem)
      }
      
      let newItemProperties: [String: Any] = [
        "id": selectedItem.id,
        "avatar": selectedItem.avatar,
        "username": selectedItem.name,
        "email": selectedItem.email,
        "phoneNumber": selectedItem.phoneNumber
      ]
      
      _ = try CoreDataManager.shared.create(entity: QuickSendModel.self, properties: newItemProperties)
      NotificationCenter.default.post(name: .contactDetailUpdate, object: nil)
      presentSuccessAlert(message: "The contact has been added to Quick Send.")
    } catch {
      print("Failed to add to Quick Send: \(error)")
    }
  }
  
  private func removeFromQuickSend() {
    guard let quickSend = quickSendData else { return }
    
    do {
      try CoreDataManager.shared.delete(entity: quickSend)
      NotificationCenter.default.post(name: .contactDetailUpdate, object: nil)
      presentSuccessAlert(message: "The contact has been removed from Quick Send.")
    } catch {
      print("Failed to remove from Quick Send: \(error)")
    }
  }
  
  // MARK: - Alerts
  private func presentSuccessAlert(message: String) {
    presentAlert(title: "Success", message: message)
  }
  
  private func presentErrorAlert(message: String) {
    presentAlert(title: "Error", message: message)
  }
  
  private func presentAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default))
    present(alertController, animated: true)
  }
}

// MARK: - Notification Extension
extension Notification.Name {
  static let contactDetailUpdate = Notification.Name(rawValue: "contactDetailVCNotificationCenter")
}
