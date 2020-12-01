//
//  ViewController.swift
//  Beer Connect
//
//  Created by Synsoft on 20/01/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit
import SDWebImage

class LoginViewController: BaseViewController {
   
   // MARK: - ALL IBOUTLET CONNNECTIONS & VARIABLE
   @IBOutlet weak var imgLogo: UIImageView!
   @IBOutlet weak var imgBackground: UIImageView!
   @IBOutlet weak var loginView: UIView!
   @IBOutlet weak var userNameTextfield: UITextField!
   @IBOutlet weak var passwordTxtField: UITextField!
   @IBOutlet weak var signUpBtnView: UIView!
   @IBOutlet weak var loginBtnView: UIView!
   @IBOutlet weak var loginBtn: UIButton!
   @IBOutlet weak var signUpBtn: UIButton!
   @IBOutlet weak var passBtnShowHide: UIButton!
   @IBOutlet weak var lblSignUp: UILabel!
   @IBOutlet weak var lblAccount: UILabel!
   @IBOutlet weak var lblLoginTitle: UILabel!

    let delegate = UIApplication.shared.delegate
   let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
   
   var viewModal: LoginViewModal?
   var launchVM: LaunchViewModal?
    var tokenViewModel: SaveTokenViewModal?

   var isLogin: Bool = false
   var signUpUrl: String = ""
   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view.
      initComponents()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      
      self.manageNavigationUI()
   }
   
   
   override var preferredStatusBarStyle: UIStatusBarStyle {
      return .default
   }
}

// MARK: - MANAGE LOGIN / DASHBOARD VC
extension LoginViewController {
   
   func gotoDashboard() {
      let storyBoard = UIStoryboard.init(name:
         STORYBOARDCONS.DASHBOARD, bundle: Bundle.main)
      if let mainTabBarVC =
         storyBoard.instantiateViewController( withIdentifier:
            VCIDENTIFIER.CUSTOMTABBARVC) as? CustomTabBarController {
         self.navigationController?.pushViewController(mainTabBarVC,
                                                       animated: true)
      }
   }
}
// MARK: - VIEW INITIALIZATION & SETUP LOGIN PROPERTIES
extension LoginViewController {
   func initComponents() {
      self.setUpAppLaunchService()
      self.setCornerRadius()
      self.populateSubviews()
      self.manageLoginTextFieldProperties()
      self.initializeViewModal()
   }
   
