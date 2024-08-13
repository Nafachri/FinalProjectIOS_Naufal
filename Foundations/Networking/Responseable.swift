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
//  var username: String?
  var id: String?
  var email: String?
//  var phoneNumber: String?
  var token: String?
}

public protocol Responseable: Decodable {
  var data: UserData? { get set }
  var message: String { get }
  var success: Bool { get }
}
