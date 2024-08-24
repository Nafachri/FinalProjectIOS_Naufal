//
//  ModelResponse.swift
//  The North
//
//  Created by Naufal Al-Fachri on 22/08/24.
//

// MARK: - For Change Password, Transfer,
public struct GlobalMessageResponse: Codable {
  public let message: String
}

public struct SignUpResponse: Codable {
  public let username: String
  public let email: String
  public let phoneNumber: String
  public let password: String
}

public struct LoginResponse: Codable {
  public let message: String
  public let token: String
}

// MARK: Transfer - Response
public struct TransferResponse: Codable {
  public let orderId: String
  public let amount: String
  public let type: String
  public let name: String
  public let timestamp: String
}



// MARK: - Profile Response
public struct ProfileResponse: Codable {
  public let name, fullName, email, phoneNumber: String
  public let avatar: String
  public let balance: String
}

// MARK: - List Contact Response
public struct ListContactResponseData: Codable {
  public let id, name, email, phoneNumber: String
  public let avatar: String
}

public typealias ListContactResponse = [ListContactResponseData]

// MARK: - Top Up Response
public struct TopUpResponse: Codable {
  public let status, redirectURL , token: String

  enum CodingKeys: String, CodingKey {
    case status = "status"
    case redirectURL = "redirect_url"
    case token = "token"

  }
}

// MARK: - Action
public struct TopUpResponseAction: Codable {
  public let name, method: String
  public let url: String
}

// MARK: - Transaction
public struct TransactionResponse: Codable {
  public let orderId: String
  public let amount: String
  public let type: String
  public let timestamp: String
  public let avatar: String
  public let name: String
}


// MARK: - History Response
public struct HistoryResponse: Codable {
  public let transaction: [TransactionResponse]
}

public enum TypeTransaction: String {
  case topup
  case transfer
}
