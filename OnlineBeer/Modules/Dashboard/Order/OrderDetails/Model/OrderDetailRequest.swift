//
//  OrderDetailRequest.swift
//  Beer Connect
//
//  Created by Synsoft on 17/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

// MARK: - DeleteCartRequest
struct OrderDetailsRequest: Codable {
   var userId: String?
   var orderId: String?
   
   enum CodingKeys: String, CodingKey {
      case userId = "user-id"
      case orderId = "order-id"
   }
   
   var dictionary: Parameter {
      var userDict = Parameter.init()
      userDict["user-id"] = self.userId
      userDict["order-id"] = self.orderId
      return userDict
   }
   
   init() { }
   
   init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      userId = try values.decodeIfPresent(String.self, forKey: .userId)
      orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
   }
}

// MARK: - Email/ Download Paramter Request To Server
struct OrderEmailDownloadRequest: Codable {
  var orderId: String?
  var actionType: String?
   var emailTo: String?
   
   enum CodingKeys: String, CodingKey {
     case orderId = "order_id"
     case actionType = "action"
      case emailTo = "email_to"
   }
   
   var dictionary: Parameter {
      var userDict = Parameter.init()
      userDict["action"] = self.actionType
      userDict["order_id"] = self.orderId
      userDict["email_to"] = self.emailTo
      return userDict
   }
   
   init() { }
   
   init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      actionType = try values.decodeIfPresent(String.self, forKey: .actionType)
      orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
      emailTo = try values.decodeIfPresent(String.self, forKey: .emailTo)
      
   }
}
