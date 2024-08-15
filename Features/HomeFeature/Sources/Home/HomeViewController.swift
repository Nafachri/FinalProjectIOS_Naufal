//
//  HomeViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import UIKit
import SnapKit
import TNUI


class HomeViewController: UIViewController {
  
  @IBOutlet weak var settingButton: UIButton!
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
    quickSendCollectionView.reloadData()

    
    historyCollectionView.dataSource = self
    historyCollectionView.delegate = self
    historyCollectionView.reloadData()
    
    navigationController?.setNavigationBarHidden(true, animated: false)
    
    
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
    // setting height
//    topView.snp.makeConstraints { make in
//      make.height.equalTo(350)
//    }
//    requestButton.snp.makeConstraints { make in
//      make.height.equalTo(70)
//    }
//    payButton.snp.makeConstraints { make in
//      make.height.equalTo(70)
//    }
    
    // setting button corner radius
    requestButton.layer.cornerRadius = 8
    payButton.layer.cornerRadius = 8
    
  }
  
  @IBAction func requestButtonTapped(_ sender: UIButton) {
    coordinator.goToGenerateQR()
    print("button tapped")
  }
  @IBAction func payRequestButtonTapped(_ sender: UIButton) {
    coordinator.goToScanQR()

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
        coordinator.goToContacts()
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
      
      if data.amount.hasPrefix("-") {
        cell.backgroundColor = UIColor(hex: "#C20000")
      } else if data.amount.hasPrefix("+") {
        cell.backgroundColor = UIColor(hex: "#266A61")
      } else {
        cell.backgroundColor = .clear
      }
      return cell
    } else {
      return .init()
    }
  }
}
//extension UIColor {
//    /// Initialize UIColor with a hex string
//    ///
//    /// - Parameter hex: The hex string representation of the color. Supports `#RRGGBB` and `#RRGGBBAA` formats.
//    convenience init?(hex: String) {
//        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
//        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
//
//        var rgb: UInt64 = 0
//        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 1.0
//
//        let length = hexSanitized.count
//
//        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
//
//        if length == 6 {
//            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
//            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
//            b = CGFloat(rgb & 0x0000FF) / 255.0
//        } else if length == 8 {
//            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
//            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
//            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
//            a = CGFloat(rgb & 0x000000FF) / 255.0
//        } else {
//            return nil
//        }
//
//        self.init(red: r, green: g, blue: b, alpha: a)
//    }
//}
