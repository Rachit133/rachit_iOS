//
//  ShippingDetailsRequest.swift
//  Beer Connect
//
//  Created by Synsoft on 26/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

// MARK: - ShippingDetailResponse
struct ShippingDetailResponse: Codable {
   
   var data: ShippingDataClass?
   
   enum CodingKeys: String, CodingKey {
      case data = "data"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      data = try container.decodeIfPresent(ShippingDataClass.self, forKey: .data)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(data, forKey: .data)
   }
   
   init() { }
}

// MARK: - DataClass
struct ShippingDataClass: Codable {
   var success: Bool?
   var message: String?
   var userData: UserData?
   var userDataStatus: Bool?
   var customerCountries, customerStates: String?
   var countries: [String:String]?
   var deliveryDateSettings: DeliveryDateSettings?
   
   enum CodingKeys: String, CodingKey {
      case success = "success"
      case message = "message"
      case userData = "user_data"
      case userDataStatus = "user_data_status"
      case customerCountries = "customer_countries"
      case customerStates = "customer_states"
      case countries = "countries"
      case deliveryDateSettings = "delivery_date_settings"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      success = try container.decodeIfPresent(Bool.self, forKey: .success)
      message = try container.decodeIfPresent(String.self, forKey: .message)
      userData = try container.decodeIfPresent(UserData.self, forKey: .userData)
      userDataStatus = try container.decodeIfPresent(Bool.self, forKey: .userDataStatus)
      customerCountries = try container.decodeIfPresent(String.self, forKey: .customerCountries)
      customerStates = try container.decodeIfPresent(String.self, forKey: .customerStates)
      countries = try container.decodeIfPresent([String:String].self, forKey: .countries)
      deliveryDateSettings = try container.decodeIfPresent(DeliveryDateSettings.self, forKey: .deliveryDateSettings)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(success, forKey: .success)
      try container.encode(message, forKey: .message)
      try container.encode(userData, forKey: .userData)
      try container.encode(userDataStatus, forKey: .userDataStatus)
      try container.encode(customerCountries, forKey: .customerCountries)
      try container.encode(customerStates, forKey: .customerStates)
      try container.encode(countries, forKey: .countries)
      try container.encode(deliveryDateSettings, forKey: .deliveryDateSettings)
   }
   
   init() { }
}

// Countries.swift


// MARK: - Countries
struct Countries: Codable {
   var us: String?
   
   enum CodingKeys: String, CodingKey {
      case us = "us"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      us = try container.decodeIfPresent(String.self, forKey: .us)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(us, forKey: .us)
   }
   init() { }
}

// MARK: - DeliveryDateSettings
struct DeliveryDateSettings: Codable {
   var selectedDay: [String]?
   var minimumDate, maximumDate, lastDayOfWeek, currentWeekDelivery: String?
   var holidayDate: [HolidayDate]?
   
   enum CodingKeys: String, CodingKey {
      case selectedDay = "selected_day"
      case minimumDate = "minimum_date"
      case maximumDate = "maximum_date"
      case lastDayOfWeek = "last_day_of_week"
      case currentWeekDelivery = "current_week_delivery"
      case holidayDate = "holiday_date"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      selectedDay = try container.decodeIfPresent([String].self, forKey: .selectedDay)
      minimumDate = try container.decodeIfPresent(String.self, forKey: .minimumDate)
      maximumDate = try container.decodeIfPresent(String.self, forKey: .maximumDate)
      lastDayOfWeek = try container.decodeIfPresent(String.self, forKey: .lastDayOfWeek)
      currentWeekDelivery = try container.decodeIfPresent(String.self, forKey: .currentWeekDelivery)
      holidayDate = try container.decodeIfPresent([HolidayDate].self, forKey: .holidayDate)
      
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(selectedDay, forKey: .selectedDay)
      try container.encode(minimumDate, forKey: .minimumDate)
      try container.encode(maximumDate, forKey: .maximumDate)
      try container.encode(lastDayOfWeek, forKey: .lastDayOfWeek)
      try container.encode(currentWeekDelivery, forKey: .currentWeekDelivery)
      try container.encode(holidayDate, forKey: .holidayDate)
   }
   
   init() { }
}

// MARK: - HolidayDate
struct HolidayDate: Codable {
   var date, dateTo, name: String?
   
   enum CodingKeys: String, CodingKey {
      case date = "date"
      case dateTo = "date_to"
      case name = "name"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      date = try container.decodeIfPresent(String.self, forKey: .date)
      dateTo = try container.decodeIfPresent(String.self, forKey: .dateTo)
      name = try container.decodeIfPresent(String.self, forKey: .name)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(date, forKey: .date)
      try container.encode(dateTo, forKey: .dateTo)
      try container.encode(name, forKey: .name)
   }
   
   init() { }
}

// MARK: - UserData
struct UserData: Codable {
   var id: Int?
   var dateCreated, dateModified: ShippingDateCreated?
   var email, firstName, lastName, displayName: String?
   var role, username: String?
   var billing, shipping: Shipping?
   var isPayingCustomer: Bool?
  // var metaData: [ShippingMetaDatum]?
   
