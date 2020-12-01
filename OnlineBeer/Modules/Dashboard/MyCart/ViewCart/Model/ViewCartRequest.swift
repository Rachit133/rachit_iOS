//
//  AddToCartRequest.swift
//  Beer Connect
//
//  Created by Synsoft on 20/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

struct ViewCartRequest: Codable {
   var customerId: String?
   var cardId: String?
   
   enum CodingKeys: String, CodingKey {
      case customerId = "customer_id"
      case cardId = "cart_id"
   }
   
   var dictionary: Parameter {
      var userDict = Parameter.init()
      userDict["customer_id"] = self.customerId
      userDict["cart_id"] = self.cardId
      return userDict
   }
   
   init() { }
   
   init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      customerId = try values.decodeIfPresent(String.self, forKey: .customerId)
      cardId = try values.decodeIfPresent(String.self, forKey: .cardId)
   }
   
}
