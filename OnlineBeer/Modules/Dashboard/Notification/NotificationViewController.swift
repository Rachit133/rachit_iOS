//
//  NotificationViewController.swift
//  Beer Connect
//
//  Created by Synsoft on 23/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit
import SDWebImage

class NotificationViewController: BaseViewController {
    
    @IBOutlet weak var tblNotitifications: UITableView!
    @IBOutlet weak var imgEmptyWishlist: UIImageView!
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var notificationResponse: NotificationResponse?
    var arrNotifications = [NotificationData].init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.checkInternetConnectivity()
        self.tblNotitifications.dataSource = self
        self.tblNotitifications.delegate = self

        // Set automatic dimensions for row height
        self.tblNotitifications.rowHeight = UITableView.automaticDimension
        self.tblNotitifications.estimatedRowHeight = UITableView.automaticDimension
        
        initComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manageNavigationUI()
    }
}

extension NotificationViewController {
    func initComponents() {
        managePullToRefresh()
        fetchNotifications()
    }
    
    func managePullToRefresh() {
        self.refreshControl.addTarget(self,
                                      action: #selector(refreshNotificationList),
                                      for: UIControl.Event.valueChanged)
        self.tblNotitifications.addSubview(refreshControl)
    }
    
    @objc func refreshNotificationList() {
        fetchNotifications()
    }
}

extension NotificationViewController {
    
    func manageNavigationUI(){
       self.navigationController?.navigationBar.isHidden = false
       if #available(iOS 11.0, *) {
             self.tblNotitifications.contentInsetAdjustmentBehavior = .never
         } else {
         }
       BaseViewController.showHideRootNavigationBar(isVisible: false)
       self.setNavigationLeftBarButton(viewController: self, isImage: true, imageName: "back", target: self, selector:  #selector(backMethodAction(_:)))
       self.tabBarController?.tabBar.isHidden = false
       self.title = "Notifications"
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
    
    func fetchNotifications() {
        
        NetworkManager.shared.makeRequestToServer(for: GETNOTIFICATION,
                                                  method: .GET,
                                                  isActivityShow: true,
                                                  completionSuccess: { (notificationData) in
            DispatchQueue.main.async {
                self.notificationResponse = NotificationResponse.init()
                if notificationData != nil {
                    self.notificationResponse = self.notificationResponse?.getNotifcationDetails(repsonseData: notificationData ?? Data.init()) ?? NotificationResponse.init()
                    if self.notificationResponse != nil {
                        if let arrOfNotification = self.notificationResponse?.data {
                            if arrOfNotification.count > 0 {
                                self.arrNotifications = arrOfNotification
                                self.refreshControl.endRefreshing()
                                self.tblNotitifications.isHidden = false
                                self.imgEmptyWishlist.isHidden = true
                                self.tblNotitifications.reloadData()
                            } else {
                                self.refreshControl.endRefreshing()
                                self.tblNotitifications.isHidden = true
                                self.imgEmptyWishlist.isHidden = false
                                self.view.makeToast("Notications not available", duration: 1.0, position: .bottom)
                            }
                        }
                    } else {
                        self.view.makeToast("Notications not available",
                                            duration: 1.0,
                                            position: .bottom)
                    } } else {
                    self.view.makeToast("Notications not available",
                                        duration: 1.0,
                                        position: .bottom)
                }

            }
        }) { (errorObj) in
            DispatchQueue.main.async {
                self.view.makeToast(errorObj.msg, duration: 1.0, position: .bottom)
            }
        }
    }
}

// MARK: TABLEVIEW DELEGATE & DATASOURCE METHODS
extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let notificationlistCell = tableView.dequeueReusableCell(withIdentifier:
            TABLEVIEWCELLID.NOTIFICATIONCELLID,
            for: indexPath) as? NotificationCell else { return UITableViewCell.init() }
        
        notificationlistCell.layer.cornerRadius = 8
        notificationlistCell.layer.masksToBounds =  true
        notificationlistCell.layer.applySketchShadow(color: UIColor.black8, alpha: 1.0, x: 0, y: 4, blur: 23.0, spread: 0)
        
        let notificationDetails = self.arrNotifications[indexPath.row]
        
        if let notificationTitleName = notificationDetails.title {
            if !notificationTitleName.isEmpty {
                notificationlistCell.lblNotificationTitle.text = notificationTitleName
            }
        }
        
        if let notificationMessage = notificationDetails.message {
            if !notificationMessage.isEmpty {
                notificationlistCell.lblNotificationDesctions.text = notificationMessage
            }
        }

        if let notificationImage = notificationDetails.image {
            notificationlistCell.imgNotifications.sd_imageIndicator = SDWebImageActivityIndicator.gray
            notificationlistCell.imgNotifications.sd_setImage(with: URL(string: notificationImage), placeholderImage: UIImage(named: "catDefault"))
        } else {
            notificationlistCell.imgNotifications.image = UIImage(named: "catDefault")
        }
        
        return notificationlistCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension NotificationViewController {
    func navigateToProductDetailScreen(productDetails: Product) {
        let productDetailVC: ProductDetailViewController =
            (UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD,
                               bundle: Bundle.main).instantiateViewController(withIdentifier:
                                VCIDENTIFIER.PRODUCTDETAILVC) as? ProductDetailViewController)!
        productDetailVC.productDetail = productDetails
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }
}

