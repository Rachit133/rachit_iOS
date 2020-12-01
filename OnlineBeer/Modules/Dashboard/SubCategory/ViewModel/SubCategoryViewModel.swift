//
//  SubCategoryViewModel.swift
//  Beer Connect
//
//  Created by Synsoft on 12/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation
import UIKit

class SubCatViewModel {
    
    weak var delegate: SubCatProtocol?
    var subCatRequest = SubCatRequest()
    var subCatResponse = SubCatResponse()
    
    var searchRequest = SearchRequest()
    var searchRespnse: SearchResponse?
    var arrCatProduct: [Subcategory]?
    var arrProducts: [Product]?
    
    var isFilterApply: Bool = false
    init(delegate: SubCatProtocol) { self.delegate = delegate }
}

// MARK:  GET PRODUCT LIST FROM SERVER
extension SubCatViewModel {
   func getProductsDetailsFromServer(searchText: String? = "") {
      var dictionary: Parameter
      var requestURL: String = ""
     
      if searchText?.count ?? 0 > 0 || !(searchText?.isEmpty ?? false) {
         searchRequest.search = searchText
         dictionary = self.searchRequest.dictionary
         requestURL = SEARCHEDPRODUCT
      } else {
          dictionary = self.subCatRequest.dictionary
          requestURL = CATEGORYURL
      }
      
      NetworkManager.shared.makeRequestToServer(for: requestURL,
                                                      method: .POST,
                                                      params: dictionary,
                                                      isActivityShow: true,
                                                      completionSuccess: { (subCatData) in
                
                              
                                                        
                                                        if subCatData != nil {
                                                            
                                                            if (searchText?.count ?? 0 > 0) && (!(searchText?.isEmpty ?? false)) {
                                                                
                        self.searchRespnse = self.searchRequest.getSearchProductDetails(repsonseData: subCatData!)
                                                                                           
                        if (self.subCatRequest.currentPage == "1") {
                        self.arrProducts = self.searchRespnse?.products
                        } else {
                            self.arrProducts?.append(contentsOf: self.searchRespnse?.products ?? [Product].init())
                        }
                        self.delegate?.onRecievedProductSuccess()
                                                                
                    } else {
                                                                
                self.subCatResponse = self.subCatRequest.getCatProductList(repsonseData:
                                                           subCatData!)!
                    self.arrCatProduct = self.subCatResponse.subcategories
                    
                 if (self.subCatRequest.currentPage == "1") {
                     self.arrProducts = self.subCatResponse.products
                 } else {
                     self.arrProducts?.append(contentsOf: self.subCatResponse.products)
                 }
                    
                        if self.subCatRequest.orderBy?.isEmpty ?? false && self.isFilterApply {
                    UserDefaults.standard.save(customObject: self.subCatResponse,
                                               inKey: "subCatResponse")
                }
                     self.delegate?.onRecievedProductSuccess()
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
    
   func getProductsFromServerByCategory() {
      var productResponse: SubCatResponse?
      NetworkManager.shared.makeRequestToServer(for: CATEGORYURL,
                                                      method: .POST,
                                                      params: self.subCatRequest.dictionary,
                                                      isActivityShow: true,
                                                      completionSuccess: { (subCatData) in
                
                                 if subCatData != nil {
                                    productResponse = SubCatResponse()
                                    productResponse = self.subCatRequest.getCatProductList(repsonseData:
                                                                              subCatData!)!
                                       //self.arrProducts?.removeAll()
                                    self.subCatResponse.products = productResponse?.products ?? [Product].init()
                                       //self.arrProducts = self.subCatResponse.products
                                       if (self.subCatRequest.currentPage == "1") {
                                         self.arrProducts = self.subCatResponse.products
                                      } else {
                                          self.arrProducts?.append(contentsOf: self.subCatResponse.products)
                                      }
                                     //print("Category is \(String(describing: self.arrCatProduct)) ----- \(String(describing: self.arrProducts)) ")
                                       self.delegate?.onRecievedProductSuccess()
                                       
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
extension SubCatViewModel {
   func saveProductCategories() {
      if self.arrCatProduct?.count ?? 0 > 0 {
         UserDefaults.standard.save(customObject: self.arrCatProduct, inKey: "catProductArray")
      }
   }
   
   func getProductCategory() {
      
   }
}