   func populateServerImages() {
      let onLaunchDetails = self.getOnLaunchDetails()
      
      self.imgBackground.sd_imageIndicator = SDWebImageActivityIndicator.medium
      
      self.imgBackground.sd_setImage(with: URL(string: onLaunchDetails.backImg), placeholderImage: UIImage(named: "backScreen"), options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, url) in
         if error != nil {
            self.imgBackground.contentMode = .scaleToFill
            self.imgBackground.image = UIImage(named: "backScreen")
         } else {
            self.imgBackground.contentMode = .scaleToFill
            self.imgBackground.image = image
         }
      })
      
      self.imgLogo.sd_imageIndicator = SDWebImageActivityIndicator.medium

      self.imgLogo.sd_setImage(with: URL(string: onLaunchDetails.logoUrl), placeholderImage: UIImage(named: "logo"), options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, url) in
         if error != nil {
            self.imgLogo.contentMode = .scaleAspectFit
            self.imgLogo.image = UIImage(named: "logo")
         } else {
            self.imgLogo.contentMode = .scaleAspectFit
            self.imgLogo.image = image
         }
      })
      
    if onLaunchDetails.signUpUrl != "" && !(onLaunchDetails.signUpUrl.isEmpty) {
        self.signUpUrl = onLaunchDetails.signUpUrl
    } else {
        //self.setUpAppLaunchService()
    }
   }
   
   func setBlurrEffectToVC() { self.imgBackground.addBlurEffect() }
   
   func manageNavigationUI() {
      self.lblLoginTitle.text = NSLocalizedString("LOGIN_TITLE", comment: "")
      if #available(iOS 11.0, *) {
         self.navigationController?.navigationBar.prefersLargeTitles = false
         self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorConstants.APPBLUECOLOR,
         NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Bold", size: 34)!]
      }
   }
   
   func setCornerRadius() {
      self.loginBtnView.roundCorners([.layerMaxXMaxYCorner, .layerMaxXMinYCorner],
                                     radius: 25,
                                     borderColor: UIColor.clear,
                                     borderWidth: 0.1)
      self.signUpBtnView.roundCorners([.layerMaxXMaxYCorner, .layerMaxXMinYCorner],
                                      radius: 25,
                                      borderColor: UIColor.clear,
                                      borderWidth: 0.1)
      self.loginView.roundCorners([.layerMaxXMaxYCorner, .layerMaxXMinYCorner],
                                  radius: 15,
                                  borderColor: .lightText,
                                  borderWidth: 1)
   }
   
   func initializeViewModal() {
      self.viewModal = LoginViewModal(delegate: self)
      if UserDefaults.standard.isKeyPresentInUserDefaults(key: "login") {
         let isLogin: Bool? = UserDefaults.standard.bool(forKey: "login")
         if isLogin ?? false {
            manageLoginResponse()
         }
      } else if UserDefaults.standard.isKeyPresentInUserDefaults(key: "adminSalesDetails") {
        if let adminCustomerLoginDetails = UserDefaults.standard.retrieve(object: LoginResponse.self, fromKey: "adminSalesDetails") {
            if (adminCustomerLoginDetails.data != nil) {
                if let isSalesPerson = adminCustomerLoginDetails.data?.customer?.salePerson {
                    if isSalesPerson {
                        self.manageLoginResponse()
                    }
                }
            }
        }
      }
   }
   
    func manageLoginResponse() {
        self.view.endEditing(true)
        self.passwordTxtField.text = ""
        self.userNameTextfield.text = ""
        if UserDefaults.standard.isKeyPresentInUserDefaults(key: "adminSalesDetails") {
            if let adminSalesDetails = UserDefaults.standard.retrieve(object: LoginResponse.self, fromKey: "adminSalesDetails") {
                if let tokenId = adminSalesDetails.data?.customer?.hash {
                    if !(tokenId.isEmpty) && tokenId != "" {
                        if UserDefaults.standard.isKeyPresentInUserDefaults(key: "adminLogin") {
                            UserDefaults.standard.set(true, forKey: "adminLogin")
                            UserDefaults.standard.synchronize()
                        }
                    }
                }
            }
        }

        
        self.gotoDashboard()

    }
    
   func manageLoginTextFieldProperties() {
      
      self.userNameTextfield.tintColor = ColorConstants.DARKGRAYCOLOR
      self.passwordTxtField.tintColor = ColorConstants.DARKGRAYCOLOR
      
      self.userNameTextfield.addLine(position: .LINEPOSITIONBOTTOM,
                                     color: ColorConstants.kCOLORBOTTONLINECOLOR,
                                     width: 1)
      self.passwordTxtField.addLine(position: .LINEPOSITIONBOTTOM,
                                    color: ColorConstants.kCOLORBOTTONLINECOLOR,
                                    width: 1)
      
      self.userNameTextfield.textColor = ColorConstants.DARKGRAYCOLOR
      self.passwordTxtField.textColor = ColorConstants.DARKGRAYCOLOR
      self.userNameTextfield.addTarget(self, action: #selector(LoginViewController.textFieldDidTextChange(_:)),
                                       for: .editingChanged)
      self.passwordTxtField.addTarget(self, action: #selector(LoginViewController.textFieldDidTextChange(_:)),
                                      for: .editingChanged)
   }
   
   func populateSubviews() {
      self.userNameTextfield.placeholder = NSLocalizedString("LOGIN_EMAIL_PLACEHOLDER", comment: "")
      self.passwordTxtField.placeholder = NSLocalizedString("LOGIN_PASSWORD_PLACEHOLDER", comment: "")
      self.loginBtn.setTitle(NSLocalizedString("LOGIN_BTN_TITLE", comment: ""), for: .normal)
      self.lblAccount.text = NSLocalizedString("LOGIN_SIGN_UP_ACCOUNT_TITLE", comment: "")
      self.lblSignUp.text = NSLocalizedString("LOGIN_SIGN_UP_BTN_TITLE", comment: "")
   }
   
   @objc func textFieldDidTextChange(_ textField: UITextField) {
      switch textField {
         case self.userNameTextfield:
            self.viewModal?.loginRequest.userEmail = self.userNameTextfield.text
         case self.passwordTxtField:
            self.viewModal?.loginRequest.password = self.passwordTxtField.text
         default:
            self.viewModal?.loginRequest.userEmail = "abc"
            self.viewModal?.loginRequest.password = "123"
      }
   }
}
// MARK: - LOGIN, SIGNUP & OTHER METHOD ACTION
extension LoginViewController {
   
   @IBAction func loginMethodAction(_ sender: UIButton) {
     NetworkManager.shared.checkInternetConnectivity()
     self.viewModal?.loginSubmitToServer()
   }
   
