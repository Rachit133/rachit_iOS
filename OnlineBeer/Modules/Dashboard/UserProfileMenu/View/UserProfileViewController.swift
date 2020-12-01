//
//  DashboardViewController.swift
//  Beer Connect
//
//  Created by Synsoft on 28/01/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import Foundation
import SDWebImage

enum MenuItem: String {
    case profile
    case search
    case cart
    case wishlist
    case orderHistory
    case account
    case notification
    case home
}

import UIKit

class UserProfileViewController: BaseViewController {
    
    @IBOutlet weak var backProfileImg: UIImageView!
    @IBOutlet weak var profileBtn: UIButton!
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var lblUsername: UILabel!
    
    var arrMenuOption = [UserProfile].init()
    weak var delegate: UserProfileProtocol?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var userName: String = ""
    var isSalesPersonExists: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initComponents()
    }
    
    func getLoginDetails() -> String {
        var emailId: String = ""
        if let loginDetails = UserDefaults.standard.retrieve(object: LoginResponse.self,
                                                             fromKey: "loginUser") {
            if let customerName: String = loginDetails.data?.customer?.customerName {
                emailId = customerName
            }
        }
        return emailId
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.userName = self.getLoginDetails()
        self.populateServerImages()
    }
    override func viewDidAppear(_ animated: Bool) {
        // self.setTableViewHeightForContent()
    }
    
    func chckForAdminLogin() -> Bool {
        if UserDefaults.standard.isKeyPresentInUserDefaults(key: "adminSalesDetails") {
          if let adminSalesDetails = UserDefaults.standard.retrieve(object: LoginResponse.self, fromKey: "adminSalesDetails") {
             if let adminFlag: Bool = adminSalesDetails.data?.customer?.salePerson {
                if adminFlag {
                    if let salesPersonName = adminSalesDetails.data?.customer?.customerName {
                        if !salesPersonName.isEmpty {
                            userName = salesPersonName
                        }
                    }

                    if let adminId = adminSalesDetails.data?.customer?.customerID {
                        if !adminId.isEmpty && adminId != "" {
                            isSalesPersonExists = true
                        }
                    }
                }
             }
          }
        }
        return isSalesPersonExists
    }
    
    func populateServerImages() {
        let onLaunchDetails = self.getOnLaunchDetails()
        //let isAdminPresent: Bool = chckForAdminLogin()

        //if isAdminPresent {
        //    self.lblUsername.text = self.userName
        //} else {
            self.lblUsername.text = self.userName
        //}
        
        self.backProfileImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        self.backProfileImg.sd_setImage(with: URL(string: onLaunchDetails.backImg), placeholderImage: UIImage(named: "profileBackImg"), options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, url) in
            if error != nil {
                self.backProfileImg.contentMode = .scaleAspectFill
                self.backProfileImg.image = UIImage(named: "profileBackImg")
            } else {
                self.backProfileImg.contentMode = .scaleAspectFill
                self.backProfileImg.image = image
            }
        })
    }
    
    @IBAction func logOutActioMethod(_ sender: UIButton) {
        NetworkManager.shared.checkInternetConnectivity()
        self.popupAlert(title: "Logout", message: NSLocalizedString("LOGOUT", comment: ""), actionTitles: ["Cancel", "OK"],
                        actions:[{action1 in },
                                 { action2 in
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                                        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                                            
                                            UserDefaults.standard.removeObject(forKey: "deviceToken")
                                            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                                            self.removeSaveTokenOnLogOut()
                                            self.clearAllOfflineAppData()
                                            self.dismiss(animated: true, completion: nil)
                                            
                                            self.delegate?.onMenuOptionClick(tabBarName: "logout", tabIndex: 11111)
                                        }, completion: nil)
                                    }
                                    
                                    
                            }])
    }
    
}

extension UserProfileViewController {
    func removeSaveTokenOnLogOut() {
        if UserDefaults.standard.isKeyPresentInUserDefaults(key: "isTokenExists") {
            let viewModel = SaveTokenViewModal.init(delegate: self)
            if let saveTokenDetails = UserDefaults.standard.retrieve(object:
                SaveTokenResponse.self, fromKey: "tokenDetails") {
                if let tokenStr: String = saveTokenDetails.data?.device_token! {
                    if !tokenStr.isEmpty {
                        viewModel.removeTokenRequest.tokenId = tokenStr
                        viewModel.removeTokenRequest.type = "2"
                        viewModel.removeTokenDeviceFromServer()
                    }
                }
            }
            
        }
        
    }
}

