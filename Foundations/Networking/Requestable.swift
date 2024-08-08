//
//  Requestable.swift
//  The North
//
//  Created by Naufal Al-Fachri on 03/08/24.
//

import Alamofire

public typealias Method = HTTPMethod
public typealias URLConvertible = Alamofire.URLConvertible
public typealias PCError = AFError

public protocol Requestable {
  func request<T: Responseable>(_ url: URLConvertible, method: Method, params: [String: Any], onComplete: @escaping (Result<T, PCError>) -> Void)
}

public class NetworkRequest: Requestable {
  
  public init() {}
  
  public func request<T>(_ url: any URLConvertible, method: Method, params: [String : Any], onComplete: @escaping (Result<T, PCError>) -> Void) where T : Responseable {
    AF.request(url, method: method, parameters: params)
      .responseDecodable(of: T.self) { dataResponse in
        switch dataResponse.result {
        case .success(let value):
          onComplete(.success(value))
        case .failure(let error):
          onComplete(.failure(error))
        }
      }
  }
}
