//
//  File.swift
//  Beer Connect
//
//  Created by Apple on 31/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

struct FilterResponse: Codable {
    var cat_name : String?
    var term_id : Int?
    var subcategories : [Subcategory]?
    
    enum CodingKeys: String, CodingKey {
        
        case cat_name = "cat_name"
        case term_id = "term_id"
        case subcategories = "subcategories"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cat_name = try values.decodeIfPresent(String.self, forKey: .cat_name)
        term_id = try values.decodeIfPresent(Int.self, forKey: .term_id)
        subcategories = try values.decodeIfPresent([Subcategory].self, forKey: .subcategories)
    }
    
    init() {}
}

extension FilterResponse {
    func getFilterSubCategoryFrom(repsonseData: Data) -> FilterResponse? {
        do {
            let responseModel = try? JSONDecoder().decode(FilterResponse?.self,
                                                          from: repsonseData)
            if responseModel != nil {
                print("Response Modal is \(String(describing: responseModel))")
                return responseModel
            }
        }
        return FilterResponse.init()
    }
}
