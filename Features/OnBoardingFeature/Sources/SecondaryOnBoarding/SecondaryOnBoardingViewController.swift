//
//  SecondaryOnBoardingViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 07/08/24.
//

import UIKit

class SecondaryOnBoardingViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var gettingStartedButton: UIButton!
  
  weak var coordinator: SecondaryOnBoardingCoordinator!
  
  init(coordinator: SecondaryOnBoardingCoordinator!){
    self.coordinator = coordinator
    super.init(nibName: "SecondaryOnBoardingViewController", bundle: .module)
  }
  
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  var data: [OnBoarding] = [
    OnBoarding(image: "illustration1", title: "Welcome", subTitle: "It’s a pleasure to meet you. We are excited that you’re here so let’s get started!"),
    OnBoarding(image: "illustration4", title: "Favorites", subTitle: "Send the money to your favorites person!"),
    OnBoarding(image: "illustration2", title: "No Tax", subTitle: "Send all the money you want, with no tax and unlimited!")
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.register(UINib(nibName: "SecondaryOnBoardingCollectionViewCell", bundle: .module), forCellWithReuseIdentifier: "onboarding_cell")
    
    collectionView.dataSource = self
    collectionView.delegate = self
    gettingStartedButton.layer.cornerRadius = 8
    
    collectionView.isPagingEnabled = true
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    layout.scrollDirection = .horizontal
    collectionView.collectionViewLayout = layout
    
    pageControl.numberOfPages = data.count
    pageControl.currentPage = 0
    
    self.navigationItem.hidesBackButton = true
    
  }
  
  
  @IBAction func gettingStartedButtonTapped(_ sender: UIButton) {
    coordinator.goToSignIn()
  }
  
}

extension SecondaryOnBoardingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return data.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "onboarding_cell", for: indexPath) as! SecondaryOnBoardingCollectionViewCell
    let item = data[indexPath.row]
    cell.populate(item)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    collectionView.frame.size
  }
}

extension SecondaryOnBoardingViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let x = scrollView.contentOffset.x
    let w = scrollView.bounds.size.width
    let currentPage = Int(ceil(x/w))
    pageControl.currentPage = currentPage
    gettingStartedButton.isHidden = currentPage != data.count - 1
  }
}
