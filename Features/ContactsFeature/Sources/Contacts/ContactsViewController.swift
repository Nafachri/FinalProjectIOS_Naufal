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
import SkeletonView
import SnapKit


class ContactsViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var tableView: UITableView!
  
  weak var coordinator: ContactsCoordinator!
  private var dataArray: ListContactResponse = []
  private let disposeBag = DisposeBag()
  private let coreDataManager = CoreDataManager.shared
  let viewModel: ContactsViewModel
  
  private lazy var emptyStateView: EmptyStateView = {
    let view = EmptyStateView(message: "No Contacts Available")
    return view
  }()
  
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
    viewModel.fetchContacts()
  }
  
  // MARK: - UI Setup
  private func setupUI() {
    title = "Contacts"
    tableView.register(UINib(nibName: "ContactsTableViewCell", bundle: .module), forCellReuseIdentifier: "contacts_cell")
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  private func setupEmptyStateView() {
    view.addSubview(emptyStateView)
    emptyStateView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  

  
  private func hideEmptyStateView() {
    emptyStateView.isHidden = true
  }
  
  // MARK: - ViewModel Binding
  private func setupBinding() {
    viewModel.listOfContact
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] result in
        self?.updateUI(with: result)
      })
      .disposed(by: disposeBag)
    
    viewModel.isLoading.asObservable().subscribe(onNext: {[weak self] isLoading in
      guard let self = self else { return }
      switch isLoading {
      case .loading:
        self.tableView.showAnimatedGradientSkeleton()
      default:
        self.tableView.hideSkeleton()
      }
    }).disposed(by: disposeBag)
  }
  
  
  
  // MARK: - UI Update
  private func updateUI(with contacts: ListContactResponse) {
    self.dataArray = contacts    
    tableView.reloadData()
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
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "contacts_cell", for: indexPath) as? ContactsTableViewCell else {
      return UITableViewCell()
    }
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

extension ContactsViewController: SkeletonTableViewDataSource {
  func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 6
  }
  
  func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
    return "contacts_cell"
  }
}
