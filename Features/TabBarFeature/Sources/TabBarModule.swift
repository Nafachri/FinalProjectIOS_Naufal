//
//  TabBarModule.swift
//  Dependency
//
//  Created by Naufal Al-Fachri on 09/08/24.
//

import UIKit
import Dependency
import Networking
import Coordinator

public class TabBarModule: TabBarDependency {
  var homeDependency: HomeDependency!
  var contactsDependency: ContactsDependency!
  var historyDependency: HistoryDependency!
  var profileDependency: ProfileDependency!
  
  public init( homeDependency: HomeDependency, contactsDependency: ContactsDependency, historyDependency: HistoryDependency, profileDependency: ProfileDependency){
    self.homeDependency = homeDependency
    self.contactsDependency = contactsDependency
    self.historyDependency = historyDependency
    self.profileDependency = profileDependency
  }
  
  public func tabBarCoordinator(_ navigationController: UINavigationController) -> Coordinator {
    TabbarCoordinator(homeDependency: homeDependency, contactsDependency: contactsDependency, historyDependency: historyDependency, profileDependency: profileDependency)
  }
}
