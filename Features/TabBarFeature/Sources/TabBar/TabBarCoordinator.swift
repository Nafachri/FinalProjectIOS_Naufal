//
//  TabBarCoordinator.swift
//  The North
//
//  Created by Naufal Al-Fachri on 09/08/24.
//

import UIKit
import Coordinator
import Dependency

class TabbarCoordinator: NSObject, TabbarCoordinatorable {
  
  // MARK: - Properties
  var tabbarController: UITabBarController
  var childCoordinators: [any Coordinator] = []
  weak var parentCoordinator: Coordinator?
  let homeDependency: HomeDependency
  let contactsDependency: ContactsDependency
  let historyDependency: HistoryDependency
  let profileDependency: ProfileDependency
  
  // MARK: - Initializer
  init(tabBarController: UITabBarController = .init(),
       homeDependency: HomeDependency,
       contactsDependency: ContactsDependency,
       historyDependency: HistoryDependency,
       profileDependency: ProfileDependency) {
    self.tabbarController = tabBarController
    self.homeDependency = homeDependency
    self.contactsDependency = contactsDependency
    self.historyDependency = historyDependency
    self.profileDependency = profileDependency
    
    super.init()
    self.tabbarController.delegate = self
  }
  
  // MARK: - Public Methods
  func start() {
    let homeNav = UINavigationController()
    let homeCoordinator = homeDependency.homeCoordinator(homeNav)
    addChildCoordinator(homeCoordinator)
    homeCoordinator.start()
    
    let contactsNav = UINavigationController()
    let contactsCoordinator = contactsDependency.contactsCoordinator(contactsNav)
    addChildCoordinator(contactsCoordinator)
    contactsCoordinator.start()
    
    let historyNav = UINavigationController()
    let historyCoordinator = historyDependency.historyCoordinator(historyNav)
    addChildCoordinator(historyCoordinator)
    historyCoordinator.start()
    
    let profileNav = UINavigationController()
    let profileCoordinator = profileDependency.profileCoordinator(profileNav)
    addChildCoordinator(profileCoordinator)
    profileCoordinator.start()
    
    startWithRoot(tabbarController)
    tabbarController.setViewControllers([
      homeNav,
      contactsNav,
      historyNav,
      profileNav
    ], animated: true)
    setupTabbar()
  }
  
  // MARK: - Private Methods
  private func setupTabbar() {
    guard let viewControllers = tabbarController.viewControllers else { return }
    
    viewControllers[0].tabBarItem = UITabBarItem(title: "Home",
                                                image: UIImage(systemName: "house"),
                                                selectedImage: UIImage(systemName: "house.fill"))
    viewControllers[1].tabBarItem = UITabBarItem(title: "Contact",
                                                image: UIImage(systemName: "person.3"),
                                                selectedImage: UIImage(systemName: "person.3.fill"))
    viewControllers[2].tabBarItem = UITabBarItem(title: "History",
                                                image: UIImage(systemName: "clock"),
                                                selectedImage: UIImage(systemName: "clock.fill"))
    viewControllers[3].tabBarItem = UITabBarItem(title: "Profile",
                                                image: UIImage(systemName: "person.crop.circle"),
                                                selectedImage: UIImage(systemName: "person.crop.circle.fill"))
  }
}

extension TabbarCoordinator: UITabBarControllerDelegate {
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    let nav = viewController as? UINavigationController
    nav?.popToRootViewController(animated: false)
  }
}
