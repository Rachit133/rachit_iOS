//
//  OrderDetailResponse.swift
//  Beer Connect
//
//  Created by Synsoft on 17/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

struct OrderDetailsResponse: Codable {
    var ordersData : OrdersData?
    var message : String?
    var status : String?
    
    enum CodingKeys: String, CodingKey {
        
        case ordersData = "orders-data"
        case message = "message"
        case status = "status"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ordersData = try values.decodeIfPresent(OrdersData.self, forKey: .ordersData)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        status = try values.decodeIfPresent(String.self, forKey: .status)
    }
    
    init() {}
}

struct OrdersData : Codable {
    var poNumber : String?
    var pincode : String?
    var address2 : String?
    var state : String?
    var address1 : String?
    var orderItems : [OrderItems]?
    var city : String?
    var discount: Float?
    var refunds: [Refunds]?
    //var taxAmount : [String]?
    //var shippingMethod : ShippingMethod?
    var subtotal: Float?
    var country : String?
    var orderNote : String?
    var grandtotal: String?
    var orderdate : String?
    var currencySymbol : String?
    var deliveryDate : String?
    var shipping: String?
    var getAddress: GetAddress?
    var amountSaved: String?
    var orderId: String?
    var deliveredDate: String?
    var refundstotal: String?
    
    enum CodingKeys: String, CodingKey {
        
        case getAddress = "get_address"
        case poNumber = "po_number"
        case pincode = "pincode"
        case address2 = "address_2"
        case state = "state"
        case address1 = "address_1"
        case orderItems = "order-items"
        case city = "city"
        case discount = "discount"
        case amountSaved = "discount_amount_total"
        case refundstotal = "refundstotal"
        case refunds = "refunds"
        //case taxAmount = "tax_amount"
        //case shippingMethod = "shipping_method"
        case subtotal = "subtotal"
        case country = "country"
        case orderNote = "order_note"
        case grandtotal = "grandtotal"
        case orderdate = "orderdate"
        case deliveryDate = "delivery_date"
        case currencySymbol = "currency_symbol"
        case shipping = "shipping"
        case orderId = "order_id"
        case deliveredDate = "ordercompleteddate"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        // tax_amount = try values.decodeIfPresent([String].self, forKey: .tax_amount)
        amountSaved = try values.decodeIfPresent(String.self, forKey: .amountSaved)
        refundstotal = try values.decodeIfPresent(String.self, forKey: .refundstotal)
        subtotal = try values.decodeIfPresent(Float.self, forKey: .subtotal)
        address1 = try values.decodeIfPresent(String.self, forKey: .address1)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        pincode = try values.decodeIfPresent(String.self, forKey: .pincode)
        discount = try values.decodeIfPresent(Float.self, forKey: .discount)
        grandtotal = try values.decodeIfPresent(String.self, forKey: .grandtotal)
        orderItems = try values.decodeIfPresent([OrderItems].self, forKey: .orderItems)
        deliveryDate = try values.decodeIfPresent(String.self, forKey: .deliveryDate)
        address2 = try values.decodeIfPresent(String.self, forKey: .address2)
        orderdate = try values.decodeIfPresent(String.self, forKey: .orderdate)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        currencySymbol = try values.decodeIfPresent(String.self, forKey: .currencySymbol)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        getAddress = try values.decodeIfPresent(GetAddress.self, forKey: .getAddress)
        refunds = try values.decodeIfPresent([Refunds].self, forKey: .refunds)

        //shippingMethod = try values.decodeIfPresent(Shipping_method.self, forKey: .shippingMethod)
        poNumber = try values.decodeIfPresent(String.self, forKey: .poNumber)
        shipping = try values.decodeIfPresent(String.self, forKey: .shipping)
        orderNote = try values.decodeIfPresent(String.self, forKey: .orderNote)
        orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
        deliveredDate = try values.decodeIfPresent(String.self, forKey: .deliveredDate)
    }
    
    init() {}
}

struct GetAddress : Codable {
    var postcode : String?
    var address2 : String?
    var address1 : String?
    var country : String?
    var state : String?
    var firstName : String?
    var phone : String?
    var lastName : String?
    var company : String?
    var city : String?
    var email : String?
    
    enum CodingKeys: String, CodingKey {
        
        case postcode = "postcode"
        case address2 = "address_2"
        case address1 = "address_1"
        case country = "country"
        case state = "state"
        case firstName = "first_name"
        case phone = "phone"
        case lastName = "last_name"
        case company = "company"
        case city = "city"
        case email = "email"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        postcode = try values.decodeIfPresent(String.self, forKey: .postcode)
        address2 = try values.decodeIfPresent(String.self, forKey: .address2)
        address1 = try values.decodeIfPresent(String.self, forKey: .address1)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        firstName = try values.decodeIfPresent(String.self, forKey: .firstName)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        lastName = try values.decodeIfPresent(String.self, forKey: .lastName)
        company = try values.decodeIfPresent(String.self, forKey: .company)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        email = try values.decodeIfPresent(String.self, forKey: .email)
    }
    
}

