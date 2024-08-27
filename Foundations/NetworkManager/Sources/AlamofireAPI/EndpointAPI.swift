//
//  EndpointAPI.swift
//  The North
//
//  Created by Naufal Al-Fachri on 22/08/24.
//

import Foundation
import Alamofire
import KeychainSwift


public enum EndpointAPI {
  case login(param: LoginParam)
  case register(param: RegisterParam)
  case changePassword(param: ChangePasswordParam)
  case profile
  case topup(param: TopUpParam)
  case transfer(param: TransferParam)
  case listContact
  case history
  case generateQR(param: GenerateQRParam)
  case payQR(param: PayQRParam)
  
  var path: String {
    switch self {
    case .login: return "/login"
    case .register: return "/register"
    case .changePassword: return "/change-password"
    case .topup: return "/topup"
    case .profile: return "/profile"
    case .transfer: return "/transfer"
    case .listContact: return "/contact"
    case .history: return "/history"
    case .generateQR: return "/request"
    case .payQR: return "/pay"
      
      
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .login, .register, .changePassword, .transfer, .topup, .generateQR, .payQR: return .post
    case .listContact, .profile, .history: return .get
    }
  }
  
  var headers: HTTPHeaders {
    let keychain = KeychainSwift()
    let token = keychain.get("userToken")
    switch self {
    case .changePassword, .topup, .transfer, .listContact, .profile, .history, .generateQR, .payQR:
      return [
        "Content-Type": "application/json",
        "Authorization": "Bearer \(token ?? "")"
      ]
    case .login, .register: return [
      "Content-Type": "application/json"
    ]
    }
  }
  
  var encoding: ParameterEncoding {
    return JSONEncoding.default
  }
  
  var queryParams: [String: Any]? {
    switch self {
    case .register(let param):
      let params: [String: Any] = [
        "username": param.username,
        "fullName": param.fullName,
        "email": param.email,
        "phoneNumber": param.phoneNumber,
        "password": param.password
      ]
      return params
    case .login(let param):
      let params: [String: Any] = [
        "email": param.email,
        "password": param.password
      ]
      return params
    case .changePassword(let param):
      let params: [String: Any] = [
        "email": param.email,
        "newPassword": param.newPassword,
        "confirmPassword": param.confirmPassword
      ]
      return params
    case .topup(let param):
      let params: [String: Any] = [
        "amount": param.amount
      ]
      return params
    case .transfer(let param):
      let params: [String: Any] = [
        "amount": param.amount,
        "recipientUsername": param.recipientUsername
      ]
      return params
    case .generateQR(let param):
      let params: [String: Any] = [
        "amount": param.amount
      ]
      return params
    case .payQR(let param):
      let params: [String: Any] = [
        "qrCodeData": param.qrCodeData
      ]
      return params
    default:
      return nil
    }
  }
  
  var urlString: String {
    return "https://thenorthpay.phincon.site" + path
  }
  
}
