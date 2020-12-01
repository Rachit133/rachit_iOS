//
//  ProfileViewController.swift
//  Beer Connect
//
//  Created by Apple on 20/04/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var showPasswordLabel: UILabel!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var passwordCheckbox: UIButton!
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var mainScrolView: UIScrollView!
    @IBOutlet weak var mainSwitch: UISwitch!
    
    var viewModel: SaveTokenViewModal?
    var isOldEmail: Bool = false
    var oldEmailStr: String = ""
    var passwordCheck = false
    var userName = String()
    var userId: String = ""
    var adminUserId: String = ""
    var showPasswordCheck = false
    var profileResponse = ProfileUserResponse.init()
    var updateProfileResponse = UpdateProfileResponse.init()
    var params = Parameter.init()
    var updateParams = Parameter.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NetworkManager.shared.checkInternetConnectivity()
        self.viewHeight.constant = 225.0
        self.initComponents()
        checkForTokenExists()
        self.manageNavigationUI()
    }
        
    @objc func switchChanged(mySwitch: UISwitch) {
        let isOn = mySwitch.isOn
        if isOn {
            
            let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
            if !isRegisteredForRemoteNotifications {
                goToSettings()
            } else {
                self.callSaveTokenToServer()
            }
            
        } else {
            print("Switch Off")
            self.callRemoveTokenToServer()
        }
    }
    
    func goToSettings () {
        let settingsButton = NSLocalizedString("SETTINGS", comment: "")
       let cancelButton = NSLocalizedString("CANCEL", comment: "")
        let message = NSLocalizedString("NOTIFICATION_PERMISSION", comment: "")
        let goToSettingsAlert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)

        goToSettingsAlert.addAction(UIAlertAction(title: settingsButton, style: .destructive, handler: { (action: UIAlertAction) in
            DispatchQueue.main.async {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    } else {
                        UIApplication.shared.openURL(settingsUrl as URL)
                    }
                }
            }
        }))

        goToSettingsAlert.addAction(UIAlertAction(title: cancelButton, style: .cancel, handler: nil))
        present(goToSettingsAlert, animated: true, completion: nil)
    }
    
    func manageNavigationUI(){
        self.navigationController?.navigationBar.isHidden = false
        if #available(iOS 11.0, *) {
            self.mainScrolView.contentInsetAdjustmentBehavior = .never
       }
        
        BaseViewController.showHideRootNavigationBar(isVisible: false)
        self.setNavigationLeftBarButton(viewController: self, isImage: true, imageName: "back", target: self, selector:  #selector(backMethodAction(_:)))
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.title = "Account"
        self.title = "Account"
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationItem.largeTitleDisplayMode = .always
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorConstants.APPBLUECOLOR,
                                                                                 NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Bold", size: 34)!]
        }
    }
    
    @objc func backMethodAction(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 0
        self.navigationController?.popViewController(animated: true)
    }
    
    func initComponents() {
        //checkForTokenExists()
        manageSaveTokenDetails()
        getDetailsFromLoginData()
        manageSwitchActionMethod()
        setUpSubViewVisibility()
        manageSubViewComponents()
        fetchProfileDetailsFromServer()
        
    }
    
    func checkForTokenExists() {
       if UserDefaults.standard.isKeyPresentInUserDefaults(key: "isTokenExists") {
            self.mainSwitch.setOn(true, animated: true)
       } else { self.mainSwitch.setOn(false, animated: true) }
    }
    
