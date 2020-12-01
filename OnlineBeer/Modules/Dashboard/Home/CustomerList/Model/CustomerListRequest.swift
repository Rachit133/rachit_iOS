//
//  CustomerListRequest.swift
//  Beer Connect
//
//  Created by Apple on 30/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

struct CustomerListRequest: Codable {
   var search: String?
    var currentPage: String?
   enum CodingKeys: String, CodingKey {
     case search = "search"
     case currentPage = "current_page"
   }
   
   init() {}
   
   var dictionary: Parameter {
      var searchDict = Parameter.init()
      searchDict["search"] = self.search
      searchDict["current_page"] = self.currentPage
      return searchDict
   }
   
   init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      search = try values.decodeIfPresent(String.self, forKey: .search)
      currentPage = try values.decodeIfPresent(String.self, forKey: .currentPage)
   }
}
