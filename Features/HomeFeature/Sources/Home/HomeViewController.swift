//
//  HomeViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
  
  @IBOutlet weak var topView: UIView!
  @IBOutlet weak var requestButton: UIButton!
  @IBOutlet weak var payButton: UIButton!
  @IBOutlet weak var quickSendCollectionView: UICollectionView!
  @IBOutlet weak var historyCollectionView: UICollectionView!
  weak var coordinator: HomeCoordinator!
  var viewModel: HomeViewModel
  
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
    
    quickSendCollectionView.register(UINib(nibName: "ContactCollectionViewCell", bundle: .module), forCellWithReuseIdentifier: "contact_cell")
    quickSendCollectionView.register(UINib(nibName: "AddQuickSendCollectionViewCell", bundle: .module), forCellWithReuseIdentifier: "add_quick_send_cell")
    historyCollectionView.register(UINib(nibName: "HistoryCollectionViewCell", bundle: .module), forCellWithReuseIdentifier: "history_cell")
    
    quickSendCollectionView.dataSource = self
    quickSendCollectionView.delegate = self
    
    historyCollectionView.dataSource = self
    historyCollectionView.delegate = self
    
    
  }
  
  func setupUI() {
    // setting height
    topView.snp.makeConstraints { make in
      make.height.equalTo(350)
    }
    requestButton.snp.makeConstraints { make in
      make.height.equalTo(70)
    }
    payButton.snp.makeConstraints { make in
      make.height.equalTo(70)
    }
    
    // setting button corner radius
    requestButton.layer.cornerRadius = 8
    payButton.layer.cornerRadius = 8
    
    // setting uiView corner radius
    let cornerRadius: CGFloat = 20.0
    topView.layoutIfNeeded()
    let path = UIBezierPath(roundedRect: topView.bounds,
                            byRoundingCorners: [.bottomLeft, .bottomRight],
                            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
    
    let maskLayer = CAShapeLayer()
    maskLayer.path = path.cgPath
    topView.layer.mask = maskLayer
  }
  
  @IBAction func payRequestButtonTapped(_ sender: UIButton) {
    coordinator.goToPayRequest()
  }
  
  @IBAction func quickSendViewAllButtonTapped(_ sender: UIButton) {
    coordinator.goToContacts()
  }
  
  @IBAction func historyViewAllButtonTapped(_ sender: UIButton) {
    coordinator.goToHistory()
  }
  
}

extension HomeViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView === quickSendCollectionView {
      return CGSize(width: 60, height: 60)
    } else if collectionView === historyCollectionView {
      return CGSize(width: 180, height: 110)
    } else {
      return CGSize(width: 60, height: 60)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView === quickSendCollectionView {
      if indexPath.row == 0 {
        print("plus")
      } else {
        coordinator.goToContactDetail()
      }
    } else {
      coordinator.goToHistoryDetail()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView === quickSendCollectionView {
      return viewModel.quickSendCount
    } else if collectionView === historyCollectionView {
      return viewModel.historyData.count
    } else {
      return 0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView === quickSendCollectionView {
      if indexPath.row == 0 {
        let data = viewModel.addQuickSendData[indexPath.row]
        let addQuickSendCell = collectionView.dequeueReusableCell(withReuseIdentifier: "add_quick_send_cell", for: indexPath) as! AddQuickSendCollectionViewCell
        addQuickSendCell.populate(data)
        return addQuickSendCell
      } else {
        let data = viewModel.quickSendData[indexPath.row - 1]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contact_cell", for: indexPath) as! ContactCollectionViewCell
        cell.populate(data)
        return cell
      }
    } else if collectionView === historyCollectionView {
      let data = viewModel.historyData[indexPath.row]
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "history_cell", for: indexPath) as! HistoryCollectionViewCell
      cell.populate(data)
      return cell
    } else {
      return .init()
    }
  }
  
  
}
