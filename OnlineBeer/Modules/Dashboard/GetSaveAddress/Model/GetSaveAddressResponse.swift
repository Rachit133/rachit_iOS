////
////  GetSaveAddressResponse.swift
////  Beer Connect
////
////  Created by Synsoft on 21/02/20.
////  Copyright © 2020 Synsoft. All rights reserved.
////
//
//import Foundation
//
//// MARK: - GetSaveAddressResponse
//struct GetSaveAddressResponse: Codable {
//   var data: GetAddressData?
//   
//   enum CodingKeys: String, CodingKey {
//          case data = "data"
//     }
//       
//     init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        data = try container.decodeIfPresent(GetAddressData.self, forKey: .data)
//     }
//       
//       // Encoding
//     func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(data, forKey: .data)
//     }
//       
//     init() { }
//}
//
//// DataClass.swift
//
//import Foundation
//
//// MARK: - DataClass
//struct GetAddressData: Codable {
//   
//    var customerCountries: String?
//    var userDataStatus: Bool?
//    var customerStates: String?
//    var countries: Countries?
//    var success: Bool?
//    var message: String?
//    var deliveryDateSettings: DeliveryDateSettings?
//    var userData: UserData?
//   
//   enum CodingKeys: String, CodingKey {
//      case customerCountries = "customer_countries"
//      case userDataStatus = "user_data_status"
//      case customerStates = "customer_states"
//      case countries = "countries"
//      case success = "success"
//      case message = "message"
//      case deliveryDateSettings = "delivery_date_settings"
//      case userData = "user_data"
//   }
//      
//   init(from decoder: Decoder) throws {
//      let container = try decoder.container(keyedBy: CodingKeys.self)
//      customerCountries = try container.decodeIfPresent(String.self, forKey: .customerCountries)
//      userDataStatus = try container.decodeIfPresent(Bool.self, forKey: .userDataStatus)
//      customerStates = try container.decodeIfPresent(String.self, forKey: .customerStates)
//      countries = try container.decodeIfPresent(Countries.self, forKey: .countries)
//      success = try container.decodeIfPresent(Bool.self, forKey: .success)
//      message = try container.decodeIfPresent(String.self, forKey: .message)
//      deliveryDateSettings = try container.decodeIfPresent(DeliveryDateSettings.self, forKey: .deliveryDateSettings)
//      userData = try container.decodeIfPresent(String.self, forKey: .userData)
//   }
//     
//     // Encoding
//   func encode(to encoder: Encoder) throws {
//      var container = encoder.container(keyedBy: CodingKeys.self)
//      try container.encode(customerCountries, forKey: .customerCountries)
//      try container.encode(userDataStatus, forKey: .userDataStatus)
//      try container.encode(customerStates, forKey: .customerStates)
//      try container.encode(countries, forKey: .countries)
//      try container.encode(success, forKey: .success)
//      try container.encode(message, forKey: .message)
//      try container.encode(deliveryDateSettings, forKey: .deliveryDateSettings)
//      try container.encode(userData, forKey: .userData)
//
//   }
//     
//   init() { }
//   
//}
//
//// Countries.swift
//
//
//// MARK: - Countries
//struct Countries: Codable {
//    var us: String?
//}
//
//// MARK: - DeliveryDateSettings
//struct DeliveryDateSettings: Codable {
//    var holidayDate: [HolidayDate]?
//    var minimumDate: String?
//    var selectedDay: [String]?
//    var maximumDate, lastDayOfWeek, currentWeekDelivery: String?
//}
//
//// HolidayDate.swift
//
//import Foundation
//
//// MARK: - HolidayDate
//struct HolidayDate: Codable {
//    var date, dateTo, name: String?
//}
//
//// UserData.swift
//
//import Foundation
//
//// MARK: - UserData
//struct UserData: Codable {
//    var id: Int?
//    var shipping: Ing?
//    var dateModified: DateCreatedClass?
//    var metaData: [MetaDatum]?
//    var isPayingCustomer: Bool?
//    var firstName: String?
//    var dateCreated: DateCreatedClass?
//    var displayName, role, username, lastName: String?
//    var email: String?
//    var billing: Ing?
//}
//
//// Ing.swift
//
//import Foundation
//
//// MARK: - Ing
//struct Ing {
//    var phone, city, country, address1: String?
//    var lastName, company, postcode, email: String?
//    var address2, state, firstName: String?
//}
//
//// DateCreatedClass.swift
//
//import Foundation
//
//// MARK: - DateCreatedClass
//struct DateCreatedClass {
//    var date, timezone: String?
//    var timezoneType: Int?
//}
//
//// MetaDatum.swift
//
//import Foundation
//
//// MARK: - MetaDatum
//struct MetaDatum {
//    var id: Int?
//    var key: String?
//    var value: ValueUnion?
//}
//
//// ValueUnion.swift
//
//import Foundation
//
//enum ValueUnion {
//    case string(String)
//    case stringArray([String])
//    case valueClass(ValueClass)
//}
//
//// ValueClass.swift
//
//import Foundation
//
//// MARK: - ValueClass
//struct ValueClass {
//    var side, advanced, normal, column3: String?
//    var column4, acfAfterTitle: String?
//    var social: Social?
//    var phone: String?
//    var address: Address?
//    var showEmail: String?
//    var payment: Payment?
//    var location: String?
//    var banner: Int?
//    var storeName: String?
//    var wsoeAddonInstalled, wsoeSchedulerNoticeDisplay, wsoeAddonNoticeDisplay, wsoeSchedulerInstalled: Bool?
//    var atumOrdersWidget, atumStatisticsWidget, atumStockControlWidget, atumSalesWidget: AtumWidget?
//    var atumVideosWidget: AtumWidget?
//}
//
//// Address.swift
//
//import Foundation
//
//// MARK: - Address
//struct Address {
//    var state, country, street2, city: String?
//    var street1, zip: String?
//}
//
//// AtumWidget.swift
//
//import Foundation
//
//// MARK: - AtumWidget
//struct AtumWidget {
//    var y, x, height, width: String?
//}
//
//// Payment.swift
//
//import Foundation
//
//// MARK: - Payment
//struct Payment {
//    var paypal: [String]?
//    var bank: [Any?]?
//}
//
//// Social.swift
//
//import Foundation
//
//// MARK: - Social
//struct Social {
//    var flickr, youtube, twitter, linkedin: Bool?
//    var pinterest, instagram, gplus, fb: Bool?
//}
