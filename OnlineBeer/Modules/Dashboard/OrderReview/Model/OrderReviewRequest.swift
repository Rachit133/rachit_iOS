//
//  OrderReviewRequest.swift
//  Beer Connect
//
//  Created by Synsoft on 02/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

// MARK: - DeleteCartRequest
struct OrderReviewRequest: Codable {
   var customerId: String?
   
   enum CodingKeys: String, CodingKey {
      case customerId = "customer_id"
   }
   
   init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        customerId = try values.decodeIfPresent(String.self, forKey: .customerId)
   }
   
   var dictionary: Parameter {
      var userDict = Parameter.init()
      userDict["customer_id"] = self.customerId
      return userDict
   }
   
   init() { }
   
  
}
