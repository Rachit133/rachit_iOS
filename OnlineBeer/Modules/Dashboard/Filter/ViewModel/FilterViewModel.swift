//
//  FilterViewModel.swift
//  Beer Connect
//
//  Created by Apple on 31/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

class FilterViewModel {
    
   weak var delegate: FilterProtocol?
   var subCatRequest = SubCatRequest()
   var subCatResponse = SubCatResponse()
    
   var filterResponse: FilterResponse?
   var arrSubCatProducts: [Subcategory]?
   var arrProducts = [Product].init()

   init(delegate: FilterProtocol) { self.delegate = delegate }
}

// MARK: GET MY CART PRODUCTS FROM SERVER
extension FilterViewModel {
   
    func getFilterCatProductFromServer() {
    
      filterResponse = FilterResponse.init()
      
      NetworkManager.shared.makeRequestToServer(for: FILTERCAT,
                                                method: .POST,
                                                params: [String: Any].init(),
                                                isActivityShow: true,
                                                completionSuccess: { (filterData) in
                                                   
                                                   if filterData != nil {
                                                    self.filterResponse = self.filterResponse?.getFilterSubCategoryFrom(repsonseData: filterData ?? Data.init())
                                                      
                                                      if self.filterResponse != nil {
                                                        self.arrSubCatProducts = self.filterResponse?.subcategories
                                                      self.delegate?.onReceivedFilterSuccess()
                                                      } else {
                                                         self.delegate?.onFailure(errorMsg: "Server is not responding. Please try later.")
                                                      } } else {
                                                      self.delegate?.onFailure(errorMsg: "Server is not responding. Please try later.")
                                                   }
      }) {(errorObj) in
         self.delegate?.onFailure(errorMsg: "Server is not responding. Please try later.")
      }
   }
    
    func getProductsFromServerByCategory() {
       filterResponse = FilterResponse.init()
       NetworkManager.shared.makeRequestToServer(for: CATEGORYURL,
                                                       method: .POST,
                                                       params: self.subCatRequest.dictionary,
                                                       isActivityShow: true,
                                                       completionSuccess: { (subCatData) in
                 
                                  if subCatData != nil {
                                     self.filterResponse = self.filterResponse?.getFilterSubCategoryFrom(repsonseData: subCatData ?? Data.init())
                                     
                                     if self.filterResponse != nil {
                                       self.arrSubCatProducts = self.filterResponse?.subcategories
                                        self.delegate?.onReceivedFilterSubCatSuccess()
                                    } else {
                                       self.delegate?.onFailure(errorMsg: "Server is not responding. Please try later.")
                                    } } else {
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
