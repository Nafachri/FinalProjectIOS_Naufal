//
//  ContactsViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 07/08/24.
//

import UIKit

class ContactsViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  weak var coordinator: ContactsCoordinator!
  
  
  init(coordinator: ContactsCoordinator!){
    self.coordinator = coordinator
    super.init(nibName: "ContactsViewController", bundle: .module)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //  MARK: sample data array for cell
  var dataArray: [Contact] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    title = "contacts"
    tableView.register(UINib(nibName: "ContactsTableViewCell", bundle: .module), forCellReuseIdentifier: "contacts_cell")
    
    tableView.dataSource = self
    tableView.delegate = self
    tableView.reloadData()
    
    dataArray = [
      Contact(image: "contact-profile", name: "Mas Amin"),
      Contact(image: "contact-profile", name: "Mas Kholis"),
      Contact(image: "contact-profile", name: "Mas Nabhan"),
      Contact(image: "contact-profile", name: "Mas Halim"),
      Contact(image: "contact-profile", name: "Zhafran"),
      Contact(image: "contact-profile", name: "Rama"),
      Contact(image: "contact-profile", name: "Andre"),
    ]
  }
}
extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      dataArray.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "contacts_cell", for: indexPath) as! ContactsTableViewCell
    let contact = dataArray[indexPath.row]
    cell.populate(contact)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    coordinator.goToContactDetail()
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
