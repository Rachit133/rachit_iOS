//
//  Search.swift
//  Beer Connect
//
//  Created by Synsoft on 06/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

struct SearchRequest: Codable {
   var search: String?
   var customerId: String?
   var categoryId: String?
   var orderBy: String?
   var currentPage: String?
   var minPrice: String?
   var maxPrice: String?

   enum CodingKeys: String, CodingKey {
      case search = "search"
      case customerId = "user-id"
      case categoryId = "category-id"
      case orderBy = "order-by"
      case minPrice = "minprice"
      case maxPrice = "maxprice"
      case currentPage = "current_page"
   }
   
   init() { }
   
   var dictionary: Parameter {
      var searchDict = Parameter.init()
      searchDict["search"] = self.search
      searchDict["user-id"] = self.customerId
      searchDict["category-id"] = self.categoryId
      searchDict["order-by"] = self.orderBy
      searchDict["minprice"] = self.minPrice
      searchDict["maxprice"] = self.maxPrice
      searchDict["current_page"] = self.currentPage
      return searchDict
   }
   
   init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      search = try values.decodeIfPresent(String.self, forKey: .search)
      customerId = try values.decodeIfPresent(String.self, forKey: .customerId)
      categoryId = try values.decodeIfPresent(String.self, forKey: .categoryId)
      orderBy = try values.decodeIfPresent(String.self, forKey: .orderBy)
      minPrice = try values.decodeIfPresent(String.self, forKey: .minPrice)
      maxPrice = try values.decodeIfPresent(String.self, forKey: .maxPrice)
      currentPage = try values.decodeIfPresent(String.self, forKey: .currentPage)
   }
}

extension SearchRequest {
   func getSearchProductDetails(repsonseData: Data) -> SearchResponse? {
      do {
            let responseModel = try? JSONDecoder().decode(SearchResponse.self,
                                                       from: repsonseData)
            if responseModel != nil {
               print("Response Modal is \(String(describing: responseModel))")
               return responseModel
            }
         }
      return SearchResponse.init()
   }
}
