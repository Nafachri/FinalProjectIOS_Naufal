//
//  HistoryViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import UIKit
import TheNorthCoreDataManager
import TNUI

class HistoryViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var tableView: UITableView!
  weak var coordinator: HistoryCoordinator?
   private let coreDataManager = CoreDataManager.shared
   private var historyDataArray: [HistoryModel] = []
   private lazy var emptyStateView: EmptyStateView = {
     let view = EmptyStateView(message: "No History Available")
     view.translatesAutoresizingMaskIntoConstraints = false
     return view
   }()

  
  // MARK: - Initializers
  init(coordinator: HistoryCoordinator?) {
    self.coordinator = coordinator
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
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: SuccessScreenViewController.chekcoutNotification, object: nil)
  }
  
  
  
  // MARK: - Private Methods
    private func setupViewController() {
      title = "History"
      setupTableView()
      setupEmptyStateView()
      fetchHistory()
      observeNotifications()
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
      updateUI()
    }
    
    private func fetchHistory() {
      do {
        historyDataArray = try coreDataManager.fetch(entity: HistoryModel.self)
        tableView.reloadData()
        updateUI()
      } catch {
        print("Failed to fetch history: \(error.localizedDescription)")
      }
    }
    
    private func observeNotifications() {
      NotificationCenter.default.addObserver(forName: SuccessScreenViewController.chekcoutNotification, object: nil, queue: .main) { [weak self] _ in
        self?.fetchHistory()
      }
    }
    
    private func updateUI() {
      let isEmpty = historyDataArray.isEmpty
      tableView.isHidden = isEmpty
      emptyStateView.isHidden = !isEmpty
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
    cell.populate(historyDataArray[indexPath.row])
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
