//
//  ProductDetailResponse.swift
//  Beer Connect
//
//  Created by Synsoft on 18/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

// MARK: - ProductDetailResponse
struct ProductDetailResponse: Codable {
   var status: String?
   var message: String?
   var productData: ProductData?
   
   enum CodingKeys: String, CodingKey {
      case status = "status"
      case message = "message"
      case productData = "product_data"
   }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      status = try container.decodeIfPresent(String.self, forKey: .status)
      message = try container.decodeIfPresent(String.self, forKey: .message)
      productData = try container.decodeIfPresent(ProductData.self, forKey: .productData)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(status, forKey: .status)
      try container.encode(message, forKey: .message)
      try container.encode(productData, forKey: .productData)
   }
   
   init() { }
}

// MARK: - ProductData
struct ProductData: Codable {
      var virtual: Bool?
      var catalogVisibility: String?
      var dateOnSaleTo: String?
      var productPriceMinReg, postPassword: String?
      var upsellIDS: [Any?]?
      var currencySymbol: String?
      var relatedIDSStatus: Bool?
      var slug, productType, wishlist, enableReview: String?
      var parentID: Int?
      var stockStatus: String?
      var dateModified: DateCreatedClass?
      var productPriceMax: String?
      var reviewCount: Int?
      var crossSellIDS: [Any?]?
      var length, purchaseNote: String?
      var id: Int?
      var height: String?
      var featured: Bool?
      var productQuantity: Int?
      var reviewsAllowed: Bool?
      var width: String?
      var handler: String?
      var status: String?
      var downloads: [Any?]?
      var videoUrl: String?
      var tableData: [TableData]?
      var parentChildCat : [ParentChildCat]?
      //var additional: Additional?
      var relatedIDS: [Product]?
      var totalSales, downloadExpiry: Int?
      var price: String?
      //var variationAttr: VariationAttr?
      //var variationData: [VariationDatum]?
      var regularPrice: String?
      //var attributes: ProductDataAttributes?
      var tagIDS: [Int]?
      var downloadLimit: Int?
      var lowStockAmount, displayPrice: String?
      var downloadable: Bool?
      var menuOrder: Int?
      var productPriceMaxReg, shortDescription: String?
      var stockQuantity: Int?
      var soldIndividually: Bool?
      var productPriceMin, displayRegularPrice: String?
      //var defaultAttributes: [Any?]?
      var manageStock: Bool?
      var backorders, sku, taxClass, weight: String?
      var imageID, taxStatus, productDataDescription: String?
      var shippingClassID: Int?
      //var ratingCounts: [Any?]?
      var name: String?
      var metaData: [MetaDatum]?
      var dateOnSaleFrom: String?
      var productImage: String?
      var categoryIDS: [Int]?
      var salePrice: String?
      var sale, enableQrcode: Bool?
      var galleryImageIDS: [Any?]?
      var averageRating: String?
      var dateCreated: DateCreatedClass?
      var productGalleryStatus: Bool?
      var managingStock: Bool?
      var productGallery: [Any?]?
 
   
   enum CodingKeys: String, CodingKey {
      case id  = "id"
      case name = "name"
      case slug = "slug"
      //case additional = "additional"
      case dateCreated = "date_created"
      case dateModified = "date_modified"
      case parentChildCat   = "parent_child_cat"
      case status = "status"
      case featured = "featured"
      case catalogVisibility = "catalog_visibility"
      case productDataDescription = "description"
      case shortDescription = "short_description"
      case sku = "sku"
      case price = "price"
      case videoUrl = "video_url"
      case regularPrice = "regular_price"
      case salePrice = "sale_price"
     // case dateOnSaleFrom = "date_on_sale_from"
//      case dateOnSaleTo = "date_on_sale_to"
      case totalSales = "total_sales"
      case taxStatus = "tax_status"
      case taxClass = "tax_class"
//      case manageStock = "manage_stock"
      case stockQuantity = "stock_quantity"
      case stockStatus = "stock_status"
      case tableData = "table_data"
//      case backorders = "backorders"
//      case lowStockAmount = "low_stock_amount"
//      case soldIndividually = "sold_individually"
//      case weight = "weight"
//      case length = "length"
//      case width = "width"
//      case height = "height"
//      case upsellIDS = "upsell_ids"
//      case crossSellIDS = "cross_sell_ids"
//      case parentID = "parent_id"
//      case reviewsAllowed = "reviews_allowed"
//      case purchaseNote = "purchase_note"
//      case attributes = "attributes"
//      case defaultAttributes = "default_attributes"
//      case menuOrder = "menu_order"
//      case postPassword = "post_password"
//      case virtual = "virtual"
//      case downloadable = "downloadable"
//      case categoryIDS = "category_ids"
//      case tagIDS = "tag_ids"
//      case shippingClassID = "shipping_class_id"
//      case downloads = "downloads"
//      case imageID = "image_id"
//      case galleryImageIDS = "gallery_image_ids"
//      case downloadLimit = "download_limit"
//      case downloadExpiry = "download_expiry"
//      case ratingCounts = "rating_counts"
//      case averageRating = "average_rating"
//      case reviewCount = "review_count"
//      case metaData = "meta_data"
      case displayPrice = "display_price"
      case productQuantity = "product_quantity"
      case displayRegularPrice = "display_regular_price"
      case currencySymbol = "currency_symbol"
      case productGallery = "product-gallery"
//     case productGalleryStatus = "product-gallery-status"
      case productType = "product-type"
      case handler = "handler"
      case enableReview = "enable-review"
      case enableQrcode = "enable-qrcode"
      case productImage = "product_image"
      case wishlist = "wishlist"
      case relatedIDS = "related_ids"
      case relatedIDSStatus = "related_ids_status"
      case managingStock = "managing_stock"
   }
   
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      id = try container.decodeIfPresent(Int.self, forKey: .id)
      name = try container.decodeIfPresent(String.self, forKey: .name)
      status = try container.decodeIfPresent(String.self, forKey: .status)
      slug = try container.decodeIfPresent(String.self, forKey: .slug)
      dateCreated = try container.decodeIfPresent(DateCreatedClass.self, forKey: .dateCreated)
      dateModified = try container.decodeIfPresent(DateCreatedClass.self, forKey: .dateModified)
      featured = try container.decodeIfPresent(Bool.self, forKey: .featured)
      catalogVisibility = try container.decodeIfPresent(String.self, forKey: .catalogVisibility)
      productDataDescription = try container.decodeIfPresent(String.self, forKey: .productDataDescription)
      parentChildCat = try container.decodeIfPresent([ParentChildCat].self,
                                                 forKey: .parentChildCat)
      shortDescription = try container.decodeIfPresent(String.self, forKey: .shortDescription)
      sku = try container.decodeIfPresent(String.self, forKey: .sku)
      price = try container.decodeIfPresent(String.self, forKey: .price)
      regularPrice = try container.decodeIfPresent(String.self, forKey: .regularPrice)
      salePrice = try container.decodeIfPresent(String.self, forKey: .salePrice)
     // dateOnSaleFrom = try container.decodeIfPresent(String.self, forKey: .dateOnSaleFrom)
   //   dateOnSaleTo = try container.decodeIfPresent(String.self, forKey: .dateOnSaleTo)
      totalSales = try container.decodeIfPresent(Int.self, forKey: .totalSales)
      taxStatus = try container.decodeIfPresent(String.self, forKey: .taxStatus)
      taxClass = try container.decodeIfPresent(String.self, forKey: .taxClass)
      videoUrl = try container.decodeIfPresent(String.self, forKey: .videoUrl)
//      manageStock = try container.decodeIfPresent(Bool.self, forKey: .manageStock)
      stockQuantity = try container.decodeIfPresent(Int.self, forKey: .stockQuantity)
      stockStatus = try container.decodeIfPresent(String.self, forKey: .stockStatus)
      tableData = try container.decodeIfPresent([TableData].self, forKey: .tableData)

//      backorders = try container.decodeIfPresent(String.self, forKey: .backorders)
//      lowStockAmount = try container.decodeIfPresent(String.self, forKey: .lowStockAmount)
//      soldIndividually = try container.decodeIfPresent(Bool.self, forKey: .soldIndividually)
//      weight = try container.decodeIfPresent(String.self, forKey: .weight)
//      length = try container.decodeIfPresent(String.self, forKey: .length)
//      width = try container.decodeIfPresent(String.self, forKey: .width)
//      height = try container.decodeIfPresent(String.self, forKey: .height)
//      upsellIDS = try container.decodeIfPresent([String].self, forKey: .upsellIDS)
//      crossSellIDS = try container.decodeIfPresent([String].self, forKey: .crossSellIDS)
//      parentID = try container.decodeIfPresent(Int.self, forKey: .parentID)
//      reviewsAllowed = try container.decodeIfPresent(Bool.self, forKey: .reviewsAllowed)
//      purchaseNote = try container.decodeIfPresent(String.self, forKey: .purchaseNote)
      //attributes = try container.decodeIfPresent([String].self, forKey: .attributes)
      //defaultAttributes = try container.decodeIfPresent([String].self, forKey: .defaultAttributes)
//      menuOrder = try container.decodeIfPresent(Int.self, forKey: .menuOrder)
//      postPassword = try container.decodeIfPresent(String.self, forKey: .postPassword)
//      virtual = try container.decodeIfPresent(Bool.self, forKey: .virtual)
//      downloadable = try container.decodeIfPresent(Bool.self, forKey: .downloadable)
//      categoryIDS = try container.decodeIfPresent([Int].self, forKey: .categoryIDS)
//      tagIDS = try container.decodeIfPresent([Int].self, forKey: .tagIDS)
//      shippingClassID = try container.decodeIfPresent(Int.self, forKey: .shippingClassID)
//      downloads = try container.decodeIfPresent([String].self, forKey: .downloads)
//      imageID = try container.decodeIfPresent(String.self, forKey: .imageID)
//      galleryImageIDS = try container.decodeIfPresent([String].self, forKey: .galleryImageIDS)
//      downloadLimit = try container.decodeIfPresent(Int.self, forKey: .downloadLimit)
//      downloadExpiry = try container.decodeIfPresent(Int.self, forKey: .downloadExpiry)
     // ratingCounts = try container.decodeIfPresent([String].self, forKey: .ratingCounts)
  //    averageRating = try container.decodeIfPresent(String.self, forKey: .averageRating)
//      reviewCount = try container.decodeIfPresent(Int.self, forKey: .reviewCount)
//      metaData = try container.decodeIfPresent([MetaDatum].self, forKey: .metaData)
      displayPrice = try container.decodeIfPresent(String.self, forKey: .displayPrice)
      productQuantity = try container.decodeIfPresent(Int.self, forKey: .productQuantity)
      displayRegularPrice = try container.decodeIfPresent(String.self, forKey: .displayRegularPrice)
      currencySymbol = try container.decodeIfPresent(String.self, forKey: .currencySymbol)
      productGallery = try container.decodeIfPresent([String].self, forKey: .productGallery)
//      //productGalleryStatus = try container.decodeIfPresent(Bool.self, forKey: .productGalleryStatus)
      productType = try container.decodeIfPresent(String.self, forKey: .productType)
      handler = try container.decodeIfPresent(String.self, forKey: .handler)
      enableReview = try container.decodeIfPresent(String.self, forKey: .enableReview)
      enableQrcode = try container.decodeIfPresent(Bool.self, forKey: .enableQrcode)
      productImage = try container.decodeIfPresent(String.self, forKey: .productImage)
      wishlist = try container.decodeIfPresent(String.self, forKey: .wishlist)
      relatedIDS = try container.decodeIfPresent([Product].self, forKey: .relatedIDS)
      relatedIDSStatus = try container.decodeIfPresent(Bool.self, forKey: .relatedIDSStatus)
      managingStock = try container.decodeIfPresent(Bool.self, forKey: .managingStock)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(id, forKey: .id)
      try container.encode(name, forKey: .name)
      try container.encode(slug, forKey: .slug)
      try container.encode(dateCreated, forKey: .dateCreated)
      try container.encode(dateModified, forKey: .dateModified)
      try container.encode(status, forKey: .status)
      try container.encode(featured, forKey: .featured)
      try container.encode(catalogVisibility, forKey: .catalogVisibility)
      try container.encode(productDataDescription, forKey: .productDataDescription)
      try container.encode(shortDescription, forKey: .shortDescription)
      try container.encode(sku, forKey: .sku)
      try container.encode(price, forKey: .price)
      try container.encode(regularPrice, forKey: .regularPrice)
      try container.encode(salePrice, forKey: .salePrice)
   //   try container.encode(dateOnSaleFrom, forKey: .dateOnSaleFrom)
      //try container.encode(dateOnSaleTo, forKey: .dateOnSaleTo)
      try container.encode(totalSales, forKey: .totalSales)
      try container.encode(taxStatus, forKey: .taxStatus)
      try container.encode(taxClass, forKey: .taxClass)
      try container.encode(videoUrl, forKey: .videoUrl)
//      try container.encode(manageStock, forKey: .manageStock)
      try container.encode(stockQuantity, forKey: .stockQuantity)
      try container.encode(stockStatus, forKey: .stockStatus)
      try container.encode(tableData, forKey: .tableData)
//      try container.encode(backorders, forKey: .backorders)
//
//      try container.encode(lowStockAmount, forKey: .lowStockAmount)
//      try container.encode(soldIndividually, forKey: .soldIndividually)
//      try container.encode(weight, forKey: .weight)
//      try container.encode(length, forKey: .length)
//      try container.encode(width, forKey: .width)
//      try container.encode(height, forKey: .height)
//      try container.encode(upsellIDS, forKey: .upsellIDS)
//      try container.encode(crossSellIDS, forKey: .crossSellIDS)
//      try container.encode(parentID, forKey: .parentID)
//      try container.encode(reviewsAllowed, forKey: .reviewsAllowed)
//      try container.encode(purchaseNote, forKey: .purchaseNote)
//      try container.encode(attributes, forKey: .attributes)
//      try container.encode(defaultAttributes, forKey: .defaultAttributes)
//      try container.encode(menuOrder, forKey: .menuOrder)
//      try container.encode(postPassword, forKey: .postPassword)
//      try container.encode(virtual, forKey: .virtual)
//      try container.encode(downloadable, forKey: .downloadable)
//      try container.encode(categoryIDS, forKey: .categoryIDS)
//
//      try container.encode(tagIDS, forKey: .tagIDS)
//      try container.encode(shippingClassID, forKey: .shippingClassID)
//      try container.encode(downloads, forKey: .downloads)
//      try container.encode(imageID, forKey: .imageID)
//      try container.encode(galleryImageIDS, forKey: .galleryImageIDS)
//      try container.encode(downloadLimit, forKey: .downloadLimit)
//      try container.encode(downloadExpiry, forKey: .downloadExpiry)
//
//      try container.encode(ratingCounts, forKey: .ratingCounts)
//      try container.encode(averageRating, forKey: .averageRating)
//      try container.encode(reviewCount, forKey: .reviewCount)
//      try container.encode(metaData, forKey: .metaData)
//
       try container.encode(displayPrice, forKey: .displayPrice)
      try container.encode(productQuantity, forKey: .productQuantity)
      try container.encode(displayRegularPrice, forKey: .displayRegularPrice)
      try container.encode(currencySymbol, forKey: .currencySymbol)
      // try container.encode(productGallery, forKey: .productGallery)
//       try container.encode(productGalleryStatus, forKey: .productGalleryStatus)
      try container.encode(productType, forKey: .productType)
      try container.encode(handler, forKey: .handler)
      try container.encode(enableReview, forKey: .enableReview)
      try container.encode(enableQrcode, forKey: .enableQrcode)
      try container.encode(productImage, forKey: .productImage)
      try container.encode(wishlist, forKey: .wishlist)
      try container.encode(relatedIDS, forKey: .relatedIDS)
      try container.encode(relatedIDSStatus, forKey: .relatedIDSStatus)
   }
   
   init() { }
}

