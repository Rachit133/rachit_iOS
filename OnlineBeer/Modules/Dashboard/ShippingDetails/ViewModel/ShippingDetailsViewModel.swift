//
//  ShippingDetailsViewModel.swift
//  Beer Connect
//
//  Created by Synsoft on 26/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation
import UIKit


class ShippingDetailsViewModel {
   
   weak var delegate: ShippingDetailsProtocol?
   var shippingDetailRequest = ShippingDetailRequest()
   var shippingSaveRequest = ShippingSaveRequest()
   var shippingDetailResponse: ShippingDetailResponse?
   
   init(delegate: ShippingDetailsProtocol) { self.delegate = delegate }
}

// MARK: GET SHIPPING DETAILS PRODUCTS FROM SERVER
extension ShippingDetailsViewModel {
   
   func getShippingDetailsProductFromServer() {
      shippingDetailResponse = ShippingDetailResponse.init()
      NetworkManager.shared.makeRequestToServer(for: ADDRESSHIPPING,
                                                method: .POST,
                                                params: self.shippingDetailRequest.dictionary,
                                                isActivityShow: true,
                                                completionSuccess: { (shipppingCartData) in
                                                   
                                                   if shipppingCartData != nil {
                                                      self.shippingDetailResponse = self.shippingDetailResponse?.getShippingDetailsFrom(repsonseData: shipppingCartData ?? Data.init())
                                                      if self.shippingDetailResponse != nil {
                                                         
                                                         self.saveShippingDetailsFrom(shippingDetails: self.shippingDetailResponse ?? ShippingDetailResponse.init())
                                                         self.delegate?.onRecievedShippingDetailsSuccess()
                                                         
                                                      } else {
                                                         self.delegate?.onDetailsFailure(errorMsg: "No data coming from server.")
                                                      } } else {
                                                      self.delegate?.onDetailsFailure(errorMsg: "No data coming from server.")
                                                   }
      }) {(errorObj) in
         self.delegate?.onDetailsFailure(errorMsg: errorObj.localizedDescription)
         print("Failure Response is \(errorObj.localizedDescription)")
      }
   }
   
   func saveShippingDetailsToServer() {
      
      NetworkManager.shared.makeRequestToServer(for: SAVEADDRESS,
                                                method: .POST,
                                                params: self.shippingSaveRequest.dictionary,
                                                isActivityShow: true,
                                                completionSuccess: { (shipppingCartData) in
                                                   
                                                   if shipppingCartData != nil {
                                                      self.delegate?.onRecievedSaveAddressSuccess(data: shipppingCartData ?? Data.init())
                                                   } else {
                                                      self.delegate?.onDetailsFailure(errorMsg: "No data coming from server.")
                                                   }
      }) {(errorObj) in
         self.delegate?.onDetailsFailure(errorMsg: errorObj.localizedDescription)
         print("Failure Response is \(errorObj.localizedDescription)")
      }
   }
}

// MARK: Manage Dashboard Response Details
extension ShippingDetailsViewModel {
   func saveShippingDetailsFrom(shippingDetails: ShippingDetailResponse) {
      UserDefaults.standard.save(customObject: shippingDetails, inKey: "shippingDetails")
   }

   func saveShippingInfoFrom(shippingDetails: ShippingDetailResponse) {
      UserDefaults.standard.save(customObject: shippingDetails, inKey: "shippingDetails")
   }
}
