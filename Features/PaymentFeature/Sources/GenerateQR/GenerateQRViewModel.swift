//
//  GenerateQRViewModel.swift
//  PaymentFeature
//
//  Created by Naufal Al-Fachri on 12/08/24.
//

import RxSwift
import RxRelay
import RxCocoa
import Services
import Foundation

class GenerateQRViewModel {
  let amount = BehaviorRelay<String>(value: "")
  let isSuccess = PublishSubject<Bool>()
}
