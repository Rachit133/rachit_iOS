//
//  OrderListViewModel.swift
//  Beer Connect
//
//  Created by Synsoft on 17/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation


class OrderListViewModel {
   
   weak var delegate: OrderListProtocol?
   var orderListRequest = OrderListRequest()
   var orderListResponse: OrderListResponse?
   var arrOrderList = [Orders].init()
   init(delegate: OrderListProtocol) { self.delegate = delegate }
}

// MARK: GET ORDER LIST PRODUCTS FROM SERVER
extension OrderListViewModel {
   func getOrderListProductFromServer() {
    
      orderListResponse = OrderListResponse.init()
      
      NetworkManager.shared.makeRequestToServer(for: ORDERPRODUCTLIST,
                                                method: .POST,
                                                params: self.orderListRequest.dictionary,
                                                isActivityShow: true,
                                                completionSuccess: { (orderListData) in
                if orderListData != nil {
                    self.orderListResponse = self.orderListResponse?.getOrderListObjectFrom(repsonseData: orderListData ?? Data.init())
                        if self.orderListResponse != nil {
                        if let messageStr = self.orderListResponse?.message {
                            if (!messageStr.isEmpty) && messageStr != "" {
                                if messageStr.contains("success") {
                                    if let orderList = self.orderListResponse?.orders {
                                        
                                        if (!orderList.isEmpty) && orderList.count > 0 {
                                            if (self.orderListRequest.currentPage == "1") {
                                                self.arrOrderList = orderList
                                            } else {
                                                self.arrOrderList.append(contentsOf: orderList)
                                            }
                                        }
                                        self.delegate?.onReceivedOrderListSuccess()
                                    }
                                } else {
                                   var errorMsg = ""
                                   if let errMsg = self.orderListResponse?.message {
                                       errorMsg = errMsg
                                   }
                                    self.delegate?.onFailure(errorMsg: errorMsg)
                                }
                                } else {}
                            }
                        } else {
                            var errorMsg = ""
                            if let errMsg = self.orderListResponse?.message {
                                errorMsg = errMsg
                            }
                            self.delegate?.onFailure(errorMsg: errorMsg)
                     } } else {
                        self.delegate?.onFailure(errorMsg: "No data found. Please try again.")
                     }
                }) {(errorObj) in
            self.delegate?.onFailure(errorMsg: errorObj.msg ?? "No data found. Please try again.")
        }
    }
}

// MARK: Save Order list Response Details
extension OrderListViewModel {
   func saveOrderListFrom(orderListrResponse: OrderListResponse) {
      UserDefaults.standard.save(customObject: orderListrResponse, inKey: "orderList")
   }
}
