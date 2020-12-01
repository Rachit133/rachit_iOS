//
//  SearchViewModel.swift
//  Beer Connect
//
//  Created by Synsoft on 06/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

class SearchViewModal {
    
    weak var delegate: SearchProtocol?
    var searchRequest = SearchRequest()
    var searchResponse: SearchResponse?
    var arrRecentSearch = [Product].init()
   
    init(delegate: SearchProtocol) { self.delegate = delegate }
}

// MARK: LOGIN CALL TO SERVER
extension SearchViewModal {
    func searchProductFromServer() {
        //if isSearchValidate() {
            //self.delegate?.isActivityIndicatorVisible(status: true)
            NetworkManager.shared.makeRequestToServer(for: SEARCHURL,
                                                      method: .POST,
                                                      params: self.searchRequest.dictionary,
                                                      isActivityShow: true,
                                                      completionSuccess: { (searchData) in
               if searchData != nil {
                  self.searchResponse = SearchResponse()
                    if (self.searchRequest.currentPage == "1") {
                        self.searchResponse = self.searchRequest.getSearchProductDetails(repsonseData: searchData ?? Data.init()) ?? SearchResponse.init()
                        self.arrRecentSearch = self.searchResponse?.products ?? []
                    } else {
                        
                       let response = SearchRequest().getSearchProductDetails(repsonseData: searchData ?? Data.init()) ?? SearchResponse.init()
                        self.searchResponse?.productCount = response.productCount
                        self.arrRecentSearch.append(contentsOf:response.products ?? [])
                    }
                  
                  if self.searchResponse != nil {
                     self.delegate?.onSearchSuccess()
                  }
               } else {
                     self.delegate?.onSearchFailure(errorMsg:"Data is not coming from server")
                  }
            }) {(errorObj)
                 in
                self.delegate?.onSearchFailure(errorMsg: errorObj.localizedDescription)
            }
    }
    
    func isSearchValidate() -> Bool {
        var isValidate: Bool = true
        var searchtxt: String? = ""
       if let searchText = self.searchRequest.search { searchtxt = searchText }
        if searchtxt?.isEmpty ?? false {
            isValidate = false
            print("Search can not empty")
            self.delegate?.onValidationErrorAlert(
                     title: NSLocalizedString("ALERT_ERROR_TITLE", comment: ""),
                     message: NSLocalizedString("ALERT_USERNAME_EMPTY", comment: ""))
        }
        return isValidate
    }
    
    func getSearchProductsFromServer() {
       NetworkManager.shared.makeRequestToServer(for: SEARCHEDPRODUCT,
                                                       method: .POST,
                                                       params: self.searchRequest.dictionary,
                                                       isActivityShow: true,
                                                       completionSuccess: { (searchData) in
                if searchData != nil {
                                                
                    self.searchResponse = self.searchRequest.getSearchProductDetails(repsonseData: searchData ?? Data.init())
                        if (self.searchRequest.currentPage == "1") {
                        self.arrRecentSearch = self.searchResponse?.products ?? [Product].init()
                        } else {
                        self.arrRecentSearch.append(contentsOf: self.searchResponse?.products ?? [Product].init())
                        }
                        self.delegate?.onSearchSuccess()
                    } else {
                    var statusMsg: String? = ""
                    if self.searchResponse?.message?.contains("failure") ?? false {
                        statusMsg = self.searchResponse?.message
                    }
                    self.delegate?.onSearchFailure(errorMsg: statusMsg ?? "No data available.")
                }
             }) {(errorObj) in
                self.delegate?.onSearchFailure(errorMsg: errorObj.msg ?? "Data not available. Please try later.")
       }
    }
}

// MARK: Manage Search Product Response
extension SearchViewModal {
   func populateProductList() {
      if self.searchResponse != nil {
         if let statusStr = self.searchResponse?.status?.lowercased().trim() {
            if (!statusStr.isEmpty) || !(self.searchResponse?.message?.isEmpty ?? false) {
               if statusStr.contains("200") || self.searchResponse?.message?.contains("success") ?? false {
                     
               }
            }
         }
         
      }
   }
   
}
