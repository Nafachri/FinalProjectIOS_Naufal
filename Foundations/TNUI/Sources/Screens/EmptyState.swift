//
//  EmptyState.swift
//  The North
//
//  Created by Naufal Al-Fachri on 19/08/24.
//

import Foundation
import UIKit

public class EmptyStateView: UIView {
  
  private let messageLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.textColor = .gray
    label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  public  init(message: String) {
    super.init(frame: .zero)
    messageLabel.text = message
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    addSubview(messageLabel)
    NSLayoutConstraint.activate([
      messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  func updateMessage(_ message: String) {
    messageLabel.text = message
  }
}
