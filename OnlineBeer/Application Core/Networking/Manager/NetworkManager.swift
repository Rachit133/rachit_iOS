//
//  NetworkManager.swift
//  CVDelight_Partner
//
//  Created by Apple on 17/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit
import IHProgressHUD

typealias Parameter = [String: Any]

//HTTP Methods
enum HttpTypeMethod : String {
   case  GET
   case  POST
   case  DELETE
   case  PUT
}

// MARK: - Connectivity
class Connectivity {
   class var isConnectedToInternet: Bool {
      return NetworkReachabilityManager()!.isReachable
   }
}

class NetworkManager {
   static let shared = NetworkManager()
   let isInternetAvailable = NetworkReachabilityManager()?.isReachable
}

// MARK: -
extension NetworkManager {
   
   func makeRequestToServer(for endPoint: String,
                            method: HttpTypeMethod,
                            params: Parameter = ["":""],
                            headers: HTTPHeaders? = nil,
                            isActivityShow: Bool = false,
                            completionSuccess:@escaping ((Data?) -> Swift.Void),
                            completionFailure: @escaping ((ErrorManager) -> Swift.Void)) {
      
       print("end Point is: \(endPoint) \n \n Paramter is : \(params)")
     
    
      DispatchQueue.main.async {
         //self.checkInternetConnectivity()
         if isActivityShow { self.showProgressActivity() }
      }
     
      let url = String(format: endPoint)
      guard let serviceUrl = URL(string: url) else { return }
      var request = URLRequest(url: serviceUrl)
      request.httpMethod = method.rawValue
      request.allHTTPHeaderFields = self.getHeader()
      
    if !endPoint.contains(GETNOTIFICATION) {
        request.httpBody = params.percentEncoded()
    }
      let sessionConfig = URLSessionConfiguration.default
      sessionConfig.timeoutIntervalForRequest = 70.0
      sessionConfig.timeoutIntervalForResource = 70.0
      let session = URLSession(configuration: sessionConfig)
      
      session.dataTask(with: request) { (responseData, response, error) in
         
         DispatchQueue.main.asyncAfter(deadline: .now()) {
            //self.checkInternetConnectivity()
            if isActivityShow { self.hideProgressActivity() }
         }
        
         if let responseData = responseData {
            do {
               let jsonResponse = try JSON(data: responseData)
               print("Json Response \(jsonResponse)")
                let isApiErrorFound = self.handleApiError(JSON: jsonResponse)
               if !isApiErrorFound {
                     completionSuccess(responseData)
                     return
               } else {
                  DispatchQueue.main.async {
                                   //self.checkInternetConnectivity()
                                   completionFailure(ErrorManager.init(errorCode: 0,
                                                                       message: "Server not responding. Please try again."))
                                }
                 }
            } catch {
               DispatchQueue.main.async {
                  //self.checkInternetConnectivity()
                  completionFailure(ErrorManager.init(errorCode: 0,
                                                      message: "Server not responding. Please try again."))
               }
            }
            
         }
         
         if error != nil || responseData == nil {
            return
                /* DispatchQueue.main.async {
                    completionFailure(ErrorManager.init(errorCode: 0,
                                                        message: error?.localizedDescription ?? "Server not responding. Please try again.."))
                    return
                }*/
        }
                 
         guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                                                
                        if let responseData = responseData {
                          do {
                             let jsonResponse = try JSON(data: responseData)
                             //print("Json Response \(jsonResponse)")
                             _ = self.handleApiError(JSON: jsonResponse)
                          } catch(let error){
                             //print("Error is \(error.localizedDescription)")
                             DispatchQueue.main.async {
                                
                                //                        if isActivityShow {
                                //                           UIApplication.shared.endIgnoringInteractionEvents()
                                //                           self.hideProgressActivity() }
                                completionFailure(ErrorManager.init(errorCode: 0,
                                                                    message: error.localizedDescription))
                             }
                          }
                          
                       }
                       return
                 }
                 
        guard (response?.mimeType) != nil else {
                  print("Wrong MIME type!")
                  //            DispatchQueue.main.async {
                  //               if isActivityShow {
                  //                  UIApplication.shared.endIgnoringInteractionEvents()
                  //                  self.hideProgressActivity() }
                  DispatchQueue.main.async {
                     completionFailure(ErrorManager.init(errorCode: 0,
                                                         message: "Server not responding. Please try again."))
                  }
                  return
               }
         
      }.resume()
   }
}

