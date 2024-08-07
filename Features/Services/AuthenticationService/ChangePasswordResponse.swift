//
//  ChangePasswordResponse.swift
//  The North
//
//  Created by Naufal Al-Fachri on 05/08/24.
//

import Foundation
import Networking

private struct UserData: Codable {
    private var email: String
    private var phoneNumber: String
    private var password: String
    private var confirmPassword: String
}

public struct ChangePasswordResponse: Responseable {
  public var data: Networking.UserData?
  public var message: String
  public var success: Bool
}
