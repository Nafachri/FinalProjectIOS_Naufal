//
//  Responseable.swift
//  The North
//
//  Created by Naufal Al-Fachri on 03/08/24.
//

//public struct UserData: Codable {
//  var username: String?
//  var email: String?
//  var phoneNumber: String?
//  var password: String?
//  var confirmPassword: String?
//}

public struct UserData: Codable {
  public var phoneNumber: String
  public var id: String
  public var email: String
  public var username: String
}

public struct SignInData: Codable {
  public var user: UserData?
  public var token: String
}

public struct SignUpData: Codable {
  public var user: UserData?
}

public protocol Responseable: Codable {
  var message: String { get }
  var success: Bool { get }
}

public struct SignInResponse: Responseable {
  public var data: SignInData?
  public var message: String
  public var success: Bool
}

public struct SignUpResponse: Responseable {
  public var data: SignUpData?
  public var message: String
  public var success: Bool
}
