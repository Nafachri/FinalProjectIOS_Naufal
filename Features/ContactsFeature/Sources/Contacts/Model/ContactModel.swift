//
//  ContactModel.swift
//  PaymentFeature
//
//  Created by Naufal Al-Fachri on 13/08/24.
//

import Foundation
import Dependency

struct Contact: Modelable {
  let image: String?
  let username: String
  let phoneNumber: String
  let id : String
  let email: String
}
