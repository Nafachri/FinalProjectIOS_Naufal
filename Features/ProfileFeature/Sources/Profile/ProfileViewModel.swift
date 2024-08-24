//
//  ProfileViewModel.swift
//  ProfileFeature
//
//  Created by Naufal Al-Fachri on 05/08/24.
//

import RxSwift
import RxRelay
import RxCocoa
import NetworkManager
import UIKit
import Alamofire
import KeychainSwift

class ProfileViewModel {
  private let APIService = APIManager.shared
  private let disposeBag = DisposeBag()
  
  let username = BehaviorRelay<String>(value: "")
  let email = BehaviorRelay<String>(value: "")
  let phoneNumber = BehaviorRelay<String>(value: "")
  let avatar = BehaviorRelay<UIImage?>(value: nil)
  let confirmEdit = PublishSubject<Void>()
  
  var usernameError: Driver<String?>!
  var emailError: Driver<String?>!
  var phoneNumberError: Driver<String?>!
  var showConfirmButton: Driver<Bool>!
  
  let isLoading = BehaviorRelay<Bool>(value: false)
  let errorMessage = PublishSubject<String?>()
  let isSuccess = PublishSubject<Bool>()
  
  let isSuccessUpdate = PublishSubject<Bool>()
  let editButtonTapped = PublishSubject<Void>()
  let confirmButtonTapped = PublishSubject<Void>()
  let isEditing = BehaviorRelay<Bool>(value: false)
  
  var profileData = BehaviorRelay<ProfileResponse?>(value: nil)
  
  init(){}

  func fetchProfile() {
    APIService.fetchRequest(endpoint: .profile, expecting: ProfileResponse.self) { [weak self] result in
      guard let self else { return }
      isLoading.accept(false)
      switch result {
      case .success(let response):
        profileData.accept(response)
      case .failure(let error):
        errorMessage.onNext(error.localizedDescription)
      }
    }
  }

  func uploadProfileData(param: ProfileParam?) {
    let url = "https://thenorthpay.phincon.site/update-profile"
    
    let parameters: [String: Any] = [
      "email": param?.email ?? "",
      "phoneNumber": param?.phoneNumber ?? "",
    ]
    
    let keychain = KeychainSwift()
    let token = keychain.get("userToken")
    
    var header: HTTPHeaders {
       return [
        "Content-Type": "application/json",
        "Authorization": "Bearer \(token ?? "")"
      ]
    }
    
    AF.upload(multipartFormData: { multipartFormData in
      for (key, value) in parameters {
        if let stringValue = value as? String {
          multipartFormData.append(Data(stringValue.utf8), withName: key)
        }
      }
    }, to: url, method: .post, headers: header)
    .responseDecodable(of: GlobalMessageResponse.self) { response in
      switch response.result {
      case .success(let profileResponse):
        self.isSuccessUpdate.onNext(true)
        print("Upload successful: \(profileResponse.message)")
      case .failure(let error):
        print("Upload failed: \(error)")
      }
    }
  }
}

