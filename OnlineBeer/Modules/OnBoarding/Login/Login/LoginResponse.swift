//
//  LoginResponse.swift
//  Beer Connect
//
//  Created by Synsoft on 05/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
   
   var data: DataClass?

   enum CodingKeys: String, CodingKey {
      case data = "data"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      data = try container.decodeIfPresent(DataClass.self, forKey: .data)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(data, forKey: .data)
   }
   
   init() { }
}

// MARK: - DataClass
struct DataClass: Codable {
   
    var message: String?
    var customer: Customer?
    var locale: Locale?
    var status: String?

   enum CodingKeys: String, CodingKey {
      case message = "message"
      case customer = "customer"
      case locale = "locale"
      case status = "status"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      message = try container.decodeIfPresent(String.self, forKey: .message)
      customer = try container.decodeIfPresent(Customer.self, forKey: .customer)
      locale = try container.decodeIfPresent(Locale.self, forKey: .locale)
      status = try container.decodeIfPresent(String.self, forKey: .status)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(message, forKey: .message)
      try container.encode(customer, forKey: .customer)
      try container.encode(locale, forKey: .locale)
      try container.encode(status, forKey: .status)
   }
   
}

// MARK: - Customer
struct Customer: Codable {
   var hash: String?
   var cartCountStatus: CartCountStatus?
   var customerID, customerEmail, customerName: String?
   var salePerson: Bool?
   
   enum CodingKeys: String, CodingKey {
      case hash = "hash"
      case cartCountStatus = "cart_count_status"
      case customerID = "customer_id"
      case customerName = "user_login"
      case customerEmail = "customer_email"
      case salePerson = "sales_person"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      hash = try container.decodeIfPresent(String.self, forKey: .hash)
      cartCountStatus = try container.decodeIfPresent(CartCountStatus.self, forKey: .cartCountStatus)
      customerID = try container.decodeIfPresent(String.self, forKey: .customerID)
      customerEmail = try container.decodeIfPresent(String.self, forKey: .customerEmail)
      customerName = try container.decodeIfPresent(String.self, forKey: .customerName)
      salePerson = try container.decodeIfPresent(Bool.self, forKey: .salePerson)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(hash, forKey: .hash)
      try container.encode(cartCountStatus, forKey: .cartCountStatus)
      try container.encode(customerID, forKey: .customerID)
      try container.encode(customerEmail, forKey: .customerEmail)
      try container.encode(salePerson, forKey: .salePerson)
      try container.encode(customerName, forKey: .customerName)
   }
}

// MARK: - CartCountStatus
struct CartCountStatus: Codable {
    var status: Bool?
    var cartCount: Int? = 0
   
   enum CodingKeys: String, CodingKey {
        case status = "status"
        case cartCount = "cart_count"
     }
     
     init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(Bool.self, forKey: .status)
        cartCount = try container.decodeIfPresent(Int.self, forKey: .cartCount)
     }
     
     // Encoding
     func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(status, forKey: .status)
        try container.encode(cartCount, forKey: .cartCount)
     }
}

// MARK: - Locale
struct Locale: Codable {
   
   var name, id: String?
   
   enum CodingKeys: String, CodingKey {
      case name = "name"
      case id = "id"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      name = try container.decodeIfPresent(String.self, forKey: .name)
      id = try container.decodeIfPresent(String.self, forKey: .id)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(name, forKey: .name)
      try container.encode(id, forKey: .id)
   }
}
