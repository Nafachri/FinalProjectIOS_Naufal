//
//  HomeModule.swift
//  The North
//
//  Created by Naufal Al-Fachri on 08/08/24.
//

import UIKit
import Dependency
import Networking
import Coordinator

// MARK: - HomeModule

public class HomeModule: HomeDependency {
  
  // MARK: - Properties
  
  var payRequestDependency: PayRequestDependency!
  var contactsDependency: ContactsDependency!
  var historyDependency: HistoryDependency!
  var settingDependency: SettingDependency!
  
  // MARK: - Initializer
  
  public init(
    payRequestDependency: PayRequestDependency,
    contactsDependency: ContactsDependency,
    historyDependency: HistoryDependency,
    settingDependency: SettingDependency
  ) {
    self.payRequestDependency = payRequestDependency
    self.contactsDependency = contactsDependency
    self.historyDependency = historyDependency
    self.settingDependency = settingDependency
  }
  
  // MARK: - Methods
  
  public func homeCoordinator(_ navigationController: UINavigationController) -> Coordinator {
    HomeCoordinator(
      navigationController: navigationController,
      payRequestDependency: payRequestDependency,
      contactsDependency: contactsDependency,
      historyDependency: historyDependency,
      settingDependency: settingDependency
    )
  }
}
