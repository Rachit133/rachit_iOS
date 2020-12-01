//
//  SaveTokenViewModel.swift
//  Beer Connect
//
//  Created by Apple on 15/04/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

@objc protocol SaveProtocolProtocol: class {
    @objc func onRecievedSaveTokenSuccess()
    @objc func onSaveTokenFailure(errorMsg: String)
    @objc func onRecievedRemoveSuccess()
    @objc func onRemoveFailure(errorMsg: String)
}


class SaveTokenViewModal {
    
    weak var delegate: SaveProtocolProtocol?
    var saveTokenRespons: SaveTokenResponse?
    var saveTokenRequest = SaveTokenRequest()
    var removeTokenRequest = RemoveTokenRequest()
    var removeTokenRespons: RemoveTokenResponse?

    init(delegate: SaveProtocolProtocol) { self.delegate = delegate }
}

extension SaveTokenViewModal {
    func setTokenIdForDeviceToServer() {
        self.saveTokenRespons = SaveTokenResponse()
        NetworkManager.shared.makeRequestToServer(for: SAVETOKENID,
                                                  method: .POST,
                                                  params: self.saveTokenRequest.dictionary,
                                                  isActivityShow: false,
                                                  completionSuccess: { (saveTokenData) in
                                                    
                                                    if saveTokenData != nil {
                                                        self.saveTokenRespons = self.saveTokenRespons?.saveTokenFromServer(repsonseData: saveTokenData ?? Data.init())
                                                        
                                                        if self.saveTokenRespons != nil {
                                                            if let status = self.saveTokenRespons?.data?.status?.lowercased().trim() {
                                                                if status.contains("200") {
                                                                    if let responseMessage = self.saveTokenRespons?.data?.message {
                                                                        if responseMessage.contains("success") {
                                                                            self.saveTokenIdDetails(tokenDetails: self.saveTokenRespons ?? SaveTokenResponse.init())
                                                                            UserDefaults.standard.set(true, forKey: "isTokenExists")
                                                                            self.delegate?.onRecievedSaveTokenSuccess()
                                                                        } else { self.delegate?.onSaveTokenFailure(errorMsg: self.saveTokenRespons?.message ?? "Something went wrong. Please try again.") }
                                                                    } else {
                                                                        self.delegate?.onSaveTokenFailure(errorMsg: self.saveTokenRespons?.message ?? "Something went wrong. Please try again.")
                                                                    }
                                                                } else {
                                                                    self.delegate?.onSaveTokenFailure(errorMsg: self.saveTokenRespons?.message ?? "Something went wrong. Please try again.")
                                                                }
                                                            }
                                                        }
                                                        
                                                    } else {
                                                        self.delegate?.onSaveTokenFailure(errorMsg: self.saveTokenRespons?.data?.message ?? "Something went wrong. Please try again.")
                                                    }
        }) {(errorObj) in
            
        self.delegate?.onSaveTokenFailure(errorMsg: errorObj.msg ?? "Something went wrong. Please try again.")
        }
    }
    
    func removeTokenDeviceFromServer() {
        self.removeTokenRespons = RemoveTokenResponse.init()
        NetworkManager.shared.makeRequestToServer(for: REMOVETOKENID,
                                                  method: .POST,
                                                  params: self.removeTokenRequest.dictionary,
                                                  isActivityShow: false,
                                                  completionSuccess: { (removeTokenData) in
                                                    
                                    if removeTokenData != nil {
                                        self.removeTokenRespons = self.removeTokenRespons?.removeTokenFromServer(repsonseData: removeTokenData ?? Data.init())
                                        UserDefaults.standard.removeObject(forKey: "isTokenExists")
                                        UserDefaults.standard.removeObject(forKey: "tokenDetails")
                                        UserDefaults.standard.synchronize()
                                        self.delegate?.onRecievedRemoveSuccess()
                                    } else {
                                self.delegate?.onRemoveFailure(errorMsg: self.saveTokenRespons?.data?.message ?? "Something went wrong. Please try again.")
                                }
        }) {(errorObj) in
        self.delegate?.onRemoveFailure(errorMsg: errorObj.msg ?? "Something went wrong. Please try again.")
        }
    }

    
    func saveTokenIdDetails(tokenDetails: SaveTokenResponse) {
        // You can get Token Details From Base ViewController
        UserDefaults.standard.save(customObject: tokenDetails, inKey: "tokenDetails")
    }
}
