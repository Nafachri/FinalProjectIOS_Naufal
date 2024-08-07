//
//  ProfileViewController.swift
//  The North
//
//  Created by Naufal Al-Fachri on 02/08/24.
//

import UIKit
import Services
import RxSwift
import RxRelay

class ProfileViewController: UIViewController {
  var disposeBag = DisposeBag()
  var viewModel: ProfileViewModel
  weak var coordinator: ProfileCoordinator!

  
  init(coordinator: ProfileCoordinator!, viewModel: ProfileViewModel = ProfileViewModel(profile: ProfileService())) {
    self.coordinator = coordinator
    self.viewModel = viewModel
    super.init(nibName: "ProfileViewController", bundle: .module)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
