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

public class HomeModule: HomeDependency {
  
  var payRequestDependency: PayRequestDependency!
  var contactsDependency: ContactsDependency!
  var historyDependency: HistoryDependency!
  var settingDependency: SettingDependency!
  
  public init(payRequestDependency: PayRequestDependency, contactsDependency: ContactsDependency, historyDependency: HistoryDependency, settingDependency: SettingDependency){
    self.payRequestDependency = payRequestDependency
    self.contactsDependency = contactsDependency
    self.historyDependency = historyDependency
    self.settingDependency = settingDependency
  }
  
  public func homeCoordinator(_ navigationController: UINavigationController) -> Coordinator {
    HomeCoordinator(navigationController: navigationController, payRequestDependency: payRequestDependency, contactsDependency: contactsDependency, historyDependency: historyDependency, settingDependency: settingDependency
    )
  }
}
