//
//  SetWishlistRequest.swift
//  Beer Connect
//
//  Created by Synsoft on 22/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

struct SetWishListRequest: Codable {
   var userId: String?
   var productId: String?
   
   enum CodingKeys: String, CodingKey {
      case userId = "user-id"
      case productId = "product-id"
   }
   
   var dictionary: Parameter {
      var userDict = Parameter.init()
      userDict["user-id"] = self.userId
      userDict["product-id"] = self.productId
      return userDict
   }
   
   init() { }
   
   init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      userId = try values.decodeIfPresent(String.self, forKey: .userId)
      productId = try values.decodeIfPresent(String.self, forKey: .productId)
   }
}

