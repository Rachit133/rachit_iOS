//
//  GetSaveAddressRequest.swift
//  Beer Connect
//
//  Created by Synsoft on 21/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

// MARK: - DeleteCartRequest
struct GetSaveAddressRequest: Codable {
   var customerId: Int?

   enum CodingKeys: String, CodingKey {
      case customerId = "customer_id"
   }
   
   var dictionary: Parameter {
      var userDict = Parameter.init()
      userDict["customer_id"] = self.customerId
      return userDict
   }
   
   init() { }
   
   init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      customerId = try values.decodeIfPresent(Int.self, forKey: .customerId)
   }
}