//    @objc func refreshToken() {
//        if UserDefaults.standard.isKeyPresentInUserDefaults(key: "tokenDetails") {
//            if let saveTokenDetails = UserDefaults.standard.retrieve(object:
//                SaveTokenResponse.self, fromKey: "tokenDetails") {
//                if let tokenStr: String = saveTokenDetails.data?.device_token as String? {
//                    if !tokenStr.isEmpty {
//                        self.mainSwitch.setOn(true, animated: true)
//                    } else { self.mainSwitch.setOn(false, animated: true) }
//                } else  { self.mainSwitch.setOn(false, animated: true)  }
//            } else { self.mainSwitch.setOn(false, animated: true) }
//        } else { self.mainSwitch.setOn(false, animated: true) }
//    }
    
    func manageSwitchActionMethod() {
        mainSwitch.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
    }
    
    func manageSaveTokenDetails() {
        self.viewModel = SaveTokenViewModal(delegate: self)
        self.populateAndSaveDeviceToken()
    }
    
    func getDetailsFromLoginData() {
        if UserDefaults.standard.isKeyPresentInUserDefaults(key: "loginUser") {
            if let loginDetails = UserDefaults.standard.retrieve(object:
                LoginResponse.self, fromKey: "loginUser") {
                guard let userId: String = loginDetails.data?.customer?.customerID else { return }
                self.userId = userId
            }
        }
    }
    
    func setUpSubViewVisibility() {
        oldPassword.isHidden = true
        newPassword.isHidden = true
        confirmPassword.isHidden = true
        showPasswordLabel.isHidden = true
        showPasswordButton.isHidden = true
    }
    
    func manageSubViewComponents() {
        showPasswordButton.setImage(UIImage(named: "unchecked"),
                                    for: .normal)
        passwordCheckbox.setImage(UIImage(named: "unchecked"),
                                  for: .normal)
        passwordCheckbox.addTarget(self, action: #selector(passwordClicked(_:)), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonClicked(_:)), for: .touchUpInside)
        
        showPasswordButton.addTarget(self,
                                     action: #selector(showPasswordClicked(_:)), for: .touchUpInside)
    }
    
    
    func chckForAdminLogin() -> Bool {
        var isSalesPersonExists: Bool = false
        if UserDefaults.standard.isKeyPresentInUserDefaults(key: "adminSalesDetails") {
          if let adminSalesDetails = UserDefaults.standard.retrieve(object: LoginResponse.self, fromKey: "adminSalesDetails") {
             if let adminFlag: Bool = adminSalesDetails.data?.customer?.salePerson {
                if adminFlag {
                    if let adminId = adminSalesDetails.data?.customer?.customerID {
                        if !adminId.isEmpty && adminId != "" {
                            isSalesPersonExists = true
                            self.adminUserId = adminId
                        }
                    }
                }
             }
          }
        }
        return isSalesPersonExists
    }
    
    func fetchProfileDetailsFromServer() {
       
        let isAdminPresent: Bool = chckForAdminLogin()
        
        if isAdminPresent {
            params["user-id"] = self.adminUserId

        } else {
            params["user-id"] = self.userId
        }
        NetworkManager.shared.makeRequestToServer(for: FETCHUSERPROFILE,
                                                  method: .POST,
                                                  params: params,
                                                  headers: nil,
                                                  isActivityShow: true,
                                                  completionSuccess:
            { (fetchProfileData) in
                
                if fetchProfileData != nil {
                    self.profileResponse = self.profileResponse.getUserProfileFrom(repsonseData: fetchProfileData ?? Data.init()) ?? ProfileUserResponse.init()
                    
                    if let statusStr = self.profileResponse.userProfileData?.status {
                        if !statusStr.isEmpty {
                            
                            if statusStr.lowercased().trim() == "success" {
                                DispatchQueue.main.async {
                                    self.manageUserProfileResponse()
                                }
                            } else {
                                DispatchQueue.main.async {
                                    let beerError = ErrorManager.init(errorCode: 0,
                                                                      message: "An unexpected error occured, please try again later.")
                                    self.view.makeToast(beerError.msg,
                                                        duration: 1.5,
                                                        position: .bottom)
                                    return
                                }
                            }
                            
                        } else {
                            DispatchQueue.main.async {
                                
                                let beerError = ErrorManager.init(errorCode: 0, message: "An unexpected error occured, please try again later.")
                                self.view.makeToast(beerError.msg,
                                                    duration: 1.5,
                                                    position: .bottom)
                                return
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        
                        let beerError = ErrorManager.init(errorCode: 0, message: "An unexpected error occured, please try again later.")
                        self.view.makeToast(beerError.msg,
                                            duration: 1.5,
                                            position: .bottom)
                        return
                        
                    }
                }
                
        }) { (errorObj) in
            DispatchQueue.main.async {
                
                self.view.makeToast(errorObj.msg,
                                    duration: 1.5,
                                    position: .bottom)
                return
            }
        }
    }
    
    func manageUserProfileResponse() {
        
        if let emailStr = self.profileResponse.userProfileData?.customer?.email {
            self.firstName.isHidden = false
            self.email.isHidden = false
            self.lastName.isHidden = false

            if !emailStr.isEmpty {
                self.email.text = emailStr
                //oldEmailStr = emailStr
            } else { self.email.text = "" }
            
        } else { self.email.text = "" }
        
        if let firstNameStr = self.profileResponse.userProfileData?.customer?.first_name {
            if !firstNameStr.isEmpty { self.firstName.text = firstNameStr
            } else { self.firstName.text = "" }
        } else { self.firstName.text = "" }
        
        if let lastNameStr = self.profileResponse.userProfileData?.customer?.last_name {
            if !lastNameStr.isEmpty {
                self.lastName.text = lastNameStr
            } else { self.lastName.text = "" }
        } else { self.lastName.text = "" }
        
        if let userNameStr = self.profileResponse.userProfileData?.customer?.user_name {
            if !userNameStr.isEmpty {
                self.userName = userNameStr
            } else { self.userName = "" }
        } else { self.userName = "" }
    }
}


extension ProfileViewController {
    
    @objc func passwordClicked(_ sender: UIButton) {
        if passwordCheck == false  {
            passwordCheck = true
            sender.setImage(UIImage(named: "checked"), for: .normal)
            viewHeight.constant += 220
            oldPassword.isHidden = false
            newPassword.isHidden = false
            confirmPassword.isHidden = false
            showPasswordLabel.isHidden = false
            showPasswordButton.isHidden = false
            self.mainScrolView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: viewHeight.constant + 150.0)
        } else if(passwordCheck == true) {
            passwordCheck=false
            sender.setImage(UIImage(named: "unchecked"), for: .normal)
            viewHeight.constant -= 220
            self.mainScrolView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: viewHeight.constant - 100.0)
            oldPassword.isHidden=true
            newPassword.isHidden=true
            confirmPassword.isHidden=true
            showPasswordLabel.isHidden=true
            showPasswordButton.isHidden=true
        }
    }
    
    @objc func showPasswordClicked(_ sender: UIButton) {
        showPasswordCheck = !showPasswordCheck;
        if showPasswordCheck {
            oldPassword.isSecureTextEntry = false;
            newPassword.isSecureTextEntry = false;
            confirmPassword.isSecureTextEntry = false;
            sender.setImage(UIImage(named: "checked"), for: .normal)
        } else {
            oldPassword.isSecureTextEntry = true;
            newPassword.isSecureTextEntry = true;
            confirmPassword.isSecureTextEntry = true;
            sender.setImage(UIImage(named: "unchecked"), for: .normal)
        }
    }
    
    @objc func saveButtonClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let emailText = email.text?.trimmingCharacters(in: .whitespaces)
        let firstNameText = firstName.text?.trimmingCharacters(in: .whitespaces)
        let lastNameText = lastName.text?.trimmingCharacters(in: .whitespaces)
        let oldPasswordText = oldPassword.text?.trimmingCharacters(in: .whitespaces)
        let newPasswordText = newPassword.text?.trimmingCharacters(in: .whitespaces)
        let confirmPasswordText = confirmPassword.text?.trimmingCharacters(in: .whitespaces)
        
        let isAdminPresent: Bool = chckForAdminLogin()
        
        if isAdminPresent {
            updateParams["user-id"] = self.adminUserId
        } else {
            updateParams["user-id"] = self.userId
        }
        if firstNameText == "" || lastNameText == "" || emailText == "" {
            self.view.makeToast(NSLocalizedString("ALL_REQUIRED",
                                                  comment: ""),
                                duration: 1.0,
                                position: .bottom)
            
            return
        }
        
//        if !isValidName(testStr: firstNameText ?? "") {
//            self.view.makeToast(NSLocalizedString("FIRST_NAME_FIELD",
//                                                  comment: ""),
//                                duration: 1.0,
//                                position: .bottom)
//            return
//        }
//
//        if !isValidName(testStr: lastNameText ?? "") {
//            self.view.makeToast(NSLocalizedString("LAST_NAME_FIELD",
//                                                  comment: ""),
//                                duration: 1.0,
//                                position: .bottom)
//            return
//        }
        
        if !isValidEmail(testStr: emailText ?? "") {
            self.view.makeToast(NSLocalizedString("EMAIL_FIELD",
                                                  comment: ""),
                                duration: 1.0,
                                position: .bottom)
            return
        }
        
//        if self.oldEmailStr.lowercased().trim() == emailText?.lowercased().trim() {
//          self.view.makeToast(NSLocalizedString("SAME_EMAIL_FIELD",
//                            comment: ""),
//          duration: 1.0,
//          position: .bottom)
//          return
//        }
//        
        updateParams["firstname"]=firstNameText ?? ""
        updateParams["lastname"]=lastNameText ?? ""
        updateParams["email"]=emailText ?? ""
        
        if passwordCheck == true {
            if oldPasswordText == ""
                || newPasswordText == ""
                || confirmPasswordText == "" {
                self.view.makeToast(NSLocalizedString("ALL_REQUIRED",
                                                      comment: ""),
                                    duration: 1.0,
                                    position: .bottom)
                return
            }
            
            if newPasswordText != confirmPasswordText {
                self.view.makeToast(NSLocalizedString("PASS_VERIFY",
                                                      comment: ""),
                                    duration: 1.0,
                                    position: .bottom)
                
                return
            }
            
            updateParams["user_name"] = userName
            updateParams["oldpassword"] = oldPasswordText ?? ""
            updateParams["new_password"] = newPasswordText ?? ""
            updateParams["confirm_password"] = confirmPasswordText ?? ""
        }
        self.updateProfileDetailsAndSaveToServer()
    }
    
    func updateProfileDetailsAndSaveToServer() {
        NetworkManager.shared.makeRequestToServer(for: UPDATEPROFILE,
                                                  method: .POST,
                                                  params: updateParams,
                                                  headers: nil,
                                                  isActivityShow: true,
                                                  completionSuccess:
            { (updateProfileData) in
                
                if updateProfileData != nil {
                    self.updateProfileResponse = self.updateProfileResponse.getSaveUserProfileData(repsonseData: updateProfileData ?? Data.init()) ?? UpdateProfileResponse.init()
                    
                    if let statusStr = self.updateProfileResponse.updateData?.customer?.status {
                        if !statusStr.isEmpty {
                            
                            if statusStr.lowercased().trim() == "success" {
                                DispatchQueue.main.async {
                                    if let statusMsg = self.updateProfileResponse.updateData?.customer?.message {
                                        
                                        if !statusMsg.isEmpty {
                                            self.view.makeToast(NSLocalizedString(statusMsg ,
                                                                                  comment: ""),
                                                                duration: 1.5,
                                                                position: .bottom)
                                        }
                                        
                                        
                                        if self.passwordCheck {
                                            
                                            self.viewHeight.constant -= 220.0
                                            self.mainScrolView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: self.viewHeight.constant - 30.0)
                                            self.passwordCheck = false
                                            
                                            self.oldPassword.text = ""
                                            self.newPassword.text = ""
                                            self.confirmPassword.text = ""
                                            
                                            self.updateParams.removeValue(forKey: "oldpassword")
                                            self.updateParams.removeValue(forKey: "new_password")
                                            self.updateParams.removeValue(forKey: "confirm_password")
                                            
                                            self.setUpSubViewVisibility()
                                            self.manageSubViewComponents()
                                        }
                                    }
                                }
                            } else {
                                DispatchQueue.main.async {
                                    
                                    if let failureMsg =  self.updateProfileResponse.updateData?.customer?.message {
                                        let beerError = ErrorManager.init(errorCode: 0,
                                                                          message: failureMsg )
                                        self.view.makeToast(beerError.msg,
                                                            duration: 1.5,
                                                            position: .bottom)
                                        return
                                    }
                                    
                                }
                            }
                            
                        } else {
                            DispatchQueue.main.async {
                                let beerError = ErrorManager.init(errorCode: 0,
                                                                  message: "An unexpected error occured, please try again later.")
                                self.view.makeToast(beerError.msg,
                                                    duration: 1.5,
                                                    position: .bottom)
                                return
                            }
                        }
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        let beerError = ErrorManager.init(errorCode: 0,
                                                          message: "An unexpected error occured, please try again later.")
                        self.view.makeToast(beerError.msg,
                                            duration: 1.5,
                                            position: .bottom)
                        return
                        
                    }
                }
                
        }) { (errorObj) in
            DispatchQueue.main.async {
                
                self.view.makeToast(errorObj.msg,
                                    duration: 1.5,
                                    position: .bottom)
                return
            }
        }
    }
}

