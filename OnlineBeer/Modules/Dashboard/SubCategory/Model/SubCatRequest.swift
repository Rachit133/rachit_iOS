//
//  DashboardRequest.swift
//  Beer Connect
//
//  Created by Synsoft on 11/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SubCatRequest: Codable {
   var userId: String?
   var catId: String?
   var customerId: String?
   var currentPage: String?
   var orderBy: String?
   var minprice: String?
   var maxprice: String?
    
   enum CodingKeys: String, CodingKey {
      case userId = "user-id"
      case catId = "category-id"
      case customerId = "customer_id"
      case currentPage = "current_page"
      case orderBy = "order-by"
      case minprice = "minprice"
      case maxprice = "maxprice"
   }
   
   var dictionary: Parameter {
      var userDict = Parameter.init()
      userDict["user-id"] = self.userId
      userDict["category-id"] = self.catId
      userDict["customer_id"] = self.customerId
      userDict["current_page"] = self.currentPage
      userDict["maxprice"] = self.maxprice
      userDict["minprice"] = self.minprice
      userDict["order-by"] = self.orderBy
      return userDict
   }
   
   init() { }
   
   init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      userId = try values.decodeIfPresent(String.self, forKey: .userId)
      catId = try values.decodeIfPresent(String.self, forKey: .catId)
      customerId = try values.decodeIfPresent(String.self, forKey: .customerId)
      currentPage = try values.decodeIfPresent(String.self, forKey: .currentPage)
      orderBy = try values.decodeIfPresent(String.self, forKey: .orderBy)
      minprice = try values.decodeIfPresent(String.self, forKey: .minprice)
      maxprice = try values.decodeIfPresent(String.self, forKey: .maxprice)
   }
   
}

extension SubCatRequest {
   func getCatProductList(repsonseData: Data) -> SubCatResponse? {
      do {
         
         let responseModel = try? JSONDecoder().decode(SubCatResponse.self,
                                                       from: repsonseData)
         //print(responseModel?.products?.description as Any)
         //print(responseModel?.subcategories?.description as Any)
         
            if responseModel != nil {
               print("Response Modal is \(String(describing: responseModel))")
               return responseModel
            }
         }
      return SubCatResponse.init()
   }
}
