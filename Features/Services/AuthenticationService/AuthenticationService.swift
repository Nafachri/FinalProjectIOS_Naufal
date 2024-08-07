//
//  AuthenticationService.swift
//  The North
//
//  Created by Naufal Al-Fachri on 03/08/24.
//

import Foundation
import Networking

public protocol AuthenticationServiceable {
  func signIn(username: String, password: String, onComplete: @escaping (Result<SigninResponse, PCError>) -> Void)
  
  func changePassword(email: String, phoneNumber: String, password: String, confirmPassword: String, onComplete: @escaping (Result<ChangePasswordResponse, PCError>) -> Void)
  
  func signUp(username: String, email: String, phoneNumber: String, password: String, confirmPassword: String, onComplete: @escaping(Result<SignupResponse, PCError>) -> Void)
}

public class AuthenticationService: AuthenticationServiceable {
  
  let requestor: Requestable
  let baseAPI = "http://localhost:3001"
  
  
  public init(requestor: Requestable = NetworkRequest()) {
    self.requestor = requestor
  }
  
  // MARK: Sign In
  public func signIn(username: String, password: String, onComplete: @escaping (Result<SigninResponse, PCError>) -> Void) {
    requestor.request(
      "\(baseAPI)/auth/signin", method: .post,
      params: [
        "username": username,
        "password": password],
      onComplete: onComplete
    )
    
  }
  
  // MARK: Forgot Password / Change Password
  public func changePassword(email: String, phoneNumber: String, password: String, confirmPassword: String, onComplete: @escaping (Result<ChangePasswordResponse, PCError>) -> Void) {
    requestor.request(
      "\(baseAPI)/auth/change-password", method: .post,
      params: [
        "email": email,
        "phoneNumber": phoneNumber,
        "password": password,
        "confirmPassword": confirmPassword,
      ],
      onComplete: onComplete
    )
  }
  
  // MARK: Sign Up
  public func signUp(username: String, email: String, phoneNumber: String, password: String, confirmPassword: String, onComplete: @escaping
                     (Result<SignupResponse, PCError>) -> Void){
    requestor.request(
      "\(baseAPI)/auth/signup", method: .post,
      params: [
        "username": username,
        "email": email,
        "phoneNumber": phoneNumber,
        "password": password,
        "confirmPassword": confirmPassword
      ],
      onComplete: onComplete)
  }
  
  
  
  
}
