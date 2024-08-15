//
//  Requestable.swift
//  The North
//
//  Created by Naufal Al-Fachri on 03/08/24.
//

import Alamofire
import Foundation

public typealias Method = HTTPMethod
public typealias URLConvertible = Alamofire.URLConvertible
public typealias PCError = RequestError
public typealias HTTPHeaders = Alamofire.HTTPHeaders

public struct RequestError: Error, LocalizedError {
  let message: String
  
  public var errorDescription: String? {
    NSLocalizedString(message, comment: "My error")
  }
}

public protocol Requestable {
  func request<T: Responseable>(_ url: URLConvertible, method: Method, params: [String: Any], headers: HTTPHeaders?, onComplete: @escaping (Result<T, PCError>) -> Void)
  func request<T: Responseable>(_ url: URLConvertible, method: Method, params: [String: Any], onComplete: @escaping (Result<T, PCError>) -> Void)
}

public class NetworkRequest: Requestable {
  
  public init() {}
  
  public func request<T>(_ url: any URLConvertible, method: Method, params: [String : Any], headers: HTTPHeaders? = nil, onComplete: @escaping (Result<T, PCError>) -> Void) where T : Responseable {
    AF.request(url,
               method: method,
               parameters: params,
               headers: headers)
    .responseDecodable(of: T.self) { dataResponse in
      switch dataResponse.result {
      case .success(let value):
        if value.success {
          onComplete(.success(value))
        } else {
          onComplete(.failure(
            RequestError(message: value.message)
          ))
        }
        
      case .failure(let error):
        onComplete(.failure(
          PCError(message: error.localizedDescription)
        ))
      }
    }
  }
  
  public func request<T>(_ url: any URLConvertible, method: Method, params: [String : Any], onComplete: @escaping (Result<T, PCError>) -> Void) where T : Responseable {
    request(url, method: method, params: params, headers: nil, onComplete: onComplete)
  }
}
