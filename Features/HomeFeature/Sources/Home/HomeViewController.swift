//
//  HomeViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import UIKit
import SnapKit
import TNUI
import TheNorthCoreDataManager

class HomeViewController: UIViewController {
  
  @IBOutlet weak var settingButton: UIButton!
  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var topUpBUtton: UIButton!
  @IBOutlet weak var requestButton: UIButton!
  @IBOutlet weak var payButton: UIButton!
  @IBOutlet weak var contactCollectionView: UICollectionView!
  @IBOutlet weak var historyCollectionView: UICollectionView!
  weak var coordinator: HomeCoordinator!
  var viewModel: HomeViewModel
  //  var dataArray: [ContactModel] = []
  var contactDataArray: [ContactModel] = []
  var historyDataArray: [HistoryModel] = []
  var coredata = CoreDataManager.shared
  
  
  init(coordinator: HomeCoordinator, viewModel: HomeViewModel = HomeViewModel()){
    self.coordinator = coordinator
    self.viewModel = viewModel
    super.init(nibName: "HomeViewController", bundle: .module)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented" )
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    fetchQuickSendContacts()
    fetchHistory()
    
    NotificationCenter.default.addObserver(forName: SuccessScreenViewController.chekcoutNotification, object: nil, queue: .main) { [weak self] _ in
      self?.fetchHistory()
    }
    
    //    fetchContacts()
    
    contactCollectionView.register(UINib(nibName: "ContactCollectionViewCell", bundle: .module), forCellWithReuseIdentifier: "contact_cell")
    historyCollectionView.register(UINib(nibName: "HistoryCollectionViewCell", bundle: .module), forCellWithReuseIdentifier: "history_cell")
    
    contactCollectionView.dataSource = self
    contactCollectionView.delegate = self
    historyCollectionView.dataSource = self
    historyCollectionView.delegate = self
    
    navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: SuccessScreenViewController.chekcoutNotification, object: self)
  }
  
  
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    // setting uiView corner radius
    let cornerRadius: CGFloat = 20.0
    let path = UIBezierPath(roundedRect: topView.bounds,
                            byRoundingCorners: [.bottomLeft, .bottomRight],
                            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
    
    let maskLayer = CAShapeLayer()
    maskLayer.path = path.cgPath
    topView.layer.mask = maskLayer
  }
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
  }
  
  func setupUI() {
    // setting button corner radius
    topUpBUtton.layer.cornerRadius = 8
    requestButton.layer.cornerRadius = 8
    payButton.layer.cornerRadius = 8
    
  }
  
  @IBAction func requestButtonTapped(_ sender: UIButton) {
    coordinator.goToGenerateQR()
  }
  @IBAction func payRequestButtonTapped(_ sender: UIButton) {
    coordinator.goToScanQR()
  }
  
  @IBAction func topUpButtonTapped(_ sender: UIButton) {
    coordinator.goToTopUp()
  }
  @IBAction func quickSendViewAllButtonTapped(_ sender: UIButton) {
    coordinator.goToContacts()
  }
  
  @IBAction func historyViewAllButtonTapped(_ sender: UIButton) {
    coordinator.goToHistory()
  }
  
  @IBAction func settingButtonTapped(_ sender: UIButton) {
    coordinator.goToSetting()
  }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView === contactCollectionView {
      let selectedData = contactDataArray[indexPath.row]
      coordinator.goToContactDetail(with: selectedData)
    } else if  collectionView === historyCollectionView {
      let selectedData = historyDataArray[indexPath.row]
      coordinator.goToHistoryDetail(with: selectedData)
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
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView === contactCollectionView {
      return contactDataArray.count
    } else if collectionView === historyCollectionView {
      return historyDataArray.count
    } else {
      return 0
    }
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView === contactCollectionView {
      let data = contactDataArray[indexPath.row]
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contact_cell", for: indexPath) as! ContactCollectionViewCell
      cell.populate(data)
      return cell
    } else if collectionView === historyCollectionView {
      let data = historyDataArray[indexPath.item]
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "history_cell", for: indexPath) as! HistoryCollectionViewCell
      cell.populate(data)
      
      if data.type == "pay" {
        cell.backgroundColor = UIColor(hex: "#C20000")
      } else {
        cell.backgroundColor = UIColor(hex: "#266A61")
      }
      
      return cell
    }
    return UICollectionViewCell()
  }
  
  
  private func fetchQuickSendContacts() {
    do {
      contactDataArray = try coredata.fetch(entity: ContactModel.self, fetchLimit: 3)
      contactCollectionView.reloadData()
    } catch {
      print("Failed to fetch contacts: \(error.localizedDescription)")
    }
  }
  
  private func fetchHistory() {
    do {
      historyDataArray = try coredata.fetch(entity: HistoryModel.self)
      historyCollectionView.reloadData()
    } catch {
      print("Failed to fetch contacts: \(error.localizedDescription)")
    }
  } 
}
