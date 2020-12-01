//
//  ForgotPassRequest.swift
//  Beer Connect
//
//  Created by Apple on 02/04/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

struct ForgotPassRequest: Codable {
   var userEmail: String?
   
   enum CodingKeys: String, CodingKey {
      case userEmail = "email"
   }
   
   var dictionary: Parameter {
      var userDict = Parameter.init()
      userDict["email"] = self.userEmail
      return userDict
   }
   
   init() { }
   
   init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      userEmail = try values.decodeIfPresent(String.self, forKey: .userEmail)
   }
}

