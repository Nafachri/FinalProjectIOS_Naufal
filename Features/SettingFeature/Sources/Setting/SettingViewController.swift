//
//  SettingViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 02/08/24.
//

import UIKit

class SettingViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  weak var coordinator: SettingCoordinator!
  
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
      tableView.dataSource = self
      tableView.delegate = self
      
    title = "settings"
    }
}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "setting_cell", for: indexPath) as! SettingTableViewCell
      
        return cell
    }
  
}
