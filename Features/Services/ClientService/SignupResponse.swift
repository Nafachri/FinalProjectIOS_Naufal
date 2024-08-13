//
//  SignupResponse.swift
//  Services
//
//  Created by Naufal Al-Fachri on 05/08/24.
//

import Foundation
import Networking

private struct UserData: Codable {
    private var username: String
    private var email: String
    private var phoneNumber: String
//    private var password: String
//    private var confirmPassword: String
}

public struct SignupResponse: Responseable {
  public var data: Networking.UserData?
  public var message: String
  public var success: Bool
}
