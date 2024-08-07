//
//  SettingTableViewCell.swift
//  The North
//
//  Created by Naufal Al-Fachri on 02/08/24.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
  
  @IBOutlet weak var uiSwitch: UISwitch!
  @IBOutlet weak var themeIcon: UIImageView!
  
  var darkModeEnabled: Bool {
    get {
      UserDefaults.standard.bool(forKey: "darkModeEnabled")
    }
    
    set {
      UserDefaults.standard.setValue(newValue, forKey: "darkModeEnabled")
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    uiSwitch.isOn = darkModeEnabled
    updateAppearance()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
  func setupUI() {
    if darkModeEnabled {
      themeIcon.image = UIImage(named: "moon.fill")

    } else {
      themeIcon.image = UIImage(named: "sun.max.fill")
    }
  }
  
  @IBAction func switchButton(_ sender: UISwitch) {
    darkModeEnabled = sender.isOn
    
    updateAppearance()
    
  }
  private func updateAppearance() {
    let style: UIUserInterfaceStyle = darkModeEnabled ? .dark : .light
    
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
      for window in windowScene.windows {
        window.overrideUserInterfaceStyle = style
      }
    }
  }
  
}
