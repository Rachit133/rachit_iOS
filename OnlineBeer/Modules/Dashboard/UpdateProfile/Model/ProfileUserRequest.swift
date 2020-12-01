
//
//  ProfileUser.swift
//  Beer Connect
//
//  Created by Apple on 20/04/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

struct ProfileUserResponse: Codable {
    var userProfileData : UserProfileData?

    enum CodingKeys: String, CodingKey {

        case userProfileData = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userProfileData = try values.decodeIfPresent(UserProfileData.self, forKey: .userProfileData)
    }
    init(){}
}

struct UserProfileData: Codable {
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

struct CustomerProfile: Codable {
   var id : String?
   var email : String?
   var user_name : String?
   var display_name : String?
   var first_name : String?
   var last_name : String?
   var user_mobile : String?
   var message: String?
   var status: String?
    
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case email = "email"
        case user_name = "user_name"
        case display_name = "display_name"
        case first_name = "first_name"
        case last_name = "last_name"
        case user_mobile = "user_mobile"
        case message = "message"
        case status = "status"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        user_name = try values.decodeIfPresent(String.self, forKey: .user_name)
        display_name = try values.decodeIfPresent(String.self, forKey: .display_name)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        user_mobile = try values.decodeIfPresent(String.self, forKey: .user_mobile)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)

    }
    init() {}
}

extension ProfileUserResponse {
   func getUserProfileFrom(repsonseData: Data) -> ProfileUserResponse? {
      do {
         let responseModel = try? JSONDecoder().decode(ProfileUserResponse?.self,
                                                       from: repsonseData)
         if responseModel != nil {
            print("Response Modal is \(String(describing: responseModel))")
            return responseModel
         }
      }
      return ProfileUserResponse.init()
   }
}
