//
//  LaunchViewModel.swift
//  Beer Connect
//
//  Created by Synsoft on 06/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation

class LaunchViewModal {
    
    weak var delegate: LaunchProtocol?
    var launchRespons: LaunchResponse?
    init(delegate: LaunchProtocol) { self.delegate = delegate }
}

extension LaunchViewModal {
   
   func getDetailsOfAppLaunch() {
        launchRespons = LaunchResponse()
         NetworkManager.shared.makeRequestToServer(for: APPLAUNCH,
                                                           method: .POST,
                                                           params: ["":""],
                                                           isActivityShow: false,
                                                           completionSuccess: { (launchData) in
                     
                    if launchData != nil {
                     self.launchRespons = self.launchRespons?.getLaunchDetailsFrom(repsonseData: launchData ?? Data.init())
                     if self.launchRespons != nil {
                        
                        if let status = self.launchRespons?.status?.lowercased().trim() {
                           if status.contains("success") {
                              self.saveAppLaunchDetailsFrom(appLaunchDetails: self.launchRespons)
                              self.delegate?.onRecievedSuccess()
                           }
                        }
                        
                     }
                     
                    } else {
                       self.delegate?.onFailure(errorMsg: "There might be error from server side")
                    }
                 }) {(errorObj) in
                     self.delegate?.onFailure(errorMsg: errorObj.localizedDescription)
                     print("Failure Response is \(errorObj.localizedDescription)")
           }
      
   }
}


// MARK: Manage App Launch Response Details
extension LaunchViewModal {
   func saveAppLaunchDetailsFrom(appLaunchDetails: LaunchResponse?) {
      UserDefaults.standard.save(customObject: appLaunchDetails, inKey: "appLaunch")
   }
}
