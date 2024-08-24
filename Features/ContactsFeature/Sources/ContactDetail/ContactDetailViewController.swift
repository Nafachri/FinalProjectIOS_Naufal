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
    title = "Contact Detail"
    setupUI()
    configureView()
  }
  
  // MARK: - UI Setup
  private func setupUI() {
    sendButton.layer.cornerRadius = 8
    avatar.layer.cornerRadius = 26

  }
  
  private func configureView() {
    if let quickSend = quickSendData {
      let url = URL(string: quickSend.avatar ?? "contact-profile")
      username.text = quickSend.username
      email.text = quickSend.email
      phoneNumber.text = quickSend.phoneNumber
      avatar.kf.setImage(with: url)
      addToQuickSendButton.isHidden = true
    } else if let selectedItem = selectedData {
      let url = URL(string: selectedItem.avatar)
      username.text = selectedItem.name
      email.text = selectedItem.email
      phoneNumber.text = selectedItem.phoneNumber
      avatar.kf.setImage(with: url)
      addToQuickSendButton.isHidden = false
      
    }
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
    presentAddToQuickSendAlert()
  }
  
  // MARK: - Quick Send Management
  private func presentAddToQuickSendAlert() {
    let alert = UIAlertController(
      title: "Add to Quick Send",
      message: "Do you want to add this contact to Quick Send?",
      preferredStyle: .alert
    )
    
    alert.addAction(UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
      self?.addToQuickSend()
    })
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(alert, animated: true)
  }
  
  private func addToQuickSend() {
    let newItemProperties: [String: Any]
    
    if let quickSend = quickSendData {
      newItemProperties = [
        "id": quickSend.id ?? "",
        "avatar": quickSend.avatar ?? "",
        "username": quickSend.username ?? "",
        "email": quickSend.email ?? "",
        "phoneNumber": quickSend.phoneNumber ?? ""
      ]
    } else if let selectedItem = selectedData {
      newItemProperties = [
        "id": selectedItem.id,
        "avatar": selectedItem.avatar,
        "username": selectedItem.name,
        "email": selectedItem.email,
        "phoneNumber": selectedItem.phoneNumber
      ]
    } else {
      print("No data available to add to Quick Send.")
      return
    }
    
    do {
      var quickSendModel = try CoreDataManager.shared.fetch(entity: QuickSendModel.self)
      
      // Remove the oldest item if the count exceeds 6
      if quickSendModel.count >= 6, let lastItem = quickSendModel.last {
        try CoreDataManager.shared.delete(entity: lastItem)
        quickSendModel.removeLast()
      }
      
      let newItem: QuickSendModel
      if let _ = quickSendData {
        newItem = try CoreDataManager.shared.create(entity: QuickSendModel.self, properties: newItemProperties)
      } else {
        newItem = try CoreDataManager.shared.create(entity: QuickSendModel.self, properties: newItemProperties)
      }
      
      quickSendModel.insert(newItem, at: 0)
      
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "contactDetailVCNotificationCenter"), object: nil)
      presentSuccessAlert()
      
    } catch {
      print("Failed to add to Quick Send: \(error)")
    }
  }
  
  private func presentSuccessAlert() {
    let successAlert = UIAlertController(
      title: "Success",
      message: "The contact has been added to Quick Send.",
      preferredStyle: .alert
    )
    
    successAlert.addAction(UIAlertAction(title: "OK", style: .default))
    present(successAlert, animated: true)
  }
}