   @IBAction func signUpMethodAction(_ sender: UIButton) {
      let registrationVC: RegistrationViewController =
         (UIStoryboard.init(name: STORYBOARDCONS.ONBOARD,
                            bundle: Bundle.main).instantiateViewController(withIdentifier:
                              VCIDENTIFIER.REGISTRATIONVC) as? RegistrationViewController)!
    registrationVC.signUpUrl = self.signUpUrl
      self.navigationController?.pushViewController(registrationVC, animated: true)
   }
   
   @IBAction func managePasswordVisiblity(_ sender: UIButton) {
      sender.isSelected.toggle()
      if sender.isSelected {
         self.passwordTxtField.isSecureTextEntry = false
         //Take seperate constant for image name
         if #available(iOS 13.0, *) {
            sender.setImage(UIImage(systemName: "eye"), for: .normal)
         } else {
            // Fallback on earlier versions
            sender.setImage(UIImage(named: "eyeVisible"),for: .normal)
         }
      } else {
         self.passwordTxtField.isSecureTextEntry = true
         if #available(iOS 13.0, *) {
            sender.setImage(UIImage(systemName: "eye.slash"), for: .normal)
         } else {
            // Fallback on earlier versions
            sender.setImage(UIImage(named: "eyeHide"),for: .normal)
         }
      }
   }
    
    @IBAction func actionForgotPassword(_ sender: UIButton) {
        let forgotVC: ForgotPasswordViewController = (UIStoryboard.init(name: STORYBOARDCONS.ONBOARD,
                                                                          bundle: Bundle.main).instantiateViewController(withIdentifier:
                                                                            VCIDENTIFIER.FORGOTVC) as? ForgotPasswordViewController)!
        
        self.navigationController?.pushViewController(forgotVC, animated: true)
    }
}

// MARK: - LOGIN METHOD ACTION DELEGATES
extension LoginViewController: LoginProtocol {
   
    func manageSaveTokenDetails() {
           if !UserDefaults.standard.isKeyPresentInUserDefaults(key: "isTokenExists") {
               if UserDefaults.standard.isKeyPresentInUserDefaults(key: "login") {
                   let isLogin: Bool? = UserDefaults.standard.bool(forKey: "login")
                   if isLogin ?? false {
                       self.tokenViewModel = SaveTokenViewModal(delegate: self)
                       self.populateAndSaveDeviceToken()
                       self.callSaveTokenToServer()
               }
           }
       }
    }
    
    func populateAndSaveDeviceToken() {
        var udidDeviceStr: String = ""
        
        if let udidStr = UserDefaults.standard.value(forKey: "deviceToken") as? String {
            if !udidStr.isEmpty {
                udidDeviceStr = udidStr
            }
        }
        
        self.tokenViewModel?.saveTokenRequest.tokenId = udidDeviceStr
        self.tokenViewModel?.saveTokenRequest.type = "2"
    }

    func callSaveTokenToServer() { self.tokenViewModel?.setTokenIdForDeviceToServer() }

    
   func onLoginSuccess(response: LoginResponse) {
      DispatchQueue.main.async {
         if response.data?.message?.lowercased().trim() == "success" {
            self.view.endEditing(true)
            self.passwordTxtField.text = ""
            self.userNameTextfield.text = ""
            self.gotoDashboard()
         }
      }
      sleep(1)
      self.manageSaveTokenDetails()
}
   
   func onLoginFailure(errorMsg: String) {
      DispatchQueue.main.async {
         let alertTitle = NSLocalizedString("ALERT_ERROR_TITLE", comment: "")
         BaseViewController.showBasicAlert(message: errorMsg, title: alertTitle)
      }
   }
   
   func onValidationErrorAlert(title: String, message: String) {
      BaseViewController.showBasicAlert(message: message, title: title)
   }
}

extension LoginViewController: SaveProtocolProtocol {
    
    func onRecievedSaveTokenSuccess() {}
    func onSaveTokenFailure(errorMsg: String) {}
    func onRecievedRemoveSuccess() {}
    func onRemoveFailure(errorMsg: String) {}    
}



// MARK: Manage Login Details
extension LoginViewController {
   func manageLoginResponse(loginDetails: LoginResponse) {
      
   }
}


// MARK: CALL APP LAUNCH API
extension LoginViewController {
   
   func setUpAppLaunchService() {

    self.launchVM = LaunchViewModal(delegate: self)
      self.launchVM?.getDetailsOfAppLaunch()
   }
}

// MARK: APP LAUNCH DELEGATE METHODS
extension LoginViewController: LaunchProtocol {
   func onRecievedSuccess() {
      DispatchQueue.main.async {
         self.populateServerImages()
      }
   }
   func onFailure(errorMsg: String) {
     BaseViewController.showBasicAlert(message: errorMsg)
 }
}