extension NetworkManager {
   func getHeader() -> HTTPHeaders {
      var apiHeader = [String: String].init()
      //apiHeader["ced_mage_api"] = "mobiconnect"
      apiHeader["uid"] = HEADERKEY
      //apiHeader["langid"] = "en-US"
      return apiHeader
   }
   
   func decode<T: Decodable>(_ data: Data, completion: @escaping ((T) -> Void)) {
      do {
         let model = try JSONDecoder().decode(T.self, from: data)
         completion(model)
      } catch { }//log(error.localizedDescription, level: .error) }
   }
}


extension NetworkManager {
   
   func handleApiError(JSON: JSON) -> Bool {
      //self.checkInternetConnectivity()
    let isErrorFound: Bool = false
      if let dataDict = JSON.dictionary {
         if dataDict["data"]?.exists() ?? false {
            let errorDict = dataDict["data"]?.dictionary
         if dataDict["success"]?.exists() ?? false {
            if let status = errorDict?["success"]?.boolValue {
               if !status {
                  //if let errorMessage = errorDict?["message"]?.string {
//                     DispatchQueue.main.async {
//                        isErrorFound = true
//                        BaseViewController.showBasicAlert(message: "Server not responding. Please try again.", title: "ERROR")
//                        return
//                     }
                 // }
               }
               
            }
         } else {
               if let status = errorDict?["status"]?.stringValue {
                  if status.lowercased().trim() != "success" {
                     //if let errorMessage = errorDict?["message"]?.string {
                           //isErrorFound = true
                    //}
                        //BaseViewController.showBasicAlert(message: "Server not responding. Please try again.", title: "ERROR")
                         //  return

                        //}
                     //}
                  }
               }
            }
         } else {
            return isErrorFound
            //DispatchQueue.main.async {
            //isErrorFound = true
            //BaseViewController.showBasicAlert(message: "No data coming from server.",
            //title: "ERROR")
            //}
         }
      }
      return isErrorFound
   }
}

extension NetworkManager {
   func checkInternetConnectivity() {
      if !Connectivity.isConnectedToInternet {
         DispatchQueue.main.async {
            BaseViewController.showAlert(title: NSLocalizedString("Alert", comment: ""),
                                         message: "Please check your Internet connection and try again.",
                                         buttonTitle: NSLocalizedString("OK", comment: ""))
            return
         }
      }
   }
}

// MARK: Show/ hide Activity Indicator
extension NetworkManager {
   func setUpProgressBar() {
      IHProgressHUD.set(defaultMaskType: .black)
      IHProgressHUD.set(backgroundColor: UIColor.darkBlueGreyTwo.withAlphaComponent(0.65))
      IHProgressHUD.setHUD(backgroundColor: UIColor.darkBlueGreyTwo)
      IHProgressHUD.set(foregroundColor: UIColor.darkBlueGreyTwo)
      IHProgressHUD.set(defaultAnimationType: .flat)
      IHProgressHUD.set(defaultStyle: .light)
   }
   
   func showProgressActivity() {
      UIApplication.shared.beginIgnoringInteractionEvents()
      IHProgressHUD.show()
   }
   
   func hideProgressActivity() {
      IHProgressHUD.dismiss()
      UIApplication.shared.endIgnoringInteractionEvents()
   }
   
}
