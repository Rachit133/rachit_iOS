//
//  PaymentMethodViewController.swift
//  Beer Connect
//
//  Created by Synsoft on 27/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit
import SwiftyJSON

class PaymentMethodViewController: BaseViewController {

   @IBOutlet weak var paymentMethodTableView: UITableView!
   @IBOutlet weak var btnProceed: UIButton!
    
   var arrPaymentMethods = [JSON].init()
   var arrPaymentMethodType = [PaymentMethodType].init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NetworkManager.shared.checkInternetConnectivity()
        popualatePaymentTypeFromGatway()
    }
   
   override func viewWillDisappear(_ animated: Bool) {
      self.tabBarController?.tabBar.isHidden = false
   }
   
   override func viewWillAppear(_ animated: Bool) {
      self.manageNavigationBar()
   }
}

extension PaymentMethodViewController {

    func popualatePaymentTypeFromGatway() {
        if self.arrPaymentMethods.count > 0 {
            for (_, item) in self.arrPaymentMethods.enumerated() {
                var paymentTypeObj = PaymentMethodType.init()

                var mainId = ""
                var titleName = ""
                var mainDescription = ""
                var methodTitleStr = ""
                
                if let paymentDict = item.dictionary {
                    if paymentDict.count > 0 && !paymentDict.isEmpty {
                        if let payId = paymentDict["id"]?.string {
                            if !payId.isEmpty {
                            mainId = payId
                        }
                    }
                        paymentTypeObj.id = mainId

                        if let description = paymentDict["description"]?.string {
                               if !description.isEmpty {
                                   mainDescription = description
                               }
                            }
                        paymentTypeObj.description = mainDescription

                        if let paymentTitle = paymentDict["title"]?.string {
                            if !paymentTitle.isEmpty {
                                titleName = paymentTitle
                            }
                        }
                        paymentTypeObj.title = titleName

                        if let methodTitle = paymentDict["method_title"]?.string {
                           if !methodTitle.isEmpty {
                               methodTitleStr = methodTitle
                           }
                        }
                        paymentTypeObj.methodTitle = methodTitleStr
                    }
                }
                
                self.arrPaymentMethodType.append(paymentTypeObj)
                
            }
        }
        print("paymentDict --- \(arrPaymentMethodType)")
    }
    
   func manageNavigationBar() {
    if #available(iOS 11.0, *) {
        self.paymentMethodTableView.contentInsetAdjustmentBehavior = .never
    } else {
        // Fallback on earlier versions
    }
    
      self.btnProceed.isHidden = true
      self.tabBarController?.tabBar.isHidden = true
      self.navigationController?.navigationBar.isHidden = false
      self.setNavigationLeftBarButton(viewController: self, isImage: true, imageName: "back", target: self, selector:  #selector(backMethodAction(_:)))
      self.navigationItem.title = "Payment Method"
      if #available(iOS 11.0, *) {
         self.navigationController?.navigationBar.prefersLargeTitles = true
         self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorConstants.APPBLUECOLOR,
         NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Bold", size: 34)!]
      }
   }
   
   @objc func backMethodAction(_ sender: UIButton) {
       self.navigationController?.popViewController(animated: true)
    }
}

extension PaymentMethodViewController: UITableViewDataSource, UITableViewDelegate {
   
   func tableView(_ tableView: UITableView,
                  numberOfRowsInSection section: Int) -> Int {
    return arrPaymentMethodType.count
   }
   
   func tableView(_ tableView: UITableView,
                  cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let paymentCell = tableView.dequeueReusableCell(withIdentifier:
                                                      TABLEVIEWCELLID.PAYMENTMETHODCELLID,
                                                      for: indexPath) as? PaymentMethodCell
      //paymentCell?.delegate = self
      
      paymentCell?.btnPaymentSelect.tag = indexPath.row
    
      let paymentMethodDetails = self.arrPaymentMethodType[indexPath.row]
      paymentCell?.imgPaymentBg.image = #imageLiteral(resourceName: "paymentCard")

      if let title = paymentMethodDetails.title {
        if !title.isEmpty {
            paymentCell?.lblPaymentDescription.text = title
        }
      }
        
      if let methodTitle = paymentMethodDetails.methodTitle {
          if !methodTitle.isEmpty {
            paymentCell?.lblPaymentTitle.text = methodTitle

      }
    }
        paymentCell?.btnPaymentSelect.addTarget(self,
                        action: #selector(selectPaymentMethodType(_:)),
                           for: .touchUpInside)
    
    
    
//    switch indexPath.row {
//       case 0:
//          paymentCell?.imgPaymentBg.image = #imageLiteral(resourceName: "paymentCard")
//          paymentCell?.lblPaymentTitle.text = "Cash/Check"
//          paymentCell?.lblPaymentDescription.text = "Cash or Check Due Upon Delivery"
//        case 1:
//          paymentCell?.imgPaymentBg.image = #imageLiteral(resourceName: "paymentCard1")
//          paymentCell?.lblPaymentTitle.text = "Fintech"
//          paymentCell?.lblPaymentDescription.text = "Funds will be debited via fintech. You must be Connected via fintech to select this method"
//        case 2:
//          paymentCell?.imgPaymentBg.image = #imageLiteral(resourceName: "paymentCard2")
//          paymentCell?.lblPaymentTitle.text = "iControl"
//          paymentCell?.lblPaymentDescription.text = "Funds will be debited via iControl. You must be Connected via iControl to select this method"
//
//    default:
//        break
//
//    }
      return paymentCell ?? UITableViewCell.init()
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 181.0
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    
   }
}

// MARK: Proceed Action Method
extension PaymentMethodViewController {
    
    @objc func selectPaymentMethodType(_ sender: UIButton) {
          let methodType = self.arrPaymentMethodType[sender.tag]
          let orderReviewVC: OrderReviewViewController =
             (UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD,
                                bundle: Bundle.main).instantiateViewController(withIdentifier:
                                  VCIDENTIFIER.ORDERREVIEWVCID) as? OrderReviewViewController)!
        orderReviewVC.paymentMethodType = methodType.id ?? "cod"
        orderReviewVC.paymentTypeDetails = methodType
        self.navigationController?.pushViewController(orderReviewVC, animated: true)
    }
 
   @IBAction func clickToProceedMethodAction(_ sender: UIButton) {
      
   }
}

extension PaymentMethodViewController: PaymentMethodProtocol {
    func onPaymentMethodTapped(methodType: String) {
    }

   func onFailure(errorMsg: String) {}
}


struct PaymentMethodType {

       var id: String?
       var description: String?
       var title: String?
       var methodTitle: String?

       enum CodingKeys: String, CodingKey {
          case id = "id"
          case description = "description"
          case title = "title"
          case methodTitle = "method_title"
       }
       
       var dictionary: Parameter {
          var userDict = Parameter.init()
          userDict["id"] = self.id
          userDict["description"] = self.description
          userDict["title"] = self.title
          userDict["method_title"] = self.methodTitle
          return userDict
       }
       
       init() { }
       
       init(from decoder: Decoder) throws {
          let values = try decoder.container(keyedBy: CodingKeys.self)
          id = try values.decodeIfPresent(String.self, forKey: .id)
          description = try values.decodeIfPresent(String.self, forKey: .description)
          title = try values.decodeIfPresent(String.self, forKey: .title)
          methodTitle = try values.decodeIfPresent(String.self, forKey: .methodTitle)
        }
    }

