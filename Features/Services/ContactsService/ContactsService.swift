//
//  ContactsService.swift
//  ContactsFeature
//
//  Created by Naufal Al-Fachri on 07/08/24.
//

import Foundation
import Networking

public protocol ContactsServiceable {
  func getContacts(onComplete: @escaping (Result<ContactsResponse, PCError>) -> Void)
  func getContactById(id: String, onComplete: @escaping (Result<ContactsResponse, PCError>) -> Void)
}

public class ContactsService: ContactsServiceable {
  
  let requestor: Requestable
  let baseAPI = "http://localhost:3001"
  
  public init(requestor: Requestable = NetworkRequest()){
    self.requestor = requestor
  }
  
  public func getContacts(onComplete: @escaping (Result<ContactsResponse, PCError>) -> Void) {
    requestor.request("\(baseAPI)", method: .get, params: [:], onComplete: onComplete)
  }
  
  public func getContactById(id: String, onComplete: @escaping (Result<ContactsResponse, PCError>) -> Void) {
    requestor.request("\(baseAPI)", method: .get, params: ["id": id], onComplete: onComplete)
  }
}