struct OrderDate : Codable {
    var date : String?
    var timezoneType : Int?
    var timezone : String?
    
    enum CodingKeys: String, CodingKey {
        
        case date = "date"
        case timezoneType = "timezone_type"
        case timezone = "timezone"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        timezoneType = try values.decodeIfPresent(Int.self, forKey: .timezoneType)
        timezone = try values.decodeIfPresent(String.self, forKey: .timezone)
    }
    
    init() {}
    
}


struct OrderItems: Codable {
    var productId : Int?
    var orderItemId : Int?
    var itemName : String?
    var itemImage : String?
    var itemQty: String?
    var itemCurrency: String?
    var itemSubtotal : Float?
    var itemTotal : Float?
    var youSaved: String?
    var itemRefundedQty : Int?
    var itemRefundedTotal : Float?
    
    enum CodingKeys: String, CodingKey {
        
        case productId = "product-id"
        case orderItemId = "order-itemid"
        case itemName = "item-name"
        case itemImage = "item-image"
        case itemTotal = "item-total"
        case itemQty = "item-qty"
        case itemRefundedQty = "item-refunded-qty"
        case itemRefundedTotal = "item-refunded-total"
        case itemCurrency = "item-currency"
        case itemSubtotal = "item-subtotal"
        case youSaved = "discount_amount_total"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        productId = try values.decodeIfPresent(Int.self, forKey: .productId)
        orderItemId = try values.decodeIfPresent(Int.self, forKey: .orderItemId)
        itemName = try values.decodeIfPresent(String.self, forKey: .itemName)
        itemImage = try values.decodeIfPresent(String.self, forKey: .itemImage)
        itemTotal = try values.decodeIfPresent(Float.self, forKey: .itemTotal)
        itemQty = try values.decodeIfPresent(String.self, forKey: .itemQty)
        itemCurrency = try values.decodeIfPresent(String.self, forKey: .itemCurrency)
        itemSubtotal = try values.decodeIfPresent(Float.self, forKey: .itemSubtotal)
        youSaved = try values.decodeIfPresent(String.self, forKey: .youSaved)
        itemRefundedQty = try values.decodeIfPresent(Int.self, forKey: .itemRefundedQty)
        itemRefundedTotal = try values.decodeIfPresent(Float.self, forKey: .itemRefundedTotal)
    }
    
    init() {}
}

struct ShippingMethod : Codable {
    
    var productId : Int?
    
    enum CodingKeys: String, CodingKey {
        case productId = "product-id"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        productId = try values.decodeIfPresent(Int.self, forKey: .productId)
    }
    
    init() {}
}

struct Refunds: Codable {
    var refundAmount : String?
    var refundReason : String?
    var refundDetails : String?
    
    enum CodingKeys: String, CodingKey {
        case refundAmount = "refund_amount"
        case refundReason = "refund_reason"
        case refundDetails = "refund_details"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        refundAmount = try values.decodeIfPresent(String.self, forKey: .refundAmount)
        refundReason = try values.decodeIfPresent(String.self, forKey: .refundReason)
        refundDetails = try values.decodeIfPresent(String.self, forKey: .refundDetails)
    }
    
    init() {}
}



extension OrderDetailsResponse {
    func getOrderDetailsFrom(repsonseData: Data) -> OrderDetailsResponse? {
        do {
            let responseModel = try? JSONDecoder().decode(OrderDetailsResponse?.self,
                                                          from: repsonseData)
            if responseModel != nil {
                print("Response Modal is \(String(describing: responseModel))")
                return responseModel
            }
        }
        return OrderDetailsResponse.init()
    }
}

struct OrderEmailDownloadResponse : Codable {
    var status : String?
    var url : String?
    var filename : String?
    var pdf_path : String?
    
    enum CodingKeys: String, CodingKey {
        
        case status = "status"
        case url = "url"
        case filename = "filename"
        case pdf_path = "pdf_path"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        filename = try values.decodeIfPresent(String.self, forKey: .filename)
        pdf_path = try values.decodeIfPresent(String.self, forKey: .pdf_path)
    }
    
    init() {}
}

extension OrderEmailDownloadResponse {
    
    func getOrderEmailDownloadFrom(repsonseData: Data) -> OrderEmailDownloadResponse? {
        do {
            let responseModel = try? JSONDecoder().decode(OrderEmailDownloadResponse?.self,
                                                          from: repsonseData)
            if responseModel != nil {
                print("Response Modal is \(String(describing: responseModel))")
                return responseModel
            }
        }
        return OrderEmailDownloadResponse.init()
    }
}