extension ProfileViewController: SaveProtocolProtocol {
    func onRecievedSaveTokenSuccess() {
        DispatchQueue.main.async {
            self.view.makeToast(NSLocalizedString("ENABLE_NOTIFICATION",
                                                  comment: ""),duration: 2.0,
                                                position: .bottom)
        }
    }
    
    func onSaveTokenFailure(errorMsg: String) {
        DispatchQueue.main.async {
                   self.view.makeToast(errorMsg,
                                       duration: 2.0,
                                       position: .bottom)
               }
    }
    
    func onRecievedRemoveSuccess() {
        DispatchQueue.main.async {
            self.view.makeToast(NSLocalizedString("DISABLE_NOTIFICATION",comment: ""),
                                duration: 2.0,
                                position: .bottom)
            
        }
        
    }
    
    func onRemoveFailure(errorMsg: String) {
        DispatchQueue.main.async {
            self.view.makeToast(errorMsg,
                                duration: 2.0,
                                position: .bottom)
        }
        
    }
    
    
    func populateAndSaveDeviceToken() {
        var udidDeviceStr: String = ""
//
        if let udidStr = UserDefaults.standard.value(forKey: "deviceToken") as? String {
            if !udidStr.isEmpty {
                udidDeviceStr = udidStr
            } else {}
        } else {}
        self.viewModel?.saveTokenRequest.tokenId = udidDeviceStr
        self.viewModel?.saveTokenRequest.type = "2" // 2 for iOS
    }
    
