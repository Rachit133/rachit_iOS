//
//  DeleteCartRequest.swift
//  Beer Connect
//
//  Created by Synsoft on 20/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

struct RemoveItemRequest: Codable {
   var customerId: String?
   var productId: String?
   var variationId: String?

   enum CodingKeys: String, CodingKey {
      case customerId = "customer_id"
      case productId = "product_id"
      case variationId = "variation_id"
   }
   
   var dictionary: Parameter {
      var userDict = Parameter.init()
      userDict["customer_id"] = self.customerId
      userDict["product_id"] = self.productId
      userDict["variation_id"] = self.variationId

      return userDict
   }
   
   init() { }
   
   init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      customerId = try values.decodeIfPresent(String.self, forKey: .customerId)
      productId = try values.decodeIfPresent(String.self, forKey: .productId)
      variationId = try values.decodeIfPresent(String.self, forKey: .variationId)

   }
}
