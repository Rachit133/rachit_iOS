//
//  CustomerResponse.swift
//  Beer Connect
//
//  Created by Apple on 30/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

struct CustomerListResponse : Codable {
  var status : String?
  var message : String?
  var data : [CustomerListData]?
  var total: Int?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
        case total = "total"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([CustomerListData].self, forKey: .data)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
    }

    init() { }
}

struct CustomerListData : Codable {
   var customerData : CustomerDatum?
   var iD : Int?
   var caps : Caps?
   var cap_key : String?
   var roles : [String]?
   var allcaps : Allcaps?
   //var filter : String?

    enum CodingKeys: String, CodingKey {

        case customerData = "data"
        case iD = "ID"
        case caps = "caps"
        case cap_key = "cap_key"
        case roles = "roles"
        case allcaps = "allcaps"
       // case filter = "filter"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        customerData = try values.decodeIfPresent(CustomerDatum.self, forKey: .customerData)
        iD = try values.decodeIfPresent(Int.self, forKey: .iD)
        caps = try values.decodeIfPresent(Caps.self, forKey: .caps)
        cap_key = try values.decodeIfPresent(String.self, forKey: .cap_key)
        roles = try values.decodeIfPresent([String].self, forKey: .roles)
        allcaps = try values.decodeIfPresent(Allcaps.self, forKey: .allcaps)
        //filter = try values.decodeIfPresent(String.self, forKey: .filter)
    }
    init() { }

}

struct CustomerDatum : Codable {
        let displayName : String?
        let iD : String?
        let userActivationKey : String?
        let userEmail : String?
        let userLogin : String?
        let userNicename : String?
        let userPass : String?
        let userRegistered : String?
        let userStatus : String?
        let userUrl : String?

        enum CodingKeys: String, CodingKey {
                case displayName = "display_name"
                case iD = "ID"
                case userActivationKey = "user_activation_key"
                case userEmail = "user_email"
                case userLogin = "user_login"
                case userNicename = "user_nicename"
                case userPass = "user_pass"
                case userRegistered = "user_registered"
                case userStatus = "user_status"
                case userUrl = "user_url"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                displayName = try values.decodeIfPresent(String.self, forKey: .displayName)
                iD = try values.decodeIfPresent(String.self, forKey: .iD)
                userActivationKey = try values.decodeIfPresent(String.self, forKey: .userActivationKey)
                userEmail = try values.decodeIfPresent(String.self, forKey: .userEmail)
                userLogin = try values.decodeIfPresent(String.self, forKey: .userLogin)
                userNicename = try values.decodeIfPresent(String.self, forKey: .userNicename)
                userPass = try values.decodeIfPresent(String.self, forKey: .userPass)
                userRegistered = try values.decodeIfPresent(String.self, forKey: .userRegistered)
                userStatus = try values.decodeIfPresent(String.self, forKey: .userStatus)
                userUrl = try values.decodeIfPresent(String.self, forKey: .userUrl)
        }

}


struct Caps : Codable {
    var customer : Bool?
    enum CodingKeys: String, CodingKey {
        case customer = "customer"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        customer = try values.decodeIfPresent(Bool.self, forKey: .customer)
    }
    init() { }

}

struct Allcaps : Codable {

  var read : Bool?
  var edit_posts : Bool?
  var delete_posts : Bool?
  var customer : Bool?

    enum CodingKeys: String, CodingKey {
        case read = "read"
        case edit_posts = "edit_posts"
        case delete_posts = "delete_posts"
        case customer = "customer"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        read = try values.decodeIfPresent(Bool.self, forKey: .read)
        edit_posts = try values.decodeIfPresent(Bool.self, forKey: .edit_posts)
        delete_posts = try values.decodeIfPresent(Bool.self, forKey: .delete_posts)
        customer = try values.decodeIfPresent(Bool.self, forKey: .customer)
    }
    init() { }
}

extension CustomerListResponse {
   func getCustomerListFrom(repsonseData: Data) -> CustomerListResponse? {
      do {
         let responseModel = try? JSONDecoder().decode(CustomerListResponse?.self,
                                                       from: repsonseData)
         if responseModel != nil {
            print("Response Modal is \(String(describing: responseModel))")
            return responseModel
         }
      }
      return CustomerListResponse.init()
   }
}


