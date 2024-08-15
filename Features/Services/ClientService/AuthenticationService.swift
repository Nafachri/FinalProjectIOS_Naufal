//
//  AuthenticationService.swift
//  The North
//
//  Created by Naufal Al-Fachri on 03/08/24.
//

import Foundation
import Networking
import KeychainSwift

public protocol AuthenticationServiceable {
  func signIn(email: String, password: String, onComplete: @escaping (Result<SignInResponse, PCError>) -> Void)
  
  func changePassword(email: String, phoneNumber: String, password: String, confirmPassword: String, onComplete: @escaping (Result<ChangePasswordResponse, PCError>) -> Void)
  
  func signUp(username: String, email: String, phoneNumber: String, password: String, confirmPassword: String, onComplete: @escaping(Result<SignupResponse, PCError>) -> Void)
  
  func getLocalUser() -> UserData?
}



public class AuthenticationService: AuthenticationServiceable {
  
  let requestor: Requestable
  let baseAPI = "http://localhost:8080"
  let keychain = KeychainSwift()
  
  
  public init(requestor: Requestable = NetworkRequest()) {
    self.requestor = requestor
  }
  
  // MARK: Sign In
  public func signIn(email: String, password: String, onComplete: @escaping (Result<SignInResponse, PCError>) -> Void) {
    let credentialData = "\(email):\(password)".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) ?? .init()
    let base64Credentials = credentialData.base64EncodedString()
    let headers: HTTPHeaders = [
                "Authorization": "Basic \(base64Credentials)",
                "Accept": "application/json",
                "Content-Type": "application/json" ]

    
    requestor.request(
      "\(baseAPI)/auth/signin", method: .post,
      params: [:],
      headers: headers
    ) { [weak self] (result: Result<SignInResponse, PCError>) in
          switch result {
          case .success(let res):
            self?.keychain.set(res.data?.token ?? "", forKey: "userToken")
            self?.saveLocalUser(res.data?.user)

          case .failure(let error):
            print(error)
          }
          onComplete(result)
        }
  }
  
  public func saveLocalUser(_ user: UserData?){
    print("ini save local user : \(user)")
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
  public func signUp(username: String, email: String, phoneNumber: String, password: String, confirmPassword: String, onComplete: @escaping (Result<SignupResponse, PCError>) -> Void) {
    
    requestor.request(
      "\(baseAPI)/users", method: .post,
      params: [
        "username": username,
        "email": email,
        "phoneNumber": phoneNumber,
        "password": password,
        "confirmPassword": confirmPassword,
      ],
      onComplete: onComplete
    )
  }
  
  public func getLocalUser() -> Networking.UserData? {
    nil
  }
}
