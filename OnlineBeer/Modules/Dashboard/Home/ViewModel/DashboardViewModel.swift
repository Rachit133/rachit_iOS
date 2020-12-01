//
//  DashboardViewModel.swift
//  Beer Connect
//
//  Created by Synsoft on 11/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation
import UIKit


class DashboardViewModal {
    
    weak var delegate: DashboardProtocol?
    
    var dashboardRequest = DashboardRequest()
    var response: DashboardResponse?

    var wishlistRequest = SetWishListRequest.init()
    var wishlistResponse = SetWishListResponse()

    var cartCountRequest = CartCountRequest.init()
    var cartCountResponse: CartCountResponse?
   
    var adminCustomerLoginRequest = AdminCustomerLoginRequest.init()
    var loginResponse: LoginResponse?
    var arrProduct: [ProductCategory]?
    var arrDealsProduct: [Product]?
    var arrBestSellerProduct: [Product]?
    var wishlistResponseMsg = String()
   
    init(delegate: DashboardProtocol) { self.delegate = delegate }
}

// MARK:  GET PRODUCT LIST FROM SERVER
extension DashboardViewModal {
    
    func getProductsFromServer() {
         NetworkManager.shared.checkInternetConnectivity()
         response = DashboardResponse()
         NetworkManager.shared.makeRequestToServer(for: DASHBOARDURL,
                                                      method: .POST,
                                                      params: self.dashboardRequest.dictionary,
                                                      isActivityShow: true,
                                                      completionSuccess: { (dashboardData) in
                
               if dashboardData != nil {
                  self.response = self.dashboardRequest.getProductList(repsonseData: dashboardData!)!
                  if self.response != nil {
                     self.arrProduct = self.response?.allCategories?.categories
                     self.arrDealsProduct = self.response?.dealProducts?.products
                     self.arrBestSellerProduct = self.response?.bestSellingProducts?.products
                     self.delegate?.onRecievedProductsSuccess()
                  }
               } else {
                  self.delegate?.onFailure(errorMsg: "There might be error from server side")
               }
            }) {(errorObj) in
                self.delegate?.onFailure(errorMsg: errorObj.localizedDescription)
                print("Failure Response is \(errorObj.localizedDescription)")
      }
   }
   
   func setUserWishlist() {
   
      NetworkManager.shared.makeRequestToServer(for: SETWISHLIST,
                                                   method: .POST,
                                                   params: self.wishlistRequest.dictionary,
                                                   isActivityShow: false,
                                                   completionSuccess: { (wishlistData) in
         if wishlistData != nil {
            self.wishlistResponse = self.wishlistResponse.getWishlistResponse(repsonseData: wishlistData ?? Data.init()) ?? SetWishListResponse.init()
            if let reponseMsg = self.wishlistResponse.message {
               self.wishlistResponseMsg = reponseMsg
               self.delegate?.onRecievedWishlistResponse()
            }
         } else {
            self.delegate?.onFailure(errorMsg: "There might be error from server side")
         }
      }, completionFailure: { (errorObj) in
         self.delegate?.onFailure(errorMsg: errorObj.msg ?? "There might be error from server side")
      })
}
   
   func getCartCountStatus() {
         cartCountResponse = CartCountResponse()
         NetworkManager.shared.makeRequestToServer(for: CARTCOUNT,
                                                      method: .POST,
                                                      params: self.cartCountRequest.dictionary,
                                                      isActivityShow: true,
                                                      completionSuccess: { (cartCountData) in
            if cartCountData != nil {
               self.cartCountResponse = self.cartCountResponse?.getCartCountResponse(repsonseData: cartCountData ?? Data.init())
               
               if self.cartCountResponse != nil {
                  if let cartCount: Int = self.cartCountResponse?.data?.itemsCount {
                     self.delegate?.onCartCountSuccess(cartCount: cartCount)
                  } else {
                     self.delegate?.onCartFailure(errorMsg: "There might be error from server side")
                  }
               }
            } else {
               self.delegate?.onFailure(errorMsg: "There might be error from server side")
            }
         }, completionFailure: { (errorObj) in
            self.delegate?.onFailure(errorMsg: errorObj.msg ?? "There might be error from server side")
         })
   }

}

// MARK: Manage Dashboard Response Details
extension DashboardViewModal {
   func saveDashboardFrom(dashboardDetails: LoginResponse) {
      //UserDefaults.standard.set(true, forKey: "login")
      //UserDefaults.standard.save(customObject: loginDetails, inKey: "loginUser")
   }
}

// MARK: ADMIN AS CUSTOMER LOGIN RESPONSE
extension DashboardViewModal {
    func salesPersonAsCustomerLoginRequest() {
        loginResponse = LoginResponse.init()
        
        NetworkManager.shared.makeRequestToServer(for: GETCUSTOMERLOGIN,
                                                      method: .POST,
                                                      params: self.adminCustomerLoginRequest.dictionary,
                                                      isActivityShow: true,
                                                      completionSuccess: { (loginData) in
                
               if loginData != nil {

                if UserDefaults.standard.isKeyPresentInUserDefaults(key: "loginUser") {
                   UserDefaults.standard.removeObject(forKey: "loginUser")
                   UserDefaults.standard.synchronize()
                }
                if UserDefaults.standard.isKeyPresentInUserDefaults(key: "login") {
                    UserDefaults.standard.removeObject(forKey: "login")
                    UserDefaults.standard.synchronize()
                }
                
                self.loginResponse = self.adminCustomerLoginRequest.getCustomerLoginDetails(repsonseData: loginData ?? Data.init()) ?? LoginResponse.init()
                if let status = self.loginResponse?.data?.status?.lowercased().trim() {
                     if status.contains("success") {
                        self.saveCustomerLoginDetailsFrom(customerLoginDetails: self.loginResponse ?? LoginResponse.init())
                        self.delegate?.onAdminCustomerLoginSuccess!()
                     } else {
                        if status.contains("error") || status.contains("exception") || status.isEmpty || status == "" {
                            if let message = self.loginResponse?.data?.message {
                                self.delegate?.onFailure(errorMsg: message)
                            }
                        }
                        
                    }
                  }
               }
            }) {(errorObj) in self.delegate?.onFailure(errorMsg: errorObj.msg ?? "") }
        
    }
}

// MARK: Manage Login Response Details
extension DashboardViewModal {
    func saveCustomerLoginDetailsFrom(customerLoginDetails: LoginResponse) {
      UserDefaults.standard.save(customObject: customerLoginDetails, inKey: "loginUser")
      UserDefaults.standard.set(true, forKey: "login")
    }
    
}
