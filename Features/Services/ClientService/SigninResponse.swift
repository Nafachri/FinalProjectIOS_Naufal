//
//  SigninResponse.swift
//  The North
//
//  Created by Naufal Al-Fachri on 03/08/24.
//

import Foundation
import Networking

public struct SigninResponse: Responseable {
  public var data: Networking.UserData?
  public var message: String
  public var success: Bool
}
