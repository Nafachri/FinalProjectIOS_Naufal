//
//  AuthenticationModule.swift
//  The North
//
//  Created by Naufal Al-Fachri on 03/08/24.
//

import UIKit
import Dependency
import Networking

public class AuthenticationModule: AuthenticationDependency {
  
  
  public static var bundle = Bundle(for: AuthenticationModule.self)
  public init() {}
  
  public func signinViewController(request: any Networking.Requestable = NetworkRequest()) -> UIViewController {
//        SignInViewController(nibName: "SignInViewController", bundle: AuthenticationModule.bundle)
    //    SignUpViewController(nibName: "SignUpViewController", bundle: AuthenticationModule.bundle)
    ChangePasswordViewController(nibName: "ChangePasswordViewController", bundle: AuthenticationModule.bundle)
    
  }
  
}
