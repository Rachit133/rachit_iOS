//
//  OrderListRequest.swift
//  Beer Connect
//
//  Created by Synsoft on 17/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

// MARK: - DeleteCartRequest
struct OrderListRequest: Codable {
   var userId: String?
   var dateFrom: String?
   var dateTo: String?
   var status: String?
   var currentPage: String?

   enum CodingKeys: String, CodingKey {
      case userId = "user-id"
      case dateFrom = "date_from"
      case dateTo = "date_to"
      case status = "status"
      case currentPage = "current_page"
   }
   
   var dictionary: Parameter {
      var userDict = Parameter.init()
      userDict["user-id"] = self.userId
      userDict["date_from"] = self.dateFrom
      userDict["date_to"] = self.dateTo
      userDict["status"] = self.status
      userDict["current_page"] = self.currentPage
      return userDict
   }
   
   init() { }
   
   init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      userId = try values.decodeIfPresent(String.self, forKey: .userId)
      dateFrom = try values.decodeIfPresent(String.self, forKey: .dateFrom)
      dateTo = try values.decodeIfPresent(String.self, forKey: .dateTo)
      status = try values.decodeIfPresent(String.self, forKey: .status)
      currentPage = try values.decodeIfPresent(String.self, forKey: .currentPage)
    }
}
