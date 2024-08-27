//
//  SecondaryOnBoardingViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 07/08/24.
//

import UIKit

// MARK: - SecondaryOnBoardingViewController

class SecondaryOnBoardingViewController: UIViewController {
  
  // MARK: - IBOutlets
  
  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var gettingStartedButton: UIButton!
  
  // MARK: - Properties
  
  weak var coordinator: SecondaryOnBoardingCoordinator!
  
  var data: [OnBoarding] = [
    OnBoarding(image: "illustration1", title: "Welcome", subTitle: "It’s a pleasure to meet you. We are excited that you’re here so let’s get started!"),
    OnBoarding(image: "illustration4", title: "Favorites", subTitle: "Send the money to your favorites person!"),
    OnBoarding(image: "illustration2", title: "No Tax", subTitle: "Send all the money you want, with no tax and unlimited!")
  ]
  
  // MARK: - Initializers
  
  init(coordinator: SecondaryOnBoardingCoordinator!) {
    self.coordinator = coordinator
    super.init(nibName: "SecondaryOnBoardingViewController", bundle: .module)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle Methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupCollectionView()
    setupPageControl()
    setupGettingStartedButton()
    self.navigationItem.hidesBackButton = true
  }
  
  // MARK: - Setup Methods
  
  private func setupCollectionView() {
    collectionView.register(UINib(nibName: "SecondaryOnBoardingCollectionViewCell", bundle: .module), forCellWithReuseIdentifier: "onboarding_cell")
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.isPagingEnabled = true
    
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0
    layout.scrollDirection = .horizontal
    collectionView.collectionViewLayout = layout
  }
  
  private func setupPageControl() {
    pageControl.numberOfPages = data.count
    pageControl.currentPage = 0
  }
  
  private func setupGettingStartedButton() {
    gettingStartedButton.layer.cornerRadius = 8
  }
  
  // MARK: - IBActions
  
  @IBAction func gettingStartedButtonTapped(_ sender: UIButton) {
    coordinator.goToSignIn()
  }
  
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

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
    return collectionView.frame.size
  }
  
}

// MARK: - UIScrollViewDelegate

extension SecondaryOnBoardingViewController: UIScrollViewDelegate {
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let x = scrollView.contentOffset.x
    let w = scrollView.bounds.size.width
    let currentPage = Int(ceil(x / w))
    pageControl.currentPage = currentPage
    gettingStartedButton.isHidden = currentPage != data.count - 1
  }
  
}
