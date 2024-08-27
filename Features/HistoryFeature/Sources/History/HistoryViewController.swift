//
//  HistoryViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import UIKit
import TheNorthCoreDataManager
import TNUI
import NetworkManager
import RxSwift
import RxCocoa
import SkeletonView

class HistoryViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var tableView: UITableView!
  weak var coordinator: HistoryCoordinator?
  private let coreDataManager = CoreDataManager.shared
  private var historyDataArray: [TransactionResponse] = []
  private let disposeBag = DisposeBag()
  private let  viewModel: HistoryViewModel
  private lazy var emptyStateView: EmptyStateView = {
    let view = EmptyStateView(message: "No History Available")
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  
  // MARK: - Initializers
  init(coordinator: HistoryCoordinator?, viewModel: HistoryViewModel = HistoryViewModel()) {
    self.coordinator = coordinator
    self.viewModel = viewModel
    super.init(nibName: "HistoryViewController", bundle: .module)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViewController()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    viewModel.fetchHistory()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: SuccessScreenViewController.checkoutNotification, object: nil)
  }
  
  // MARK: - Private Methods
  private func setupViewController() {
    setupTableView()
    setupBinding()
    setupUI()
  }
  
  // MARK: - Setup UI
  private func setupUI() {
    title = "History"
    navigationController?.navigationBar.tintColor = .label
  }

  // MARK: - Setup Binding
   func setupBinding() {
    viewModel.historyData
      .subscribe(onNext: {[weak self] result in
        guard let self else {return}
        guard let transactionData = result?.transaction else {return}
        self.historyDataArray = transactionData
        DispatchQueue.main.async{
          self.tableView.reloadData()
        }
      }).disposed(by: disposeBag)
     
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
  

  
  private func setupTableView() {
    tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: .module), forCellReuseIdentifier: "history_cell")
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  private func setupEmptyStateView() {
    view.addSubview(emptyStateView)
    NSLayoutConstraint.activate([
      emptyStateView.topAnchor.constraint(equalTo: view.topAnchor),
      emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return historyDataArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "history_cell", for: indexPath) as? HistoryTableViewCell else {
      return UITableViewCell()
    }
    let history = historyDataArray[indexPath.row]
    cell.populate(history)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    coordinator?.goToHistoryDetail(with: historyDataArray[indexPath.row])
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

extension HistoryViewController: SkeletonTableViewDataSource {
  func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 6
  }
  
  func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
    return "history_cell"
  }
}
