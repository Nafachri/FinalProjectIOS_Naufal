// HomeViewController.swift
// The North
//
// Created by Naufal Al-Fachri on 08/08/24.
//

import UIKit
import SnapKit
import TNUI
import TheNorthCoreDataManager
import NetworkManager
import RxSwift
import RxRelay
import Utils

class HomeViewController: UIViewController {
  
  // MARK: - IBOutlets
  @IBOutlet weak var greetingLabel: UILabel!
  @IBOutlet weak var fullnameLabel: UILabel!
  @IBOutlet weak var userBalanceLabel: UILabel!
  @IBOutlet weak var settingButton: UIButton!
  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var topUpButton: UIButton!
  @IBOutlet weak var requestButton: UIButton!
  @IBOutlet weak var payButton: UIButton!
  @IBOutlet weak var contactCollectionView: UICollectionView!
  @IBOutlet weak var historyCollectionView: UICollectionView!
  
  private let activityIndicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView(style: .large)
    indicator.color = .systemGreen
    indicator.translatesAutoresizingMaskIntoConstraints = false
    return indicator
  }()
  
  private let loadingOverlay: UIView = {
    let overlay = UIView()
    overlay.backgroundColor = UIColor.systemBackground
    overlay.translatesAutoresizingMaskIntoConstraints = false
    overlay.isHidden = true
    return overlay
  }()
  
  // MARK: - Properties
  weak var coordinator: HomeCoordinator?
  private let viewModel: HomeViewModel
  private var historyDataArray: [TransactionResponse] = []
  private var quickSendDataArray: [QuickSendModel] = []
  private var userData: ProfileResponse?
  private var coreDataManager = CoreDataManager.shared
  private var emptyStateView: EmptyStateView?
  private var emptyStateViewQuickSend: EmptyStateView?
  private let disposeBag = DisposeBag()
  
  // MARK: - Initializers
  init(coordinator: HomeCoordinator, viewModel: HomeViewModel = HomeViewModel()) {
    self.coordinator = coordinator
    self.viewModel = viewModel
    super.init(nibName: "HomeViewController", bundle: .module)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupBinding()
    navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    viewModel.fetchProfile()
    viewModel.fetchHistory()
    fetchQuickSendData()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    applyCornerRadiusToTopView()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: SuccessScreenViewController.checkoutNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name("contactDetailVCNotificationCenter"), object: nil)
  }
  
  // MARK: - UI Setup
  private func setupUI() {
    greetingLabel.setGreeting()
    setupCollectionView()
    setupObservers()
    [topUpButton, requestButton, payButton].forEach {
      $0?.layer.cornerRadius = 8
    }
    
    view.addSubview(loadingOverlay)
    loadingOverlay.addSubview(activityIndicator)
    
    NSLayoutConstraint.activate([
      loadingOverlay.topAnchor.constraint(equalTo: view.topAnchor),
      loadingOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      loadingOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      loadingOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      activityIndicator.centerXAnchor.constraint(equalTo: loadingOverlay.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: loadingOverlay.centerYAnchor)
    ])
  }
  
  // MARK: - Setup Binding
  func setupBinding() {
    viewModel.profileData
      .asDriver(onErrorJustReturn: nil)
      .drive(onNext: { [weak self] result in
        guard let self = self else { return }
        guard let profileData = result else { return }
        self.userData = profileData
        self.fullnameLabel.text = profileData.fullName
        self.userBalanceLabel.text = profileData.balance
      })
      .disposed(by: disposeBag)
    
    viewModel.historyData
      .subscribe(onNext: { [weak self] result in
        guard let self = self else { return }
        guard let historyData = result?.transaction else { return }
        
        let sortedTransactions = historyData.sorted { $0.timestamp > $1.timestamp }
        let recentTransactions = Array(sortedTransactions.prefix(5))
        
        self.historyDataArray = recentTransactions
        DispatchQueue.main.async {
          self.historyCollectionView.reloadData()
        }
      })
      .disposed(by: disposeBag)
    
    viewModel.isLoading
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] isLoading in
        guard let self = self else { return }
        if isLoading {
          self.loadingOverlay.isHidden = false
          self.activityIndicator.startAnimating()
          
          self.hideEmptyStateView()
          self.hideEmptyStateViewQuickSend()
        } else {
          self.loadingOverlay.isHidden = true
          self.activityIndicator.stopAnimating()
          
          DispatchQueue.main.async {
            self.historyCollectionView.reloadData()
            
            if self.historyDataArray.isEmpty {
              self.showEmptyStateView(for: self.historyCollectionView, message: "No History Available")
            } else {
              self.hideEmptyStateView()
            }
            
          }
        }
      }).disposed(by: disposeBag)
  }
  
  private func applyCornerRadiusToTopView() {
    let cornerRadius: CGFloat = 20.0
    let path = UIBezierPath(roundedRect: topView.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
    let maskLayer = CAShapeLayer()
    maskLayer.path = path.cgPath
    topView.layer.mask = maskLayer
  }
  
  // MARK: - Collection View Setup
  private func setupCollectionView() {
    contactCollectionView.register(UINib(nibName: "AddQuickSendCollectionViewCell", bundle: .module), forCellWithReuseIdentifier: "quicksend_cell")
    historyCollectionView.register(UINib(nibName: "HistoryCollectionViewCell", bundle: .module), forCellWithReuseIdentifier: "history_cell")
    
    contactCollectionView.dataSource = self
    contactCollectionView.delegate = self
    historyCollectionView.dataSource = self
    historyCollectionView.delegate = self
  }
  
  // MARK: - Notification Observers
  private func setupObservers() {
    NotificationCenter.default.addObserver(forName: SuccessScreenViewController.checkoutNotification, object: nil, queue: .main) { [weak self] _ in
      guard let self = self else { return }
      self.viewModel.fetchHistory()
      self.viewModel.fetchProfile()
    }
    NotificationCenter.default.addObserver(self, selector: #selector(fetchQuickSendContacts), name: NSNotification.Name("contactDetailVCNotificationCenter"), object: nil)
  }
  
  // MARK: - Data Fetching
  private func fetchQuickSendData() {
    fetchQuickSendContacts(Notification(name: Notification.Name("contactDetailVCNotificationCenter")))
  }
  
  @objc private func fetchQuickSendContacts(_ notification: Notification) {
    do {
      quickSendDataArray = try coreDataManager.fetch(entity: QuickSendModel.self, fetchLimit: 5)
      if !quickSendDataArray.isEmpty {
        self.hideEmptyStateViewQuickSend()
      } else {
        self.showEmptyStateViewQuickSend(for: self.contactCollectionView, message: "No Quick Send Available")
      }
      contactCollectionView.reloadData()
    } catch {
      print("Failed to fetch contacts: \(error.localizedDescription)")
    }
  }
  
  // MARK: - Empty State Handling
  private func showEmptyStateView(for collectionView: UICollectionView, message: String) {
    guard emptyStateView == nil else { return }
    
    emptyStateView = EmptyStateView(message: message)
    view.addSubview(emptyStateView!)
    emptyStateView?.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(collectionView.snp.bottom).offset(0)
      make.leading.trailing.equalToSuperview().inset(20)
    }
  }
  
  private func showEmptyStateViewQuickSend(for collectionView: UICollectionView, message: String) {
    guard emptyStateViewQuickSend == nil else { return }
    
    emptyStateViewQuickSend = EmptyStateView(message: message)
    view.addSubview(emptyStateViewQuickSend!)
    emptyStateViewQuickSend?.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(collectionView.snp.bottom).offset(0)
      make.leading.trailing.equalToSuperview().inset(20)
    }
  }
  
  private func hideEmptyStateView() {
    emptyStateView?.removeFromSuperview()
    emptyStateView = nil
  }
  
  private func hideEmptyStateViewQuickSend() {
    emptyStateViewQuickSend?.removeFromSuperview()
    emptyStateViewQuickSend = nil
  }
  
  // MARK: - IBActions
    @IBAction func requestButtonTapped(_ sender: UIButton) {
      coordinator?.goToGenerateQR()
    }
  
    @IBAction func payRequestButtonTapped(_ sender: UIButton) {
      coordinator?.goToScanQR()
    }
  
    @IBAction func topUpButtonTapped(_ sender: UIButton) {
      guard let userData = userData else {
        print("userData is nil")
        return
      }
      coordinator?.goToTopUp(userData: userData)
    }
  
    @IBAction func quickSendViewAllButtonTapped(_ sender: UIButton) {
      coordinator?.goToContacts()
    }
  
    @IBAction func historyViewAllButtonTapped(_ sender: UIButton) {
      coordinator?.goToHistory()
    }
  
    @IBAction func settingButtonTapped(_ sender: UIButton) {
      coordinator?.goToSetting()
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collectionView === contactCollectionView ? quickSendDataArray.count : historyDataArray.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView === contactCollectionView {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "quicksend_cell", for: indexPath) as! AddQuickSendCollectionViewCell
      if indexPath.row < quickSendDataArray.count {
        let data = quickSendDataArray[indexPath.row]
        cell.populate(data)
      }
      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "history_cell", for: indexPath) as! HistoryCollectionViewCell
      if indexPath.item < historyDataArray.count {
        let data = historyDataArray[indexPath.item]
        cell.populate(data)
        cell.backgroundColor = UIColor(hex: data.type == "transfer" ? "#C20000" : "#266A61")
      }
      return cell
    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView === contactCollectionView, indexPath.row < quickSendDataArray.count {
      let quickSendData = quickSendDataArray[indexPath.row]
      coordinator?.goToContactDetailQuickSend(quickSendData: quickSendData)
    } else if collectionView === historyCollectionView, indexPath.item < historyDataArray.count {
      let historyData = historyDataArray[indexPath.item]
      coordinator?.goToHistoryDetail(with: historyData)
    }
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView === contactCollectionView {
      return CGSize(width: 60, height: 60)
    } else if collectionView === historyCollectionView {
      return CGSize(width: 180, height: 110)
    } else {
      return CGSize(width: 60, height: 60)
    }
  }
}
