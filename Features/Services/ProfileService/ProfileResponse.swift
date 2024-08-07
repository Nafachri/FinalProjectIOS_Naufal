//
//  ProfileResponse.swift
//  ProfileFeature
//
//  Created by Naufal Al-Fachri on 05/08/24.
//

import Foundation
import Networking

public struct ProfileResponse: Responseable {
  public var data: Networking.UserData?
  public var message: String
  public var success: Bool
}
