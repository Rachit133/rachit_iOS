//
//  ForgotPasswordViewController.swift
//  Beer Connect
//
//  Created by Dilip Patidar on 01/04/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {
    
    @IBOutlet weak var txtFieldEmail: UITextField!

    var forgotRequest = ForgotPassRequest()
    var forgotResponse = ForgotPassResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let paddingView = UIView(frame:CGRect.init(x:0,y:0,width:15, height: self.txtFieldEmail.frame.height))
        txtFieldEmail.leftView = paddingView
        txtFieldEmail.leftViewMode = UITextField.ViewMode.always
        txtFieldEmail.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
   
    @IBAction func backMethodAction(_ sender: UIButton) {
           self.navigationController?.popViewController(animated: true)
       }
    

    
    @IBAction func actionSubmit(_ sender: UIButton) {
        if txtFieldEmail.text?.isEmpty ?? false {
             BaseViewController.showBasicAlert(message: NSLocalizedString("ALERT_USERNAME_EMPTY", comment: ""), title: NSLocalizedString("ALERT_ERROR_TITLE", comment: ""))
            return
        } else if !(txtFieldEmail.text?.isValidEmail(email: txtFieldEmail.text ?? "") ?? false) {
            BaseViewController.showBasicAlert(message: NSLocalizedString("ALERT_INVALID_EMAIL", comment: ""), title: NSLocalizedString("ALERT_ERROR_TITLE", comment: ""))
            return
        }
         // put api calling code here **********
        self.forgotRequest.userEmail = self.txtFieldEmail.text
        NetworkManager.shared.checkInternetConnectivity()
        NetworkManager.shared.makeRequestToServer(for: FORGOTPASS,
                                                      method: .POST,
                                                      params: self.forgotRequest.dictionary,
                                                      isActivityShow: true,
                                                      completionSuccess: { (forgotData) in
                
               if forgotData != nil {
                self.forgotResponse = self.forgotResponse.getForgotPassDetails(repsonseData: forgotData ?? Data.init())!
                if let status = self.forgotResponse.data?.customer?.status?.lowercased().trim() {
                     if status.contains("success") {
                        if let message = self.forgotResponse.data?.customer?.message {
                            DispatchQueue.main.async {
                                // Create the alert controller
                                let alertController = UIAlertController(title: "ALERT", message: message, preferredStyle: .alert)

                                // Create the actions
                                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                                    UIAlertAction in
                                    self.txtFieldEmail.text = ""
                                    self.txtFieldEmail.resignFirstResponder()
                                    self.navigationController?.popViewController(animated: true)
                                }
                                
                                // Add the actions
                                alertController.addAction(okAction)
                                
                                // Present the controller
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                     } else if status.contains("error") ||
                        status.contains("exception") ||
                        status == ""{
                        DispatchQueue.main.async {
                          if let message = self.forgotResponse.data?.customer?.message {
                            DispatchQueue.main.async {
                                BaseViewController.showBasicAlert(message: message)
                             }
                        }
                        }
                    }
                  }
               } else {
                    BaseViewController.showBasicAlert(message: "Somethhing went wrong. Please try again in sometime.")
            }
            }) {(errorObj) in
                BaseViewController.showBasicAlert(message: errorObj.localizedDescription)
            }
    }
}
