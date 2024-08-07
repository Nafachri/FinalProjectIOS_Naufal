//
//  ProfileService.swift
//  ProfileFeature
//
//  Created by Naufal Al-Fachri on 05/08/24.
//

import Foundation
import Networking

public protocol ProfileServiceable {
  func editProfile(username: String, email: String, phoneNumber: String, onComplete: @escaping (Result<ProfileResponse, PCError>) -> Void)
}


public class ProfileService:
  ProfileServiceable {
  
  let requestor: Requestable
  let baseAPI = "http://localhost:3001"
  
  public init(requestor: Requestable = NetworkRequest()){
    self.requestor = requestor
  }
  
  // MARK: Edit Profile
  public func editProfile(username: String, email: String, phoneNumber: String, onComplete: @escaping (Result<ProfileResponse, PCError>) -> Void) {
    requestor.request(
      "\(baseAPI)/profile/edit", method: .patch,
      params: [
        "username": username,
        "email": email,
        "phoneNUmber": phoneNumber
      ],
      onComplete: onComplete
    )
  }
}

