//
//  AdminCustomerLoginRequest.swift
//  Beer Connect
//
//  Created by Apple on 08/04/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

struct AdminCustomerLoginRequest: Codable {
   var id: String?
   var tokenId: String?

   enum CodingKeys: String, CodingKey {
      case id = "id"
      case tokenId = "token_id"
   }
   
   var dictionary: Parameter {
      var userDict = Parameter.init()
      userDict["id"] = self.id
      userDict["token_id"] = self.tokenId
      return userDict
   }
   
   init() { }
   
   init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      id = try values.decodeIfPresent(String.self, forKey: .id)
      tokenId = try values.decodeIfPresent(String.self, forKey: .tokenId)
   }
   
}

extension AdminCustomerLoginRequest {
   func getCustomerLoginDetails(repsonseData: Data) -> LoginResponse? {
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
