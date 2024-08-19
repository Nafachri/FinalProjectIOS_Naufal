//
//  ContactsViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 07/08/24.
//

import UIKit
import Dependency
import TheNorthCoreDataManager


class ContactsViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var tableView: UITableView!
  
  weak var coordinator: ContactsCoordinator!
  private var dataArray: [ContactModel] = []
  private let coreDataManager = CoreDataManager.shared
  
  
  // MARK: - Initializers
  init(coordinator: ContactsCoordinator) {
    self.coordinator = coordinator
    super.init(nibName: "ContactsViewController", bundle: .module)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    fetchContacts()
  }
  
  // MARK: - UI Setup
  private func setupUI() {
    title = "Contacts"
    tableView.register(UINib(nibName: "ContactsTableViewCell", bundle: .module), forCellReuseIdentifier: "contacts_cell")
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  // MARK: - Core Data Operations
  private func deleteContact(_ contact: ContactModel) {
    do {
      try coreDataManager.delete(entity: contact)
    } catch {
      print("Failed to delete contact: \(error.localizedDescription)")
    }
  }
  
  private func fetchContacts() {
    do {
      dataArray = try coreDataManager.fetch(entity: ContactModel.self)
      tableView.reloadData()
    } catch {
      print("Failed to fetch contacts: \(error.localizedDescription)")
    }
  }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else { return }
    
    let contactToDelete = dataArray[indexPath.row]
    deleteContact(contactToDelete)
    
    dataArray.remove(at: indexPath.row)
    tableView.deleteRows(at: [indexPath], with: .automatic)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "contacts_cell", for: indexPath) as! ContactsTableViewCell
    let contact = dataArray[indexPath.row]
    cell.populate(with: contact)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedContact = dataArray[indexPath.row]
    coordinator.goToContactDetail(with: selectedContact)
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
