//
//  Model.swift
//  The North
//
//  Created by Naufal Al-Fachri on 22/08/24.
//


import UIKit

// MARK: - Register Param
public struct RegisterParam {
  public let email: String
  public let password: String
  public let username: String
  public let phoneNumber: String
  
  public init(username: String, email: String, phoneNumber: String, password: String) {
    self.email = email
    self.password = password
    self.username = username
    self.phoneNumber = phoneNumber
  }
}

// MARK: - Login Param
public struct LoginParam {
  public let email: String
  public let password: String
  
  
  public init(email: String, password: String) {
    self.email = email
    self.password = password
  }
}

// MARK: - Change Password Param
public struct ChangePasswordParam {
  public let email: String
  public let newPassword: String
  
  public init(email: String, newPassword: String){
    self.email = email
    self.newPassword = newPassword
  }
}

// MARK: - Top Up Param
public struct TopUpParam {
  public let amount: Int
  
  public init(amount: Int) {
    self.amount = amount
  }
}

// MARK: - Transfer Param
public struct TransferParam {
  public let amount: Int
  public let recipientUsername: String
  
  public init(amount: Int, recipientUsername: String) {
    self.amount = amount
    self.recipientUsername = recipientUsername
  }
}

// MARK: - Midtrans Notification
public struct MidtransNotificationParam {
  public let token: String
  
  public init(token: String) {
    self.token = token
  }
}

// MARK: - Update Profile
public struct ProfileParam {
  public let username: String?
  public let phoneNumber: String?
  public let email: String?
  public let avatar: UIImage?
  
  public init(username: String?, phoneNumber: String?, email: String?, avatar: UIImage?) {
    self.username = username
    self.phoneNumber = phoneNumber
    self.email = email
    self.avatar = avatar
  }
}



