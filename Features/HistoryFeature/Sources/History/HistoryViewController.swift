//
//  HistoryViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import UIKit
import TheNorthCoreDataManager

class HistoryViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  weak var coordinator: HistoryCoordinator!
  var coredata = CoreDataManager.shared
  
  init(coordinator: HistoryCoordinator!) {
    self.coordinator = coordinator
    super.init(nibName: "HistoryViewController", bundle: .module)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //  MARK: sample data array for cell
  var historyDataArray: [HistoryModel] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: .module), forCellReuseIdentifier: "history_cell")
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.reloadData()
    
    
    title = "history"
//    
//    dataArray = [
//      History(image: "avatar-dummy", name: "Kholis", date: "13/08/2024", amount: "- IDR 24.000"),
//      History(image: "avatar-dummy", name: "Bambang", date: "13/08/2024", amount: "+ IDR 500.000"),
//      History(image: "avatar-dummy", name: "Umar", date: "13/08/2024", amount: "- IDR 50.000.000"),
//      History(image: "avatar-dummy", name: "Aisyah", date: "13/08/2024", amount: "+ IDR 20.000"),
//      History(image: "avatar-dummy", name: "Japran", date: "13/08/2024", amount: "- IDR 15.000"),
//    ]
  }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return historyDataArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "history_cell", for: indexPath) as! HistoryTableViewCell
    let history = historyDataArray[indexPath.row]
    cell.populate(history)
    
  
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedData = historyDataArray[indexPath.row]
    coordinator.goToHistoryDetail(with: selectedData)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  private func fetchHistory() {
      do {
          historyDataArray = try coredata.fetch(entity: HistoryModel.self)
          tableView.reloadData()
      } catch {
          print("Failed to fetch contacts: \(error.localizedDescription)")
      }
  }
}
