//
//  SettingTableViewCell.swift
//  The North
//
//  Created by Naufal Al-Fachri on 02/08/24.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
  
  // MARK: - Outlets
  @IBOutlet weak var uiSwitch: UISwitch!
  @IBOutlet weak var themeIcon: UIImageView!
  
  // MARK: - Properties
  var darkModeEnabled: Bool {
    get {
      UserDefaults.standard.bool(forKey: "darkModeEnabled")
    }
    set {
      UserDefaults.standard.setValue(newValue, forKey: "darkModeEnabled")
    }
  }
  
  // MARK: - Lifecycle
  override func awakeFromNib() {
    super.awakeFromNib()
    uiSwitch.isOn = darkModeEnabled
    updateAppearance()
    setupUI()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  // MARK: - UI Setup
  func setupUI() {
    if darkModeEnabled {
      themeIcon.image = UIImage(systemName: "moon.fill")
    } else {
      themeIcon.image = UIImage(systemName: "sun.max.fill")
    }
  }
  
  // MARK: - Actions
  @IBAction func switchButton(_ sender: UISwitch) {
    darkModeEnabled = sender.isOn
    updateAppearance()
    setupUI()
  }
  
  // MARK: - Appearance
  private func updateAppearance() {
    let style: UIUserInterfaceStyle = darkModeEnabled ? .dark : .light
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
      for window in windowScene.windows {
        window.overrideUserInterfaceStyle = style
      }
    }
  }
}