   enum CodingKeys: String, CodingKey {
        case id = "id"
        case dateCreated = "date_created"
        case dateModified = "date_modified"
        case email = "email"
        case firstName = "first_name"
        case lastName = "last_name"
        case displayName = "display_name"
        case role = "role"
        case username = "username"
        case billing = "billing"
        case shipping = "shipping"
        case isPayingCustomer = "is_paying_customer"
     }
     
     init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        dateCreated = try container.decodeIfPresent(ShippingDateCreated.self, forKey: .dateCreated)
        dateModified = try container.decodeIfPresent(ShippingDateCreated.self, forKey: .dateModified)
        email = try container.decodeIfPresent(String.self, forKey: .email)
      firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
      lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
      displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
      role = try container.decodeIfPresent(String.self, forKey: .role)
      username = try container.decodeIfPresent(String.self, forKey: .username)
      billing = try container.decodeIfPresent(Shipping.self, forKey: .billing)
      shipping = try container.decodeIfPresent(Shipping.self, forKey: .shipping)
      isPayingCustomer = try container.decodeIfPresent(Bool.self, forKey: .isPayingCustomer)
     }
     
     // Encoding
     func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(dateModified, forKey: .dateModified)
         try container.encode(email, forKey: .email)
         try container.encode(firstName, forKey: .firstName)
         try container.encode(lastName, forKey: .lastName)
         try container.encode(displayName, forKey: .displayName)
         try container.encode(role, forKey: .role)
         try container.encode(username, forKey: .username)
         try container.encode(billing, forKey: .billing)
         try container.encode(shipping, forKey: .shipping)
         try container.encode(isPayingCustomer, forKey: .isPayingCustomer)
     }
   init() {}
}

// MARK: - Ing
struct Shipping: Codable {
   var firstName, lastName, company, address1: String?
   var address2, city, postcode, country: String?
   var state, email, phone: String?
   
   enum CodingKeys: String, CodingKey {
      case firstName = "first_name"
      case lastName = "last_name"
      case company = "company"
      case address1 = "address_1"
      case address2 = "address_2"
      case city = "city"
      case postcode = "postcode"
      case country = "country"
      case state = "state"
      case email = "email"
      case phone = "phone"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      email = try container.decodeIfPresent(String.self, forKey: .email)
      phone = try container.decodeIfPresent(String.self, forKey: .phone)
      firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
      lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
      company = try container.decodeIfPresent(String.self, forKey: .company)
      address1 = try container.decodeIfPresent(String.self, forKey: .address1)
      address2 = try container.decodeIfPresent(String.self, forKey: .address2)
      city = try container.decodeIfPresent(String.self, forKey: .city)
      postcode = try container.decodeIfPresent(String.self, forKey: .postcode)
      country = try container.decodeIfPresent(String.self, forKey: .country)
      state = try container.decodeIfPresent(String.self, forKey: .state)
   }
}

// DateCreatedClass.swift

import Foundation

// MARK: - DateCreatedClass
struct ShippingDateCreated: Codable {
   var date: String?
   var timezoneType: Int?
   var timezone: String?
   
   enum CodingKeys: String, CodingKey {
      case date = "date"
      case timezoneType = "timezoneType"
      case timezone = "timezone"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      date = try container.decodeIfPresent(String.self, forKey: .date)
      timezoneType = try container.decodeIfPresent(Int.self, forKey: .timezoneType)
      timezone = try container.decodeIfPresent(String.self, forKey: .timezone)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(date, forKey: .date)
      try container.encode(timezoneType, forKey: .timezoneType)
      try container.encode(timezone, forKey: .timezone)
   }
}

// MARK: - MetaDatum
struct ShippingMetaDatum: Codable {
  
   var id: Int?
   var key: String?
   var value: ValueUnion?
   
   enum CodingKeys: String, CodingKey {
        case id = "id"
        case key = "key"
        //case value = "value"
     }
     
     init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        key = try container.decodeIfPresent(String.self, forKey: .key)
        //value = try container.decodeIfPresent(String.self, forKey: .value)
     }
     
     // Encoding
     func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(key, forKey: .key)
       // try container.encode(value, forKey: .value)
     }
}

// ValueUnion.swift
enum ValueUnion {
   //case string(String)
   //case valueClass(ValueClass)
}

// MARK: - ValueClass
//struct ValueClass {
 //  var ip: String?
//}


extension ShippingDetailResponse {
   func getShippingDetailsFrom(repsonseData: Data) -> ShippingDetailResponse? {
      do {
            let responseModel = try? JSONDecoder().decode(ShippingDetailResponse?.self,
                                                       from: repsonseData)
            if responseModel != nil {
               print("Response Modal is \(String(describing: responseModel))")
               return responseModel
            }
         }
      return ShippingDetailResponse.init()
   }
}