    func populateAndRemoveDeviceToken() {
        if UserDefaults.standard.isKeyPresentInUserDefaults(key: "tokenDetails") {
            if let saveTokenDetails = UserDefaults.standard.retrieve(object:
                SaveTokenResponse.self, fromKey: "tokenDetails") {
                if let tokenStr: String = saveTokenDetails.data?.device_token! {
                    if !tokenStr.isEmpty {
                        self.viewModel?.removeTokenRequest.tokenId = tokenStr
                    } else {
                        var tokenString: String = ""
                        if UserDefaults.standard.value(forKey: "deviceToken") != nil {
                            tokenString = UserDefaults.standard.value(forKey: "deviceToken") as? String ?? ""
                            self.viewModel?.removeTokenRequest.tokenId = tokenString
                        }
                    }
                }
            } else {
                 var tokenString: String = ""
                   if UserDefaults.standard.value(forKey: "deviceToken") != nil {
                       tokenString = UserDefaults.standard.value(forKey: "deviceToken") as? String ?? ""
                       self.viewModel?.removeTokenRequest.tokenId = tokenString
                   }
            }
        } else {
             var tokenString: String = ""
               if UserDefaults.standard.value(forKey: "deviceToken") != nil {
                   tokenString = UserDefaults.standard.value(forKey: "deviceToken") as? String ?? ""
                   self.viewModel?.removeTokenRequest.tokenId = tokenString
               }
        }
        self.viewModel?.removeTokenRequest.type = "2"
    }
    
    func callSaveTokenToServer() {
        self.populateAndSaveDeviceToken()
        self.viewModel?.setTokenIdForDeviceToServer()
    }
    
    func callRemoveTokenToServer() {
        self.populateAndRemoveDeviceToken()
        self.viewModel?.removeTokenDeviceFromServer()
    }
}


extension ProfileViewController: UITextViewDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        if textField == self.firstName || textField == self.lastName {
            guard range.location == 0 else {return true}
            let newString = (textField.text!.trim() as NSString).replacingCharacters(in: range, with: string) as NSString
                return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
        } else { return true }
    }
}
