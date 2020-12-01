//
//  DashboardRequest.swift
//  Beer Connect
//
//  Created by Synsoft on 11/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation
import SwiftyJSON

struct DashboardRequest: Codable {
   var userId: String?
   
   enum CodingKeys: String, CodingKey {
      case userId = "user-id"
   }
   
   var dictionary: Parameter {
      var userDict = Parameter.init()
      userDict["user-id"] = self.userId
      return userDict
   }
   
   init() { }
   
   init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      userId = try values.decodeIfPresent(String.self, forKey: .userId)
   }
   
}

struct DashboardCatRequest: Codable {
   var userId: String?
   var catId: String?
   var customerId: String?
   var currentPage: String?
   
   enum CodingKeys: String, CodingKey {
      case userId = "user-id"
      case catId = "category-id"
      case customerId = "customer_id"
      case currentPage = "current_page"
   }
   
   var dictionary: Parameter {
      var userDict = Parameter.init()
      userDict["user-id"] = self.userId
      userDict["category-id"] = self.catId
      userDict["customer_id"] = self.customerId
      userDict["current_page"] = self.currentPage
      return userDict
   }
   
   init() { }
   
   init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      userId = try values.decodeIfPresent(String.self, forKey: .userId)
      catId = try values.decodeIfPresent(String.self, forKey: .catId)
      customerId = try values.decodeIfPresent(String.self, forKey: .customerId)
      currentPage = try values.decodeIfPresent(String.self, forKey: .currentPage)
   }
}

extension DashboardRequest {
   func getProductList(repsonseData: Data) -> DashboardResponse? {
      do {
         let responseModel = try? JSONDecoder().decode(DashboardResponse.self,
                                                       from: repsonseData)
         if responseModel != nil {
            print("Response Modal is \(String(describing: responseModel))")
            return responseModel
         } else {
            return DashboardResponse.init()
         }
      }
   }
}