extension UserProfileViewController {
    
    func initComponents() {
        populateProfileMenuOptions()
    }
    
    func populateProfileMenuOptions() {
        let profileOption1 = UserProfile.init(name: "Profile", imageName: "userSelected")
        let profileOption2 = UserProfile.init(name: "Notifications", imageName: "notifiIcon")
        //  let profileOption3 = UserProfile.init(name: "Settings", imageName: "settingIcon")
        let profileOption4 = UserProfile.init(name: "Order History", imageName: "orderHistoryIcon")
        let profileOption5 = UserProfile.init(name: "Wishlist", imageName: "WishIcon")
        let profileOption6 = UserProfile.init(name: "Search", imageName: "searchIcon")
        let profileOption7 = UserProfile.init(name: "Cart", imageName: "cartIcon")
        let profileOption8 = UserProfile.init(name: "Home", imageName: "homeIcon")
        
        self.arrMenuOption.append(profileOption1)
        self.arrMenuOption.append(profileOption2)
        
        //self.arrMenuOption.append(profileOption3)
        self.arrMenuOption.append(profileOption4)
        self.arrMenuOption.append(profileOption5)
        self.arrMenuOption.append(profileOption6)
        self.arrMenuOption.append(profileOption7)
        self.arrMenuOption.append(profileOption8)
        
    }
}

extension UserProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return arrMenuOption.count
    }
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileCell = tableView.dequeueReusableCell(withIdentifier:
            TABLEVIEWCELLID.PROFILEOPTIONCELLID,
                                                        for: indexPath) as? ProfileOptionCell
        profileCell?.selectionStyle = .none
        
        let profileDetails = self.arrMenuOption[indexPath.row]
        profileCell?.lblTitle.text = profileDetails.name
        profileCell?.imgTitle.image = UIImage(named: profileDetails.imageName ?? "usericon")
        return profileCell ?? UITableViewCell.init()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            //if indexPath.row == 2 {
            //BaseViewController.showBasicAlert(message: "Under development")
            //  return
            //}
            
            self.dismiss(animated: true, completion: nil)
            let profileDetails = self.arrMenuOption[indexPath.row]
            self.ManageSideMenuWithTabBarItems(menuItemName: profileDetails.name?.lowercased().trim() ?? "home")
            //self.delegate?.onMenuOptionClick(menu: MenuItem(rawValue: menuName) ?? .Home)
        }
    }
}


extension UserProfileViewController {
    
    func ManageSideMenuWithTabBarItems(menuItemName: String) {
        switch menuItemName {
        case "profile":
            self.delegate?.onMenuOptionClick(tabBarName: menuItemName, tabIndex: 4)
        case "search":
            self.delegate?.onMenuOptionClick(tabBarName: menuItemName, tabIndex: 1)
        case "cart":
            self.delegate?.onMenuOptionClick(tabBarName: menuItemName, tabIndex: 2)
        case "wishlist":
            self.delegate?.onMenuOptionClick(tabBarName: menuItemName, tabIndex: 3)
        case "account":
            self.delegate?.onMenuOptionClick(tabBarName: menuItemName, tabIndex: 567)
        case "order history":
            self.delegate?.onMenuOptionClick(tabBarName: menuItemName, tabIndex: 111)
            //self.present(orderListVC, animated: true, completion: nil)
            break
        case "notification":
            self.delegate?.onMenuOptionClick(tabBarName: menuItemName, tabIndex: 222)
            
            break
        case "home":
            self.delegate?.onMenuOptionClick(tabBarName: menuItemName, tabIndex: 0000)
            
            break
        default:
            self.delegate?.onMenuOptionClick(tabBarName: menuItemName, tabIndex: 0)
        }
    }
    
}

extension UserProfileViewController: SaveProtocolProtocol {
    func onRecievedSaveTokenSuccess() {}
    
    func onSaveTokenFailure(errorMsg: String) {}
    
    func onRecievedRemoveSuccess() {
        DispatchQueue.main.async {
            self.view.makeToast(NSLocalizedString("DISABLE_NOTIFICATION",comment: ""),
                                duration: 2.0,
                                position: .bottom)
            
        }}
    
    func onRemoveFailure(errorMsg: String) {
        DispatchQueue.main.async {
            self.view.makeToast(errorMsg,
                                duration: 2.0,
                                position: .bottom)
        }
        
    }
}
