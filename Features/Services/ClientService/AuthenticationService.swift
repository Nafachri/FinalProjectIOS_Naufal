//
//  AuthenticationService.swift
//  The North
//
//  Created by Naufal Al-Fachri on 03/08/24.
//


import Foundation
import Networking
import KeychainSwift
import TheNorthCoreDataManager

public protocol AuthenticationServiceable {
    func signIn(email: String, password: String, onComplete: @escaping (Result<SignInResponse, PCError>) -> Void)
    func changePassword(email: String, phoneNumber: String, password: String, confirmPassword: String, onComplete: @escaping (Result<ChangePasswordResponse, PCError>) -> Void)
    func signUp(username: String, email: String, phoneNumber: String, password: String, confirmPassword: String, onComplete: @escaping (Result<SignupResponse, PCError>) -> Void)
    func getLocalUser() -> UserData?
}

public class AuthenticationService: AuthenticationServiceable {
    
    private let requestor: Requestable
    private let baseAPI = "http://localhost:8080"
    private let keychain = KeychainSwift()
    private let coreDataManager = CoreDataManager.shared
    
    public init(requestor: Requestable = NetworkRequest()) {
        self.requestor = requestor
    }
    
    // MARK: - Sign In
    public func signIn(email: String, password: String, onComplete: @escaping (Result<SignInResponse, PCError>) -> Void) {
        let headers = createAuthorizationHeader(email: email, password: password)
        
        requestor.request(
            "\(baseAPI)/auth/signin",
            method: .post,
            params: [:],
            headers: headers
        ) { [weak self] (result: Result<SignInResponse, PCError>) in
            switch result {
            case .success(let response):
                self?.handleSignInSuccess(response)
            case .failure(let error):
                print("Sign In Error: \(error.localizedDescription)")
            }
            onComplete(result)
        }
    }
    
    // MARK: - Change Password
    public func changePassword(email: String, phoneNumber: String, password: String, confirmPassword: String, onComplete: @escaping (Result<ChangePasswordResponse, PCError>) -> Void) {
        let params: [String: Any] = [
            "email": email,
            "phoneNumber": phoneNumber,
            "password": password,
            "confirmPassword": confirmPassword
        ]
        
        requestor.request(
            "\(baseAPI)/auth/change-password",
            method: .post,
            params: params
        ) { result in
            onComplete(result)
        }
    }
    
    // MARK: - Sign Up
    public func signUp(username: String, email: String, phoneNumber: String, password: String, confirmPassword: String, onComplete: @escaping (Result<SignupResponse, PCError>) -> Void) {
        let params: [String: Any] = [
            "username": username,
            "email": email,
            "phoneNumber": phoneNumber,
            "password": password,
            "confirmPassword": confirmPassword
        ]
        
        requestor.request(
            "\(baseAPI)/users",
            method: .post,
            params: params
        ) { result in
            onComplete(result)
        }
    }
    
    // MARK: - Local User
    public func getLocalUser() -> UserData? {
        // Implement as needed
        return nil
    }
    
    // MARK: - Private Methods
    private func createAuthorizationHeader(email: String, password: String) -> HTTPHeaders {
        let credentialData = "\(email):\(password)".data(using: .utf8) ?? Data()
        let base64Credentials = credentialData.base64EncodedString()
        return [
            "Authorization": "Basic \(base64Credentials)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
    }
    
    private func handleSignInSuccess(_ response: SignInResponse) {
        let token = response.data?.token ?? ""
        keychain.set(token, forKey: "userToken")
        if let user = response.data?.user {
            saveLocalUser(user)
        }
    }
    
    private func convertToUserModel(_ userData: UserData) -> [String: Any] {
        return [
            "id": userData.id,
            "username": userData.username,
            "email": userData.email,
            "phoneNumber": userData.phoneNumber,
            "balance": "12.000.000"
        ]
    }
    
    private func saveLocalUser(_ userData: UserData) {
        let properties = convertToUserModel(userData)
        
        do {
            let _ = try coreDataManager.create(entity: UserModel.self, properties: properties)
        } catch {
            print("Failed to save user data: \(error.localizedDescription)")
        }
    }
}






////
////  AuthenticationService.swift
////  The North
////
////  Created by Naufal Al-Fachri on 03/08/24.
////
//
//import Foundation
//import Networking
//import KeychainSwift
//import TheNorthCoreDataManager
//
//public protocol AuthenticationServiceable {
//  func signIn(email: String, password: String, onComplete: @escaping (Result<SignInResponse, PCError>) -> Void)
//  
//  func changePassword(email: String, phoneNumber: String, password: String, confirmPassword: String, onComplete: @escaping (Result<ChangePasswordResponse, PCError>) -> Void)
//  
//  func signUp(username: String, email: String, phoneNumber: String, password: String, confirmPassword: String, onComplete: @escaping(Result<SignupResponse, PCError>) -> Void)
//  
//  func getLocalUser() -> UserData?
//}
//
//
//
//public class AuthenticationService: AuthenticationServiceable {
//  
//  let requestor: Requestable
//  let baseAPI = "http://localhost:8080"
//  let keychain = KeychainSwift()
//  
//  
//  public init(requestor: Requestable = NetworkRequest()) {
//    self.requestor = requestor
//  }
//  
//  // MARK: Sign In
//  public func signIn(email: String, password: String, onComplete: @escaping (Result<SignInResponse, PCError>) -> Void) {
//    let credentialData = "\(email):\(password)".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) ?? .init()
//    let base64Credentials = credentialData.base64EncodedString()
//    let headers: HTTPHeaders = [
//                "Authorization": "Basic \(base64Credentials)",
//                "Accept": "application/json",
//                "Content-Type": "application/json" ]
//
//    
//    requestor.request(
//      "\(baseAPI)/auth/signin", method: .post,
//      params: [:],
//      headers: headers
//    ) { [weak self] (result: Result<SignInResponse, PCError>) in
//          switch result {
//          case .success(let res):
//            self?.keychain.set(res.data?.token ?? "", forKey: "userToken")
//            self?.saveLocalUser(res.data?.user)
//
//          case .failure(let error):
//            print(error)
//          }
//          onComplete(result)
//        }
//  }
//  
//  public func saveLocalUser(_ user: UserModel){
//    // please save
////    public var phoneNumber: String
////    public var id: String
////    public var email: String
////    public var username: String
//// to core data UserModel
//  }
//  
//  
//  // MARK: Forgot Password / Change Password
//  public func changePassword(email: String, phoneNumber: String, password: String, confirmPassword: String, onComplete: @escaping (Result<ChangePasswordResponse, PCError>) -> Void) {
//    requestor.request(
//      "\(baseAPI)/auth/change-password", method: .post,
//      params: [
//        "email": email,
//        "phoneNumber": phoneNumber,
//        "password": password,
//        "confirmPassword": confirmPassword,
//      ],
//      onComplete: onComplete
//    )
//  }
//  
//  // MARK: Sign Up
//  public func signUp(username: String, email: String, phoneNumber: String, password: String, confirmPassword: String, onComplete: @escaping (Result<SignupResponse, PCError>) -> Void) {
//    
//    requestor.request(
//      "\(baseAPI)/users", method: .post,
//      params: [
//        "username": username,
//        "email": email,
//        "phoneNumber": phoneNumber,
//        "password": password,
//        "confirmPassword": confirmPassword,
//      ],
//      onComplete: onComplete
//    )
//  }
//  
////  public func getLocalUser() -> Networking.UserData? {
////    nil
////  }
//}
