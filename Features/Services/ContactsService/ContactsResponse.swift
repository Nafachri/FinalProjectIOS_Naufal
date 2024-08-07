//
//  ContactsResponse.swift
//  ContactsFeature
//
//  Created by Naufal Al-Fachri on 07/08/24.
//

import Foundation
import Networking

public struct ContactsResponse: Responseable {
  public var data: Networking.UserData?
  public var message: String
  public var success: Bool
}
