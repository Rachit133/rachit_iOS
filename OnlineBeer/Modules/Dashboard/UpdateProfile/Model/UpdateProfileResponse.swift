//
//  UpdateProfileResponse.swift
//  Beer Connect
//
//  Created by Apple on 20/04/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

struct UpdateProfileResponse : Codable {
    var updateData : UpdateData?

    enum CodingKeys: String, CodingKey {
        case updateData = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        updateData = try values.decodeIfPresent(UpdateData.self, forKey: .updateData)
    }

    init() {}
}

struct UpdateData : Codable {
    var customer : CustomerProfile?
    var status : String?

    enum CodingKeys: String, CodingKey {
        case customer = "customer"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        customer = try values.decodeIfPresent(CustomerProfile.self, forKey: .customer)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }

    init() {}
}

extension UpdateProfileResponse {
   func getSaveUserProfileData(repsonseData: Data) -> UpdateProfileResponse? {
      do {
         let responseModel = try? JSONDecoder().decode(UpdateProfileResponse?.self,
                                                       from: repsonseData)
         if responseModel != nil {
            print("Response Modal is \(String(describing: responseModel))")
            return responseModel
         }
      }
      return UpdateProfileResponse.init()
   }
}
