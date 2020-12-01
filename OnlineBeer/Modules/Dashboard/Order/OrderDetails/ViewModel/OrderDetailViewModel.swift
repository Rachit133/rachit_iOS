//
//  OrderDetailViewModel.swift
//  Beer Connect
//
//  Created by Synsoft on 17/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation


class OrderDetailViewModel {
   
   weak var delegate: OrderDetailProtocol?
   
   var orderDetailRequest = OrderDetailsRequest()
   var orderDetailResponse: OrderDetailsResponse?
   
   var orderEmailDownloadRequest = OrderEmailDownloadRequest()
   var orderEmailDownloadResponse: OrderEmailDownloadResponse?
   
   var arrOrderItems = [OrderItems].init()
   var arrRefunds = [Refunds].init()

   init(delegate: OrderDetailProtocol) { self.delegate = delegate }
}

// MARK: GET ORDER DETAILS PRODUCTS FROM SERVER
extension OrderDetailViewModel {
   
   func getOrderDetailsFromServer() {
      orderDetailResponse = OrderDetailsResponse.init()
      NetworkManager.shared.makeRequestToServer(for: ORDERPRODUCTDETAIL,
                                                method: .POST,
                                                params: self.orderDetailRequest.dictionary,
                                                isActivityShow: true,
                                                completionSuccess: { (orderDetailsData) in
                                                   
                                                if orderDetailsData != nil {
                                                   self.orderDetailResponse = self.orderDetailResponse?.getOrderDetailsFrom(repsonseData: orderDetailsData ?? Data.init())
                                                  
                                                   if self.orderDetailResponse != nil {
                                                      
                                                      if let arrItems = self.orderDetailResponse?.ordersData?.orderItems {
                                                        if arrItems.count > 0 {
                                                            self.arrOrderItems = arrItems
                                                        }
                                                      }
                                                      
                                                    
                                                    if let arrRefundInfo = self.orderDetailResponse?.ordersData?.refunds {
                                                        if arrRefundInfo.count > 0 {
                                                            self.arrRefunds = arrRefundInfo
                                                        }
                                                    }
                                                    self.delegate?.onReceivedOrderDetailSuccess()
                                                
                                                   } else {
                                                      self.delegate?.onFailure(errorMsg: "There might be error from server side")
                                                   }
                                                } else {
                                                      self.delegate?.onFailure(errorMsg: "There might be error from server side")
                                                }
      }) {(errorObj) in
         self.delegate?.onFailure(errorMsg: errorObj.localizedDescription)
         print("Failure Response is \(errorObj.localizedDescription)")
      }
   }
   
   func getRequestForEmailOrDownloadReciept() {
      var isIndicatorShow: Bool = false
      orderEmailDownloadResponse = OrderEmailDownloadResponse.init()

      if self.orderEmailDownloadRequest.actionType?.contains("email") ?? false {
         isIndicatorShow = true
      }else{
         isIndicatorShow = false
      }

      NetworkManager.shared.makeRequestToServer(for: ORDEREMAILDOWNLOAD,
                                                     method: .POST,
                                                     params: self.orderEmailDownloadRequest.dictionary,
                                                     isActivityShow: true,
                                                     completionSuccess:
                                                { (orderEmailDownloadData) in
                                                        
                          if orderEmailDownloadData != nil {
                          
                           self.orderEmailDownloadResponse = self.orderEmailDownloadResponse?.getOrderEmailDownloadFrom(repsonseData: orderEmailDownloadData ?? Data.init())
                           
                             if self.orderEmailDownloadResponse != nil {
                                if let statusStr = self.orderEmailDownloadResponse?.status {
                                 if statusStr.contains("success") {
                                    self.saveOrderEmailDownloadFrom(orderEmail: self.orderEmailDownloadResponse ?? OrderEmailDownloadResponse.init())
                                    self.delegate?.onReceivedOrderEmailDownloadSuccess()
                                 }
                              }
                             } else {
                                self.delegate?.onFailure(errorMsg: "There might be error from server side")
                             }
                           
                          } else {
                              self.delegate?.onFailure(errorMsg: "There might be error from server side")
                          }
           }) {(errorObj) in
      
      }
      
   }
   
   func downloadFileFromServerWith(url: String) {
      
      NetworkManager.shared.makeRequestToServer(for: url,
                                                     method: .POST,
                                                     isActivityShow: true,
                                                     completionSuccess: { (fileData) in
                                                     
                                             if fileData != nil {
                                                   self.delegate?.onDownloadFileSuccess(fileData: fileData)
                                             } else {
                                                   self.delegate?.onFailure(errorMsg: "file details is not getting from server.")
                                             }
           }) {(errorObj) in
              self.delegate?.onFailure(errorMsg: errorObj.localizedDescription)
              print("Failure Response is \(errorObj.localizedDescription)")
           }
   }
   
}

// MARK: Save Order Details Response Details
extension OrderDetailViewModel {
   
   func saveOrderDetailsDetailsFrom(orderDetails: OrderDetailsResponse) {
      UserDefaults.standard.save(customObject: orderDetails, inKey: "orderDetails")
   }
   
   func saveOrderEmailDownloadFrom(orderEmail: OrderEmailDownloadResponse) {
      UserDefaults.standard.save(customObject: orderEmail, inKey: "orderEmailDownload")
   }
}
