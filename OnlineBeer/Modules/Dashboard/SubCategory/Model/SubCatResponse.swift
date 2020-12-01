//
//  DahsboardResponse.swift
//  Beer Connect
//
//  Created by Synsoft on 11/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation
import UIKit

struct SubCatResponse: Codable {
   
   var catName: String?
   var categoryImage: String?
   var subcategories: [Subcategory]?
   var products = [Product].init()
   var status: Bool?
   var message: String?
   var filters: Filters?
   var orderBy: OrderBy?
   var currencySymbol: String?
   var productCount: String?
   
   enum CodingKeys: String, CodingKey {
      case catName = "cat_name"
      case categoryImage = "category_image"
      case subcategories = "subcategories"
      case products = "products"
      case status = "status"
      case message = "message"
      case filters = "filters"
      case orderBy = "order-by"
      case currencySymbol = "currency_symbol"
      case productCount = "product_count"

   }
   
   init(from decoder: Decoder) throws {
      
      let container = try decoder.container(keyedBy: CodingKeys.self)
      catName = try container.decodeIfPresent(String.self, forKey: .catName)
      categoryImage = try container.decodeIfPresent(String.self, forKey: .categoryImage)
      subcategories = try container.decodeIfPresent([Subcategory].self, forKey: .subcategories)
      products = try (container.decodeIfPresent([Product].self, forKey: .products) ?? [Product].init())
      status = try container.decodeIfPresent(Bool.self, forKey: .status)
      message = try container.decodeIfPresent(String.self, forKey: .message)
      filters = try container.decodeIfPresent(Filters.self, forKey: .filters)
      orderBy = try container.decodeIfPresent(OrderBy.self, forKey: .orderBy)
      currencySymbol = try container.decodeIfPresent(String.self, forKey: .currencySymbol)
      productCount = try container.decodeIfPresent(String.self, forKey: .productCount)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(catName, forKey: .catName)
      try container.encode(categoryImage, forKey: .categoryImage)
      try container.encode(subcategories, forKey: .subcategories)
      try container.encode(products, forKey: .products)
      try container.encode(status, forKey: .status)
      try container.encode(message, forKey: .message)
      try container.encode(filters, forKey: .filters)
      try container.encode(orderBy, forKey: .orderBy)
      try container.encode(currencySymbol, forKey: .currencySymbol)
   }
   
   init() { }
}

struct Subcategory: Codable {
    var termID: Int?
    var name: String?
    var slug: String?
    var termGroup: Int?
    var termTaxonomyID: Int?
    var taxonomy: String?
    var subcategoryDescription: String?
    var parent: Int?
    var count: Int?
    var filter: String?
    var subImage: String?
    var hasChild: Bool?
   
   enum CodingKeys: String, CodingKey {
      case termID = "term_id"
      case name = "name"
      case slug = "slug"
      case termGroup = "term_group"
      case termTaxonomyID = "term_taxonomy_id"
      case taxonomy = "taxonomy"
      case subcategoryDescription = "description"
      case parent = "parent"
      case count = "count"
      case filter = "filter"
      case subImage = "sub_image"
      case hasChild = "has_child"
   }
   
   
   init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        termID = try container.decodeIfPresent(Int.self, forKey: .termID)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        slug = try container.decodeIfPresent(String.self, forKey: .slug)
        termGroup = try container.decodeIfPresent(Int.self, forKey: .termGroup)
        termTaxonomyID = try container.decodeIfPresent(Int.self, forKey: .termTaxonomyID)
        taxonomy = try container.decodeIfPresent(String.self, forKey: .taxonomy)
        subcategoryDescription = try container.decodeIfPresent(String.self, forKey: .subcategoryDescription)
        parent = try container.decodeIfPresent(Int.self, forKey: .parent)
        count = try container.decodeIfPresent(Int.self, forKey: .count)
        filter = try container.decodeIfPresent(String.self, forKey: .filter)
        subImage = try container.decodeIfPresent(String.self, forKey: .subImage)
        hasChild = try container.decodeIfPresent(Bool.self, forKey: .hasChild)
   }
     
     // Encoding
     func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(termID, forKey: .termID)
        try container.encode(name, forKey: .name)
        try container.encode(slug, forKey: .slug)
        try container.encode(termGroup, forKey: .termGroup)
        try container.encode(termTaxonomyID, forKey: .termTaxonomyID)
        try container.encode(taxonomy, forKey: .taxonomy)
        try container.encode(subcategoryDescription, forKey: .subcategoryDescription)
        try container.encode(parent, forKey: .parent)
        try container.encode(count, forKey: .count)
        try container.encode(filter, forKey: .filter)
        try container.encode(subImage, forKey: .subImage)
        try container.encode(hasChild, forKey: .hasChild)
     }
    
    init() {}
     
}

