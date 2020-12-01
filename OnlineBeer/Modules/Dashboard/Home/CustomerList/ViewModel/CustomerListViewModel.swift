//
//  CustomerListViewModel.swift
//  Beer Connect
//
//  Created by Apple on 30/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

class CustomerListViewModal {
    
    weak var delegate: CustomerListProtocol?
    var customerListRequest = CustomerListRequest()
    var customerListResponse: CustomerListResponse?
    var arrCustomerList = [CustomerListData].init()
    var customerCount: Int = 10
    init(delegate: CustomerListProtocol) { self.delegate = delegate }
}

// MARK: GET CUSTOMER LIST
extension CustomerListViewModal {

    func getCustomerListFromServer() {
           self.customerListResponse = CustomerListResponse()
            NetworkManager.shared.makeRequestToServer(for: ADMINCUSTOMERLIST,
                                                      method: .POST,
                                                      params: self.customerListRequest.dictionary,
                                                      isActivityShow: true,
                                                      completionSuccess: { (listData) in
               if listData != nil {
                  self.customerListResponse = self.customerListResponse?.getCustomerListFrom(repsonseData: listData ?? Data.init())
                     if self.customerListRequest.search?.count ?? 0 > 0 {
                        self.arrCustomerList.removeAll()
                    }
            
                    if let status = self.customerListResponse?.status?.trim().lowercased() {
                        if status.contains("success") {
                            if let arrCustomerData = self.customerListResponse?.data {
                                if arrCustomerData.count > 0 &&  !(arrCustomerData.isEmpty) {
                                    if (self.customerListRequest.currentPage == "1") {
                                        self.arrCustomerList = arrCustomerData
                                    } else {
                                    self.arrCustomerList.append(contentsOf: arrCustomerData)
                                    }
                                    self.delegate?.onRecievedCustomerListSuccess()
                                } else  {
                                    if let errorMsg = self.customerListResponse?.message {
                                        if !errorMsg.isEmpty && errorMsg != "" {
                                        self.delegate?.onFailure(errorMsg: errorMsg)
                                        }
                                    }
                                }
                            }
                        }
                    }
               } else {
                if let errMsg = self.customerListResponse?.message {
                    if !errMsg.isEmpty && errMsg != "" {
                        self.delegate?.onFailure(errorMsg: errMsg)
                    }
                }}
            }) {(errorObj) in
                self.delegate?.onFailure(errorMsg: errorObj.msg ?? "No data available. Please try again.")
            }
    }
    
    
}

