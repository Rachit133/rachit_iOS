//
//  BaseViewController.swift
//  CVDelight_Partner
//
//  Created by Apple on 26/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import LMCSideMenu

public class BaseViewController: UIViewController {

   var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
   public var interactor: MenuTransitionInteractor = MenuTransitionInteractor()
   var sideMenuVC: UserProfileViewController?
   var blurrEffectView: UIVisualEffectView?
   var refreshControl = UIRefreshControl()
   var shippingDict = Parameter.init()

   override public func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view.
      refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
   }
}

// MARK: Show & Hide
extension BaseViewController {
   func showProgress() {
         if #available(iOS 13.0, *) {
            self.activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
         }
         self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
         self.activityIndicator.center = self.view.center
         self.activityIndicator.color = ColorConstants.COLORACTIVITYINDICATOR
         self.activityIndicator.borderColor = ColorConstants.COLORACTIVITYINDICATOR
         let blurEffect = UIBlurEffect(style: .light)
         self.blurrEffectView?.alpha = 0.1
         self.blurrEffectView = UIVisualEffectView(effect: blurEffect)
         self.blurrEffectView?.frame = self.view.bounds
              self.blurrEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         UIApplication.topViewController()?.view.addSubview(self.blurrEffectView ?? UIView.init())
         UIApplication.topViewController()?.view.addSubview(self.blurrEffectView ?? UIView.init())
         UIApplication.topViewController()?.view.addSubview(self.activityIndicator)
         UIApplication.topViewController()?.view.isUserInteractionEnabled = false
         UIApplication.topViewController()?.view.bringSubviewToFront(self.activityIndicator)
              UIApplication.shared.isNetworkActivityIndicatorVisible = true
         self.activityIndicator.startAnimating()
   }
   
   func hideProgress() {
     // DispatchQueue.main.async {
         self.activityIndicator.stopAnimating()
         self.blurrEffectView?.removeFromSuperview()
         self.activityIndicator.removeFromSuperview()
         self.view.isUserInteractionEnabled = true
      //}
   }
    
   public func isValidName(testStr:String) -> Bool {
    let RegEx = "^[A-Za-z0-9 !\"#$%&'()*+,-./:;<=>?@\\[\\\\\\]^_`{|}~].{8,}$";
    let Test = NSPredicate(format:"SELF MATCHES %@", RegEx);
    return Test.evaluate(with: testStr);
  }
    
    public func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return (emailTest.evaluate(with: testStr))
    }

   
   func getDate(_ day: Int, _ month: Int, _ year: Int) -> Date {
       let calendar = Calendar.current
       var minDateComponent = calendar.dateComponents([.day, .month, .year], from: Date())
       minDateComponent.day = day
       minDateComponent.month = month
       minDateComponent.year = year
       let minDate = calendar.date(from: minDateComponent)
       return minDate ?? Date()
   }
}

extension BaseViewController {
   
   class func showBasicAlert(message: String, title: String = "") {
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(OKAction)
      UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
   }
   
   class func showAlert(title: String,
                        message: String?,
                        buttonTitle: String!,
                        isFontApply: Bool = false,
                        action: ((UIAlertAction) -> Void)? = nil) {
      
      let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
      
      if isFontApply {
         
         let titFont = [NSAttributedString.Key.font: openSansBold18]
         let msgFont = [NSAttributedString.Key.font: openSansRegular18]
         
         let titAttrString = NSMutableAttributedString(string: title, attributes: titFont)
         let msgAttrString = NSMutableAttributedString(string: message ?? "", attributes: msgFont)
         
         alert.setValue(titAttrString, forKey: "attributedTitle")
         alert.setValue(msgAttrString, forKey: "attributedMessage")
      }
      
      let button =  UIAlertAction(title: buttonTitle, style: .default, handler: action)
      alert.addAction(button)
      UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
   }
   
   func popupAlert(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
          let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
          for (index, title) in actionTitles.enumerated() {
              let action = UIAlertAction(title: title, style: .default, handler: actions[index])
              alert.addAction(action)
          }
          self.present(alert, animated: true, completion: nil)
      }
}


extension BaseViewController {
   func makeCall(phoneNumber: String) {
      
      if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {
         
         let application: UIApplication = UIApplication.shared
         if application.canOpenURL(phoneCallURL) {
            if #available(iOS 10.0, *) {
               application.open(phoneCallURL, options: [:], completionHandler: nil)
            } else {
               // Fallback on earlier versions
               application.openURL(phoneCallURL as URL)
               
            }
         }
      }
   }
   
   func setNavigationLeftBarButton(viewController: UIViewController,
                                   isImage: Bool = false,
                                   imageName: String,
                                   target: Any,
                                   selector: Selector) {
      
      let backButton: UIButton = UIButton(type: UIButton.ButtonType.custom)
      backButton.addTarget(target, action: selector, for: .touchUpInside)
      backButton.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
      backButton.contentHorizontalAlignment = .left
      if isImage { //back-arrow
         backButton.setImage(UIImage(named: imageName), for: .normal)
      } else {
         backButton.setTitle(NSLocalizedString("Menu", comment: ""), for: .normal)
      }
      backButton.imageView?.contentMode = .center
      backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      backButton.clipsToBounds = true
      let barButtonItem: UIBarButtonItem = UIBarButtonItem(customView: backButton)
      viewController.navigationItem.leftBarButtonItem = barButtonItem
   }
   
   func setNavigationRightBarButton(viewController: UIViewController,
                                   isImage: Bool = false,
                                   isAnotherBtn: Bool = false,
                                   imageName: String,
                                   target: Any,
                                   selector: Selector) {
      
      let backButton: UIButton = UIButton(type: UIButton.ButtonType.custom)
      backButton.addTarget(target, action: selector, for: .touchUpInside)
      backButton.frame = CGRect(x: 0, y: 20.0, width: 20, height: 20)
      backButton.contentHorizontalAlignment = .left
      if isImage { //back-arrow
         backButton.setImage(UIImage(named: imageName), for: .normal)
      } else {
         backButton.setTitle(NSLocalizedString("Menu", comment: ""), for: .normal)
      }
      backButton.imageView?.contentMode = .center
      backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
      backButton.clipsToBounds = true
      let barButtonItem: UIBarButtonItem = UIBarButtonItem(customView: backButton)
      //if isHidden {
      //   backButton.isHidden = true
      //} else {
        // backButton.isHidden = false
         viewController.navigationItem.rightBarButtonItem = barButtonItem
      //}
   }
}

