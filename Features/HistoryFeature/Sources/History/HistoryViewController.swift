//
//  HistoryViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import UIKit

class HistoryViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  weak var coordinator: HistoryCoordinator!
  
  init(coordinator: HistoryCoordinator!) {
    self.coordinator = coordinator
    super.init(nibName: "HistoryViewController", bundle: .module)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //  MARK: sample data array for cell
  var dataArray: [History] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: .module), forCellReuseIdentifier: "history_cell")
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.reloadData()
    
    
    title = "history"
    
    dataArray = [
      History(image: "avatar-dummy", name: "Kholis", date: "13/08/2024", amount: "- IDR 24.000"),
      History(image: "avatar-dummy", name: "Bambang", date: "13/08/2024", amount: "+ IDR 500.000"),
      History(image: "avatar-dummy", name: "Umar", date: "13/08/2024", amount: "- IDR 50.000.000"),
      History(image: "avatar-dummy", name: "Aisyah", date: "13/08/2024", amount: "+ IDR 20.000"),
      History(image: "avatar-dummy", name: "Japran", date: "13/08/2024", amount: "- IDR 15.000"),
    ]
  }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "history_cell", for: indexPath) as! HistoryTableViewCell
    let history = dataArray[indexPath.row]
    cell.populate(history)
    
  
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    coordinator.goToHistoryDetail()
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
