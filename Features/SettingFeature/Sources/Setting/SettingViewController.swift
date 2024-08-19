//
//  SettingViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 02/08/24.
//

import UIKit
import KeychainSwift
import TheNorthCoreDataManager

class SettingViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var tableView: UITableView!
  weak var coordinator: SettingCoordinator!
  private let keychain = KeychainSwift()
  private let coreData = CoreDataManager.shared
  
  // MARK: - Initializer
  init(coordinator: SettingCoordinator!) {
    self.coordinator = coordinator
    super.init(nibName: "SettingViewController", bundle: .module)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    title = "Settings"
  }
  
  // MARK: - Private Methods
  private func setupTableView() {
    tableView.register(UINib(nibName: "SettingTableViewCell", bundle: .module), forCellReuseIdentifier: "setting_cell")
    tableView.register(UINib(nibName: "SignOutTableViewCell", bundle: .module), forCellReuseIdentifier: "signout_cell")
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  private func showSignOutAlert() {
    let alert = UIAlertController(title: "Are you sure?", message: "Are you sure you want to sign out?", preferredStyle: .alert)
    let confirmAction = UIAlertAction(title: "Confirm", style: .destructive) { [weak self] _ in
      self?.signOut()
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alert.addAction(confirmAction)
    alert.addAction(cancelAction)
    present(alert, animated: true)
  }
  
  private func signOut() {
    do {
      try deleteUserData()
      removeTokenFromKeychain()
      coordinator.showOnBoarding()
    } catch {
      print("Failed to sign out: \(error.localizedDescription)")
    }
  }
  
  private func deleteUserData() throws {
    let users = try coreData.fetch(entity: UserModel.self)
    for user in users {
      try coreData.delete(entity: user)
    }
  }
  
  private func removeTokenFromKeychain() {
    keychain.delete("userToken")
  }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0 {
      let settingCell = tableView.dequeueReusableCell(withIdentifier: "setting_cell", for: indexPath) as! SettingTableViewCell
      return settingCell
    } else {
      let signOutCell = tableView.dequeueReusableCell(withIdentifier: "signout_cell", for: indexPath) as! SignOutTableViewCell
      return signOutCell
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 1 {
      showSignOutAlert()
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