// MARK: - DateCreatedClass
struct DateCreatedClass: Codable {
    var date: String?
    var timezoneType: Int?
    var timezone: String?

    enum CodingKeys: String, CodingKey {
        case date = "date"
        case timezoneType = "timezone_type"
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
     
     init() { }
}

// MARK: - Table Details
struct TableData: Codable {
   var title: String?
   var condition: String?
   var discount: String?
   
   enum CodingKeys: String, CodingKey {
        case title = "title"
        case condition = "condition"
        case discount = "discount"
    }
   
     init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        condition = try container.decodeIfPresent(String.self, forKey: .condition)
        discount = try container.decodeIfPresent(String.self, forKey: .discount)
     }
     
     // Encoding
     func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(condition, forKey: .condition)
        try container.encode(discount, forKey: .discount)
     }
     
     init() { }
}



// MARK: - MetaDatum
struct MetaDatum: Codable {
   var id: Int?
   var key: String?
   var value: String?
   
   enum CodingKeys: String, CodingKey {
        case id = "id"
        case key = "key"
        case value = "value"
    }
   
     init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        key = try container.decodeIfPresent(String.self, forKey: .key)
        value = try container.decodeIfPresent(String.self, forKey: .value)
     }
     
     // Encoding
     func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(key, forKey: .key)
        try container.encode(value, forKey: .value)
     }
     
     init() { }
}


