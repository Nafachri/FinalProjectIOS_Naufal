//
//  SignupResponse.swift
//  Services
//
//  Created by Naufal Al-Fachri on 05/08/24.
//

import Foundation
import Networking

public struct SignupResponse: Responseable {
  public var data: Networking.UserData?
  public var message: String
  public var success: Bool
}
