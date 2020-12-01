//
//  ShippingSaveRequest.swift
//  Beer Connect
//
//  Created by Synsoft on 16/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ShippingSaveRequest {
    
    var customerId: String?
    var cartId: String?
    var firstName: String?
    var lastName: String?
    var companyName: String?
    var address1: String?
    var address2: String?
    var city: String?
    var postCode: String?
    var phone: String?
    var email: String?
    var country: String?
    var state: String?
    var deliveryDate: String?
    var shipToSame: String?
    var poNumber: String?
    var orderNote: String?
    
    var billingFirstName: String?
    var billingLastName: String?
    var billingCompany: String?
    var billingAddress1: String?
    var billingAddress2: String?
    var billingCity: String?
    var billingPostcode: String?
    var billingCountry: String?
    var billingState: String?
    
    var dictionary: Parameter {
        var userDict = Parameter.init()
        
        userDict["customer_id"] = self.customerId
        userDict["card-id"] = self.cartId
        userDict["shipping_first_name"] = self.firstName
        userDict["shipping_last_name"] = self.lastName
        userDict["shipping_company"] = self.companyName
        userDict["shipping_address_1"] = self.address1
        userDict["shipping_address_2"] = self.address2
        userDict["shipping_city"] = self.city
        userDict["shipping_state"] = self.state
        userDict["shipping_postcode"] = self.postCode
        userDict["shipping_country"] = self.country
        userDict["billing_phone"] = self.phone
        userDict["billing_email"] = self.email
        userDict["ship_to_same"] = self.shipToSame
        
        userDict["billing_first_name"] = self.billingFirstName
        userDict["billing_last_name"] = self.billingLastName
        userDict["billing_company"] = self.billingCompany
        userDict["billing_address_1"] = self.billingAddress1
        userDict["billing_address_2"] = self.billingAddress2
        userDict["billing_city"] = self.billingCity
        userDict["billing_postcode"] = self.billingPostcode
        userDict["billing_country"] = self.billingCountry
        userDict["billing_state"] = self.billingState
        
        userDict["po_number"] = self.poNumber
        userDict["order_note"] = self.orderNote
        
        return userDict
    }
    
    init(customerId: String? = "",
         cartId: String? = "",
         firstName: String? = "",
         lastName: String? = "",
         companyName: String? = "",
         address1: String? = "",
         address2: String? = "",
         city: String? = "",
         postCode: String? = "",
         phone: String? = "",
         email: String? = "",
         country: String? = "",
         state: String? = "",
         deliveryDate: String? = "",
         shipToSame: String? = "",
         poNumber: String? = "",
         orderNote: String? = "",
         billingFirstName: String? = "",
         billingLastName: String? = "",
         billingCompany: String? = "",
         billingAddress1: String? = "",
         billingAddress2: String? = "",
         billingCity: String? = "",
         billingPostcode: String? = "",
         billingCountry: String? = "",
         billingState: String? = "") {
        
        self.customerId = customerId
        self.cartId = cartId
        self.firstName = firstName
        self.lastName = lastName
        self.companyName = companyName
        self.address1 = address1
        self.address2 = address2
        self.city = city
        self.postCode = postCode
        self.phone = phone
        self.email = email
        self.country = country
        self.state = state
        self.email = email
        self.deliveryDate = deliveryDate
        self.shipToSame = shipToSame
        self.poNumber = poNumber
        self.orderNote = orderNote
        self.billingFirstName = billingFirstName
        self.billingLastName = billingLastName
        self.billingCompany = billingCompany
        self.billingAddress1 = billingAddress1
        self.billingAddress2 = billingAddress2
        self.billingCity = billingCity
        self.billingPostcode = billingPostcode
        self.billingCountry = billingCountry
        
}

}
