//
//  RemoveProductRequest.swift
//  Beer Connect
//
//  Created by Synsoft on 20/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

struct RemoveProductRequest: Codable {
   
   var productId: String?
   var variationId: String?
   var customerId: String?

   enum CodingKeys: String, CodingKey {
      case productId = "product_id"
      case variationId = "variation_id"
      case customerId = "customer_id"
   }
   
   var dictionary: Parameter {
      var userDict = Parameter.init()
      userDict["product_id"] = self.productId
      userDict["variation_id"] = self.variationId
      userDict["customer_id"] = self.customerId
      return userDict
   }
   
   init() { }
   
   init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      productId = try values.decodeIfPresent(String.self, forKey: .productId)
      variationId = try values.decodeIfPresent(String.self, forKey: .variationId)
      customerId = try values.decodeIfPresent(String.self, forKey: .customerId)
   }
}
