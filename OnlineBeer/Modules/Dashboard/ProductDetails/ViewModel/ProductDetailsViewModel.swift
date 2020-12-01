//
//  ProductDetailsViewModel.swift
//  Beer Connect
//
//  Created by Synsoft on 12/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation
import UIKit




// MARK: - SubcatResponse
struct ErrorBlock: Codable {
   enum value: String, CodingKey {
       case message = "message"
       case code = "code"
   }
   let message: String?
   let code: String?
   
   init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        code = try container.decodeIfPresent(String.self, forKey: .code)
     }
}

class ProductDetailViewModel {
    
    
   weak var delegate: ProductDetailProtocol?
   weak var cartDelegate: AddToCartProtocol?

   var productDetailRequest = ProductDetailRequest()
   var productDetailResponse = ProductDetailResponse()
   
   var addToCartRequest = AddToCartRequest()
   var addToCartResponse = AddToCartResponse()
   
   var arrSimilarProducts = [Product].init()
   
   var addCartSuccessMsg: String? = ""
   
   init(delegate: ProductDetailProtocol, cartDelegate: AddToCartProtocol) {
      self.delegate = delegate
      self.cartDelegate = cartDelegate
   }
}

// MARK:  GET PRODUCT DETAILS FROM SERVER
extension ProductDetailViewModel {
   
   func getSingleProductsDetailsFromServer() {
      
      NetworkManager.shared.makeRequestToServer(for: PRODUCTDETAILS,
                                                method: .POST,
                                                params: self.productDetailRequest.dictionary,
                                                isActivityShow: true,
                                                completionSuccess: { (productDetailData) in
                                                   
                                                   if productDetailData != nil {
                                                      
                                                      self.productDetailResponse = self.productDetailResponse.getProductDetailInfo(repsonseData: productDetailData ?? Data.init()) ?? ProductDetailResponse.init()
                                                      if let successMsg = self.productDetailResponse.message {
                                                         self.addCartSuccessMsg = successMsg
                                                      }
                                                      
                                                      if let isSimilarProduct = self.productDetailResponse.productData?.relatedIDSStatus {
                                                         if isSimilarProduct {
                                                            if let arrSimilar = self.productDetailResponse.productData?.relatedIDS {
                                                               self.arrSimilarProducts = arrSimilar
                                                               //print("Similar products \(self.arrSimilarProducts)")
                                                               
                                                            }
                                                         }
                                                      }
                                                      
                                                   self.delegate?.onRecievedProductDetailSuccess()
                                                   } else {
                                                      self.delegate?.onFailure(errorMsg:
                                                         "There might be error from server side")
                                                   }
      }) {(errorObj) in
         self.delegate?.onFailure(errorMsg:
            errorObj.localizedDescription)
         print("Failure Response is \(errorObj.localizedDescription)")
      }
   }
   
   func addProductsToCart() {
      NetworkManager.shared.makeRequestToServer(for: ADDTOCART,
                                                method: .POST,
                                                params: self.addToCartRequest.dictionary,
                                                isActivityShow: true,
                                                completionSuccess: { (addToCartData) in
                                                   
                                                   if addToCartData != nil {
                                                      self.addToCartResponse = self.addToCartResponse.getAddToCartResponseFrom(repsonseData: addToCartData ?? Data.init()) ?? AddToCartResponse.init()
                                                    if (self.addToCartResponse.cartID == nil) {
                                                        
                                                        do {
                                                            let responseModel = try? JSONDecoder().decode(ErrorBlock.self,
                                                                                                                 from: addToCartData!)
                                                                   if responseModel != nil {
                                                                    self.delegate?.onFailure(errorMsg: responseModel?.message ?? "There might be error from server side")
                                                                   }
                                                        }
                                                        
                                                     
                                                    } else {
                                                        self.saveCartDetails(cartDetails: self.addToCartResponse)
                                                        self.cartDelegate?.onAddCartProductSuccess()
                                                    }
                                                   } else {
                                                      self.delegate?.onFailure(errorMsg:
                                                         "There might be error from server side")
                                                   }
      }) {(errorObj) in
         self.delegate?.onFailure(errorMsg:
            errorObj.localizedDescription)
         print("Failure Response is \(errorObj.localizedDescription)")
      }
   }
}


// MARK: Manage Dashboard Response Details
extension ProductDetailViewModel {
   func saveCartDetails(productDetails: ProductDetailResponse) {
      UserDefaults.standard.save(customObject: productDetails, inKey: "productDetails")
   }
   func saveCartDetails(cartDetails: AddToCartResponse) {
      UserDefaults.standard.save(customObject: cartDetails, inKey: "cartDetails")
   }
}