struct ParentChildCat : Codable {
    var key : String?
    var value : String?
    var keyId : Int?
    var valueId : Int?
    
    enum CodingKeys: String, CodingKey {
        case key = "key"
        case value = "value"
        case keyId = "key_id"
        case valueId = "value_id"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        key = try values.decodeIfPresent(String.self, forKey: .key)
        value = try values.decodeIfPresent(String.self, forKey: .value)
        keyId = try values.decodeIfPresent(Int.self, forKey: .keyId)
        valueId = try values.decodeIfPresent(Int.self, forKey: .valueId)
    }

    init() {}
}


// MARK: - RelatedID
struct RelatedID: Codable {
   var productID: Int?
   var productType, productName, currencySymbol: String?
   var productImage: String?
   var productGalleryStatus: /*productGallery:*/ Bool?
   var regularPrice, productPrice, averageRating, wishlist: String?

    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        case productType = "product-type"
        case productName = "product_name"
        case currencySymbol = "currency_symbol"
        case productImage = "product_image"
        case productGalleryStatus = "product-gallery-status"
        //case productGallery = "product-gallery"
        case regularPrice = "regular_price"
        case productPrice = "product_price"
        case averageRating = "average_rating"
        case wishlist = "wishlist"
    }
   
   init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      productID = try container.decodeIfPresent(Int.self, forKey: .productID)
      productType = try container.decodeIfPresent(String.self, forKey: .productType)
      productName = try container.decodeIfPresent(String.self, forKey: .productName)
      currencySymbol = try container.decodeIfPresent(String.self, forKey: .currencySymbol)
      productImage = try container.decodeIfPresent(String.self, forKey: .productImage)
      //productGalleryStatus = try container.decodeIfPresent(Bool.self, forKey: .productGalleryStatus)
     // productGallery = try container.decodeIfPresent(Bool.self, forKey: .productGallery)
      regularPrice = try container.decodeIfPresent(String.self, forKey: .regularPrice)
      productPrice = try container.decodeIfPresent(String.self, forKey: .productPrice)
      averageRating = try container.decodeIfPresent(String.self, forKey: .averageRating)
      wishlist = try container.decodeIfPresent(String.self, forKey: .wishlist)
   }
   
   // Encoding
   func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(productID, forKey: .productID)
      try container.encode(productType, forKey: .productType)
      try container.encode(productName, forKey: .productName)
      try container.encode(currencySymbol, forKey: .currencySymbol)
      try container.encode(productImage, forKey: .productImage)
     // try container.encode(productGalleryStatus, forKey: .productGalleryStatus)
     // try container.encode(productGallery, forKey: .productGallery)
      try container.encode(regularPrice, forKey: .regularPrice)
      try container.encode(productPrice, forKey: .productPrice)
      try container.encode(averageRating, forKey: .averageRating)
      try container.encode(wishlist, forKey: .wishlist)
   }
   
   init() { }
}


extension ProductDetailResponse {
   enum MyError: Error {
       case FoundNil(String)
   }
   
   func getProductDetailInfo(repsonseData: Data) -> ProductDetailResponse? {
     
      do {
            let responseModel = try? JSONDecoder().decode(ProductDetailResponse.self,
                                                      from: repsonseData)
         
         if responseModel != nil {
               print("Response Modal is \(String(describing: responseModel))")
               return responseModel
            }
      }
      return ProductDetailResponse.init()
   }
}