// MARK: - Filters
struct Filters: Codable {
   
   var pricefilter: Pricefilter?

   enum CodingKeys: String, CodingKey {
      case pricefilter = "pricefilter"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      pricefilter = try container.decodeIfPresent(Pricefilter.self, forKey: .pricefilter)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(pricefilter, forKey: .pricefilter)
   }
   
   init() { }
}

// MARK: - Pricefilter
struct Pricefilter: Codable {
    var minprice, maxprice: String?
  
   enum CodingKeys: String, CodingKey {
        case minprice = "minprice"
       case maxprice = "maxprice"
     }
     
     init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        minprice = try container.decodeIfPresent(String.self, forKey: .minprice)
        maxprice = try container.decodeIfPresent(String.self, forKey: .maxprice)
     }
     
     // Encoding
     func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(minprice, forKey: .minprice)
        try container.encode(maxprice, forKey: .maxprice)
     }
     
     init() { }
   
}


// MARK: - OrderBy
struct OrderBy: Codable {
   var date, pricehigh, pricelow: String?
   
   enum CodingKeys: String, CodingKey {
      case date = "date"
      case pricehigh = "pricehigh"
      case pricelow = "pricelow"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      date = try container.decodeIfPresent(String.self, forKey: .date)
      pricehigh = try container.decodeIfPresent(String.self, forKey: .pricehigh)
      pricelow = try container.decodeIfPresent(String.self, forKey: .pricelow)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(date, forKey: .date)
      try container.encode(pricehigh, forKey: .pricehigh)
      try container.encode(pricelow, forKey: .pricelow)
   }
   
   init() { }
}


// MARK: - Product
struct Product: Codable {
   var productID: Int?
   var productQuantity: Int?
   var productName: String?
   var currencySymbol: String?
   var productImage: String?
   var productType: String?
   var productGalleryStatus: Bool?
   var productGallery: [String]? = [""]
   var regularPrice: String?
   var productPrice: String?
   var averageRating: String?
   var salePrice: String?
   var wishlist: String?
   var managingStock: Bool?

   
   enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case productQuantity = "product_quantity"
        case productName = "product_name"
        case currencySymbol = "currency_symbol"
        case productImage = "product_image"
        case productType = "product_type"
        case salePrice = "sale_price"
        case productGalleryStatus = "product-gallery-status"
        case productGallery = "product-gallery"
        case productPrice = "product_price"
        case regularPrice = "regular_price"
        case averageRating = "average_rating"
        case wishlist = "wishlist"
        case managingStock = "managing_stock"
     }
     
     init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        productID = try container.decodeIfPresent(Int.self, forKey: .productID)
        productQuantity = try container.decodeIfPresent(Int.self, forKey: .productQuantity)
        productName = try container.decodeIfPresent(String.self, forKey: .productName)
        currencySymbol = try container.decodeIfPresent(String.self, forKey: .currencySymbol)
        productImage = try container.decodeIfPresent(String.self, forKey: .productImage)
        productType = try container.decodeIfPresent(String.self, forKey: .productType)
        salePrice = try container.decodeIfPresent(String.self, forKey: .salePrice)
        productGalleryStatus = try container.decodeIfPresent(Bool.self, forKey: .productGalleryStatus)
        productGallery = try container.decodeIfPresent([String].self, forKey: .productGallery)
        productPrice = try container.decodeIfPresent(String.self, forKey: .productPrice)
        regularPrice = try container.decodeIfPresent(String.self, forKey: .regularPrice)
        averageRating = try container.decodeIfPresent(String.self, forKey: .averageRating)
        wishlist = try container.decodeIfPresent(String.self, forKey: .wishlist)
        managingStock = try container.decodeIfPresent(Bool.self, forKey: .managingStock)
   }
     
     // Encoding
     func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(productID, forKey: .productID)
        try container.encode(productQuantity, forKey: .productQuantity)
        try container.encode(productName, forKey: .productName)
        try container.encode(currencySymbol, forKey: .currencySymbol)
        try container.encode(productImage, forKey: .productImage)
        try container.encode(productType, forKey: .productType)
        try container.encode(salePrice, forKey: .salePrice)
        try container.encode(productGalleryStatus, forKey: .productGalleryStatus)
        try container.encode(productGallery, forKey: .productGallery)
        try container.encode(productPrice, forKey: .productPrice)
        try container.encode(regularPrice, forKey: .regularPrice)
        try container.encode(averageRating, forKey: .averageRating)
        try container.encode(wishlist, forKey: .wishlist)
     }
     
     init() { }
}



