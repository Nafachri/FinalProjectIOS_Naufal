//
//  SettingViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 02/08/24.
//

import UIKit
import KeychainSwift

class SettingViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  weak var coordinator: SettingCoordinator!
  var keychain = KeychainSwift()
  
  init(coordinator: SettingCoordinator!){
    self.coordinator = coordinator
    super.init(nibName: "SettingViewController", bundle: .module)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
        super.viewDidLoad()
      
    tableView.register(UINib(nibName: "SettingTableViewCell", bundle: .module), forCellReuseIdentifier: "setting_cell")
    tableView.register(UINib(nibName: "SignOutTableViewCell", bundle: .module), forCellReuseIdentifier: "signout_cell")
      tableView.dataSource = self
      tableView.delegate = self
      
    title = "settings"
    }
}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    return UITableView.automaticDimension
    return 100
  }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      if indexPath.row == 0 {
        let settingCell = tableView.dequeueReusableCell(withIdentifier: "setting_cell", for: indexPath) as! SettingTableViewCell
        return settingCell

      }
      else {
        let signOutCell = tableView.dequeueReusableCell(withIdentifier: "signout_cell", for: indexPath) as! SignOutTableViewCell
      
        return signOutCell
      }
    }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.row == 1 {
      showAlert(message: "are you sure want to to sign out?")
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func showAlert(message: String) {
    let alert = UIAlertController(title: "Are you sure?", message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "Confirm", style: .default) {_ in
      self.dismiss(animated: true) { [weak self] in
        guard let self else { return }
        coordinator.showOnBoarding()
        keychain.delete("userToken")
      }
    }
    alert.addAction(action)
    present(alert, animated: true)
  }
}
