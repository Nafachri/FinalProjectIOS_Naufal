//
//  ContactsViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 07/08/24.
//

import UIKit
import Dependency
import TheNorthCoreDataManager
import TNUI
import NetworkManager
import RxSwift
import RxCocoa
import RxRelay


class ContactsViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var tableView: UITableView!
  
  weak var coordinator: ContactsCoordinator!
  private var dataArray: ListContactResponse = []
  private let disposeBag = DisposeBag()
  private var emptyStateView: EmptyStateView?
  private let coreDataManager = CoreDataManager.shared
  let viewModel: ContactsViewModel
  
  
  
  // MARK: - Initializers
  init(coordinator: ContactsCoordinator, viewModel: ContactsViewModel = ContactsViewModel()) {
    self.viewModel = viewModel
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
    setupBinding()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    viewModel.fetchContact()
  }
  
  // MARK: - UI Setup
  private func setupUI() {
    title = "Contacts"
    tableView.register(UINib(nibName: "ContactsTableViewCell", bundle: .module), forCellReuseIdentifier: "contacts_cell")
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  // MARK: - Setup Binding
  func setupBinding(){
    viewModel.listOfContact
      .subscribe(onNext: {[weak self] result in
        guard let self else {return}
        self.dataArray = result
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      })
      .disposed(by: disposeBag)
  }
  
  // MARK: - Core Data Operations
  private func deleteContact(_ contact: ContactModel) {
    do {
      try coreDataManager.delete(entity: contact)
    } catch {
      print("Failed to delete contact: \(error.localizedDescription)")
    }
  }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
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
