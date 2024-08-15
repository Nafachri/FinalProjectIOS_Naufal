//
//  PaymentResponse.swift
//  The North
//
//  Created by Naufal Al-Fachri on 13/08/24.
//

import Foundation
import Networking

public struct PaymentResponse: Responseable {
    public var data: Networking.UserData?
    public var message: String
    public var success: Bool
}
