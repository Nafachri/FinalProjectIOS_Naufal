//
//  ChangePasswordResponse.swift
//  The North
//
//  Created by Naufal Al-Fachri on 05/08/24.
//

import Foundation
import Networking

public struct ChangePasswordResponse: Responseable {
  public var data: Networking.UserData?
  public var message: String
  public var success: Bool
}