extension BaseViewController: LMCSideMenuCenterControllerProtocol {
   
   func setUpSideMenu() {
      MenuHelper.set(menuWidth: 1)
      MenuHelper.set(animationDuration: 0.4)
      MenuHelper.set(percentThreshold: 0.1)
       self.sideMenuVC =
       (UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD,
       bundle: Bundle.main).instantiateViewController(withIdentifier:
       VCIDENTIFIER.PROFILEVC) as? UserProfileViewController)!
       setupMenu(leftMenu: sideMenuVC, rightMenu: nil)
       enableLeftMenuGesture()
   }
   
   func showSideMenu() {
      presentLeftMenu()
   }
}

// MARK: Clear All App Data
extension BaseViewController {
   
   class func showHideRootNavigationBar(isVisible:Bool = false) {
       DispatchQueue.main.async {
           if let appDel: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
            if isVisible {
               appDel.navigationController?.isNavigationBarHidden = false
            } else {
               appDel.navigationController?.isNavigationBarHidden = true
            }
           }
       }
   }
   
   class func getAppDelegateObj() -> AppDelegate {
      if let appDel: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDel
      }
      return UIApplication.shared.delegate as! AppDelegate
   }
   
    
    func getTokenIdFromTokenDetails() -> String {
        var deviceTokenId: String = ""
        if UserDefaults.standard.isKeyPresentInUserDefaults(key: "tokenDetails") {
            let saveTokenDetails = UserDefaults.standard.retrieve(object: SaveTokenResponse.self, fromKey: "tokenDetails")
            if let tokenIdStr: String = saveTokenDetails?.data?.device_token {
                if !tokenIdStr.isEmpty && tokenIdStr.count > 0 {
                    deviceTokenId = tokenIdStr
                    return tokenIdStr
                }save
                sasalaksfnakn
            }
        }
        return deviceTokenId
    }
    
    
   func clearAllOfflineAppData() {
    
    if UserDefaults.standard.isKeyPresentInUserDefaults(key: "loginUser") {
        UserDefaults.standard.removeObject(forKey: "loginUser")
    }
    
    if UserDefaults.standard.isKeyPresentInUserDefaults(key: "ItemQuantity") {
        UserDefaults.standard.removeObject(forKey: "ItemQuantity")
    }
    
    if UserDefaults.standard.isKeyPresentInUserDefaults(key: "tokenDetails") {
        UserDefaults.standard.removeObject(forKey: "tokenDetails")
    }
  
    if UserDefaults.standard.isKeyPresentInUserDefaults(key: "cartDetails") {
        UserDefaults.standard.removeObject(forKey: "cartDetails")
    }
    
    if UserDefaults.standard.isKeyPresentInUserDefaults(key: "shippingDetails") {
        UserDefaults.standard.removeObject(forKey: "shippingDetails")
    }
    if UserDefaults.standard.isKeyPresentInUserDefaults(key: "catProductArray") {
        UserDefaults.standard.removeObject(forKey: "catProductArray")
    }
    if UserDefaults.standard.isKeyPresentInUserDefaults(key: "login") {
        UserDefaults.standard.removeObject(forKey: "login")
    }
    
    if UserDefaults.standard.isKeyPresentInUserDefaults(key: "adminSalesDetails") {
        UserDefaults.standard.removeObject(forKey: "adminSalesDetails")
    }
    
    if UserDefaults.standard.isKeyPresentInUserDefaults(key: "adminLogin") {
        UserDefaults.standard.removeObject(forKey: "adminLogin")
    }
    UserDefaults.standard.synchronize()
   }
}


extension BaseViewController {
   func getOnLaunchDetails() -> (logoUrl: String, signUpUrl: String, backImg: String){
      guard let launchDetails: LaunchResponse =  UserDefaults.standard.retrieve(object: LaunchResponse.self, fromKey: "appLaunch") else { return ("","","")}
      guard let logoUrl: String = launchDetails.data?.logoUrl else { return ("","","")}
      guard let signUpUrl: String = launchDetails.data?.signUpUrl else { return ("","","")}
      guard let backImg: String = launchDetails.data?.bgImage else { return ("","","")}
     
      var defaultLogoStr: String = logoUrl
      var defaultBackImgStr: String = backImg

      if logoUrl.isEmpty {
        defaultLogoStr = "logo"
      } else if backImg.isEmpty {
         defaultBackImgStr = "backScreen"
      }
      
      return (defaultLogoStr,signUpUrl,defaultBackImgStr)
   }
}
