//
//  LoginModal.swift
//  Beer Connect
//
//  Created by Synsoft on 21/01/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation
import SwiftyJSON

struct LoginRequest: Codable {
   var userEmail: String?
   var password: String?
   
   enum CodingKeys: String, CodingKey {
      case userEmail = "email"
      case password = "password"
   }
   
   var dictionary: Parameter {
      var userDict = Parameter.init()
      userDict["email"] = self.userEmail
      userDict["password"] = self.password
      return userDict
   }
   
   init() { }
   
   init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      userEmail = try values.decodeIfPresent(String.self, forKey: .userEmail)
      password = try values.decodeIfPresent(String.self, forKey: .password)
   }
   
}

extension LoginRequest {
   func getLoginDetails(repsonseData: Data) -> LoginResponse? {
      do {
            let responseModel = try? JSONDecoder().decode(LoginResponse.self,
                                                       from: repsonseData)
            if responseModel != nil {
               print("Response Modal is \(String(describing: responseModel))")
               return responseModel
            }
         }
      return LoginResponse.init()
   }
}
