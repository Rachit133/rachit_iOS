//
//  OrderListViewController.swift
//  Beer Connect
//
//  Created by Synsoft on 17/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit

class OrderListViewController: BaseViewController {
   
   @IBOutlet weak var btnFromDate: UIButton!
   @IBOutlet weak var btnToDate: UIButton!
   @IBOutlet weak var lblFromDate: UILabel!
   @IBOutlet weak var lblToDate: UILabel!
   @IBOutlet weak var segmentControl: UISegmentedControl!
   @IBOutlet weak var orderListTableView: UITableView!
   @IBOutlet weak var imgEmptyCart: UIImageView!
   @IBOutlet weak var backViewDatePicker: UIView!
   @IBOutlet weak var datePicker: UIDatePicker! {
      didSet {
         datePicker.backgroundColor = .white
         self.datePicker.maximumDate = Date()
      }
   }
   
   @IBOutlet weak var btnCancel: UIButton!
   @IBOutlet weak var btnDone: UIButton!
   
   var viewModel: OrderListViewModel?
   let appDelegate = UIApplication.shared.delegate as! AppDelegate
   var isPickerShow: Bool = false
   var isComingFrom: Bool = false
   var userId: String = ""
   var selectedDate: String = ""
   var isLoading = false
   var fromDateStr = ""
   var toDateStr = ""
    
   override func viewDidLoad() {
      super.viewDidLoad()
      NetworkManager.shared.checkInternetConnectivity()
      initComponents()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      self.manageNavigationUI()
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      appDelegate.navigationController?.navigationBar.isHidden = true
   }
   
   func manageDatePicker() {
      self.datePicker.maximumDate = Date()//self.getDate(01, 01, 1900)
      self.datePicker.date = Date()
      self.isPickerShow = false
      self.showHideDatePicker(isShow: self.isPickerShow)
   }
   
   func manageSegmentControlUI() {
      self.segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.salmon], for: .selected)
      self.segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkBlueGrey], for: .normal)
      self.segmentControl.tintColor = UIColor.lightPeriwinkle
      let font: [AnyHashable : Any] = [NSAttributedString.Key.font : openSansRegular16]
      self.segmentControl.setTitleTextAttributes(font as? [NSAttributedString.Key : Any], for: .normal)
      segmentControl.layer.borderWidth = 0.8
      segmentControl.layer.cornerRadius = 8.0
      segmentControl.layer.borderColor = UIColor.lightPeriwinkle.cgColor
      self.segmentControl.layer.masksToBounds =  false
      self.segmentControl.layer.applySketchShadow(color: UIColor.lightGray, alpha: 0.4, x: 0, y: 4, blur: 4, spread: 0)
      self.segmentControl.addTarget(self, action: #selector(orderStatusMethodAction), for: .valueChanged)
   }
   
   func selectFirstSegment() {
      self.segmentControl.selectedSegmentIndex = 0
      self.orderStatusMethodAction(segControl: self.segmentControl)
   }

    
   @IBAction func fromDateMethodAction(sender: UIButton) {
         self.datePicker.minimumDate = nil
         let formatter = DateFormatter()
         formatter.dateFormat = "MM/dd/yyyy"
        if let selectDate = formatter.date(from: btnFromDate.titleLabel?.text ?? "") {
            self.datePicker.date = selectDate
        }
      
      if self.isPickerShow == false {
         self.isPickerShow = true
         self.isComingFrom = true
        // self.datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
         self.showHideDatePicker(isShow: self.isPickerShow)
      } else {
         self.isPickerShow = false
         self.showHideDatePicker(isShow: self.isPickerShow)
      }
   }
   
   @IBAction func toDateMethodAction(sender: UIButton) {
    
     if btnFromDate.titleLabel?.text == "" ||  btnFromDate.titleLabel?.text == " " {
        BaseViewController.showAlert(title: NSLocalizedString("ALERT", comment: ""), message: NSLocalizedString("FROM_DATE_FIRST", comment: ""), buttonTitle: NSLocalizedString("OK", comment: ""))
        return;
     }
    
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        // convert your string to date
        if let minDate = formatter.date(from: btnFromDate.titleLabel?.text ?? "") {
            self.datePicker.minimumDate = minDate
        }
        if let selectDate = formatter.date(from: btnToDate.titleLabel?.text ?? "") {
            self.datePicker.date = selectDate
        }
    
        if self.isPickerShow == false {
            self.isPickerShow = true
            isComingFrom = false
            self.showHideDatePicker(isShow: self.isPickerShow)
        } else {
            self.isPickerShow = false
            self.showHideDatePicker(isShow: self.isPickerShow)
        }
   }
   
   @IBAction func orderStatusMethodAction(segControl: UISegmentedControl) {
      self.segmentControl.tintColor = UIColor.lightPeriwinkle50
      self.segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkBlueGreyTwo], for: .normal)
      self.segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkBlueGreyTwo], for: .normal)
     self.imgEmptyCart.isHidden = true
      switch  segControl.selectedSegmentIndex {
         case 0:
            self.viewModel?.orderListRequest.status = ""
            break
         case 1:
            self.viewModel?.orderListRequest.status = "processing"
            self.viewModel?.orderListRequest.currentPage = "1"
            break
         case 2:
            self.viewModel?.orderListRequest.status = "completed"
            self.viewModel?.orderListRequest.currentPage = "1"
            break
         default:
            self.viewModel?.orderListRequest.status = ""
            self.viewModel?.orderListRequest.currentPage = "1"
            break
      }
      self.getProductList()
   }
}

// MARK: INIT COMPONENTS & OTHER OPERATIONS
extension OrderListViewController {
   
   func initComponents() {
      initializeViewModel()
      manageDatePicker()
      manageSegmentControlUI()
      selectFirstSegment()
      managePullToRefresh()
    }
   
   func managePullToRefresh() {
       self.refreshControl.addTarget(self,
                                     action: #selector(refresh),
                                     for: UIControl.Event.valueChanged)
       self.orderListTableView.addSubview(refreshControl)
   }
    
   @objc func refresh(sender:AnyObject?) {
    self.viewModel?.orderListRequest.currentPage = "1"
    self.getProductList()
  }
    
   func initializeViewModel() {
      self.orderListTableView.isHidden = true
      self.viewModel = OrderListViewModel(delegate: self)
      self.viewModel?.orderListRequest.currentPage = "1"
    }
   
   func getProductList() {
      if UserDefaults.standard.isKeyPresentInUserDefaults(key: "loginUser") {
        guard let loginDetails =  UserDefaults.standard.retrieve(object:
            LoginResponse.self, fromKey: "loginUser") else { return }
         guard let userId: String = loginDetails.data?.customer?.customerID else { return }
         if (!userId.isEmpty) && (userId != "") {
            self.userId = userId
         }
         self.viewModel?.orderListRequest.userId = userId
         self.viewModel?.getOrderListProductFromServer()
        self.imgEmptyCart.isHidden = true
      }
   }
    
   func manageNavigationUI(){
      self.navigationController?.navigationBar.isHidden = false
      if #available(iOS 11.0, *) {
            self.orderListTableView.contentInsetAdjustmentBehavior = .never
        } else {
        }
      BaseViewController.showHideRootNavigationBar(isVisible: false)
      self.setNavigationLeftBarButton(viewController: self, isImage: true, imageName: "back", target: self, selector:  #selector(backMethodAction(_:)))
      self.title = "Order History"
      if #available(iOS 11.0, *) {
         self.navigationController?.navigationBar.prefersLargeTitles = true
         self.navigationController?.navigationItem.largeTitleDisplayMode = .always
         self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorConstants.APPBLUECOLOR,
         NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Bold", size: 34)!]
      }
   }
   
   @objc func backMethodAction(_ sender: UIButton) {
      self.navigationController?.popViewController(animated: true)
   }
}

// MARK: CONFORM ORDER LIST PROTOCOL
extension OrderListViewController: OrderListProtocol {
   func onReceivedOrderListSuccess() {
      DispatchQueue.main.async {
         self.isLoading = false
         
         if self.isComingFrom {
            self.btnFromDate.setTitle(self.fromDateStr+" ", for:.normal)
         } else {
            self.btnToDate.setTitle(self.toDateStr+" ", for:.normal)
         }
        if !(self.viewModel?.arrOrderList.isEmpty ?? false) &&
            (self.viewModel?.arrOrderList.count ?? 0 > 0) {
            self.orderListTableView.isHidden = false
            self.imgEmptyCart.isHidden = true
            self.refreshControl.endRefreshing()
            self.orderListTableView.reloadData()
        } else {
            self.refreshControl.endRefreshing()
            self.orderListTableView.isHidden = true
            self.imgEmptyCart.isHidden = false
        }
      }
   }
    
   func onFailure(errorMsg: String) {
    DispatchQueue.main.async {
     self.isLoading = false
     self.viewModel?.arrOrderList.removeAll()
     self.orderListTableView.reloadData()
     self.refreshControl.endRefreshing()
     let alertTitle = NSLocalizedString("ALERT_ERROR_TITLE", comment: "")
     BaseViewController.showBasicAlert(message: errorMsg, title: alertTitle)
    }
    
    }
}

// MARK: TABLEVIEW DELEGATE & DATASOURCE METHODS
extension OrderListViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel?.arrOrderList.count ?? 0 > 0 {
            return self.viewModel?.arrOrderList.count ?? 0
        } else { return 0 }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let orderListCell = tableView.dequeueReusableCell(withIdentifier:
         TABLEVIEWCELLID.ORDERLISTCELLID, for: indexPath) as? OrderListViewCell
      
         let arrOrderDetails = self.viewModel?.arrOrderList[indexPath.row]
         var currencySymbol: String = ""
         
         if let currSym = arrOrderDetails?.currency {
            if (!currSym.isEmpty) && currSym != "" {
                currencySymbol = currSym
            } else {
                currencySymbol = "$"
            }
         }
        
         if let orderNo = arrOrderDetails?.orderNumber {
            if (!orderNo.isEmpty) && (orderNo != "") {
                orderListCell?.lblInvoiceNo.isHidden = false
                orderListCell?.lblInvoiceNo.text = "Invoice No: "+orderNo
            } else {
                orderListCell?.lblInvoiceNo.text = ""
                orderListCell?.lblInvoiceNo.isHidden = true
            }
         }
        
        orderListCell?.deliveryDateStackView.isHidden = true
        orderListCell?.orderDateStackView.isHidden = true

        if let orderStatus = arrOrderDetails?.orderStatus {
        
        if segmentControl.selectedSegmentIndex == 1 {
            if orderStatus.lowercased().trim().contains("processing") || orderStatus.lowercased().trim().contains("coming") {
                orderListCell?.lblOrderStatus.backgroundColor = UIColor.lightNavy
                orderListCell?.lblOrderStatus.text = "Coming"
            } else if orderStatus.lowercased().trim().contains("failed") {
                orderListCell?.lblOrderStatus.backgroundColor = UIColor.red
                orderListCell?.lblOrderStatus.text = "Failed"
            } else  {
                orderListCell?.lblOrderStatus.backgroundColor = UIColor.gray
                orderListCell?.lblOrderStatus.text = orderStatus
            }
        } else if segmentControl.selectedSegmentIndex == 2 {
            if orderStatus.lowercased().trim().contains("completed") || orderStatus.lowercased().trim().contains("delivered") {
                orderListCell?.lblOrderStatus.backgroundColor = UIColor.trueGreen
                orderListCell?.lblOrderStatus.text = "Delivered"
                if let deliverDate = arrOrderDetails?.deliveryDate {
                    if (!deliverDate.isEmpty) && (deliverDate != "") {
                        orderListCell?.deliveryDateStackView.isHidden = false
                        orderListCell?.btnOrderDeliveryDate.setTitle(" Delivery Date: \(deliverDate)", for: .normal)
                    }
                }

                
            } else if orderStatus.lowercased().trim().contains("failed") {
                orderListCell?.lblOrderStatus.backgroundColor = UIColor.red
                orderListCell?.lblOrderStatus.text = "Failed"
            } else  {
                orderListCell?.lblOrderStatus.backgroundColor = UIColor.gray
                orderListCell?.lblOrderStatus.text = orderStatus
            }
        } else {
            if orderStatus.lowercased().trim().contains("processing") {
                orderListCell?.lblOrderStatus.backgroundColor = UIColor.lightNavy
                orderListCell?.lblOrderStatus.text = "Coming"
            } else if orderStatus.lowercased().trim().contains("completed") {
                orderListCell?.lblOrderStatus.backgroundColor = UIColor.trueGreen
                orderListCell?.lblOrderStatus.text = "Delivered"
                
                if let deliverDate = arrOrderDetails?.deliveryDate {
                    if (!deliverDate.isEmpty) && (deliverDate != "") {
                        orderListCell?.deliveryDateStackView.isHidden = false
                        orderListCell?.btnOrderDeliveryDate.setTitle(" Delivery Date: \(deliverDate)", for: .normal)
                    }
                }
            } else if orderStatus.lowercased().trim().contains("failed") {
                orderListCell?.lblOrderStatus.backgroundColor = UIColor.red
                orderListCell?.lblOrderStatus.text = "Failed"
            } else  {
                orderListCell?.lblOrderStatus.backgroundColor = UIColor.gray
                orderListCell?.lblOrderStatus.text = orderStatus
            }
        }
        }
        
        var orderTotalVal: Int = 0
        
        orderListCell?.lblOrderTotalAmt.isHidden = true

        if let orderTotal = arrOrderDetails?.orderTotal {
          if !orderTotal.isEmpty {
                orderListCell?.lblOrderTotalAmt.isHidden = false
                let textPartOne = NSMutableAttributedString(string: currencySymbol+orderTotal,
                                                                   attributes: nil)
                orderListCell?.lblOrderTotalAmt.attributedText = textPartOne
                orderTotalVal = (orderTotal as NSString).integerValue
            }
       }

        if let ordrTotalRefunded = arrOrderDetails?.orderTotalRefunded {
            if ordrTotalRefunded != 0.0 {
                
                orderListCell?.lblOrderTotalAmt.isHidden = false
                let remainingTotal = Float(orderTotalVal) + ordrTotalRefunded
                
                let currencyFormatter = NumberFormatter()
                currencyFormatter.numberStyle = .currency
                currencyFormatter.currencyCode = currencySymbol
                let priceInDoller = currencyFormatter.string(from: orderTotalVal as NSNumber)!
                let attributedString1 = NSMutableAttributedString(string: priceInDoller )
                
                attributedString1.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString1.length))

                //let attributeString1: NSMutableAttributedString =  NSMutableAttributedString(string: "\(currencySymbol)"+orderTotalVal.description)
                //attributeString1.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString1.length))
                let doubleStr = String(format: "%.2f", remainingTotal)

                let attributeString2: NSMutableAttributedString =  NSMutableAttributedString(string: "  \(currencySymbol)"+doubleStr)

                let combination = NSMutableAttributedString()

                combination.append(attributedString1)
                combination.append(attributeString2)
                orderListCell?.lblOrderTotalAmt.attributedText = combination
            }
        }
        
        
        //  orderListCell?.lblOrderTotalAmt.text = " Order Total: \(currencySymbol+orderTotal)"
        // orderListCell?.btnOrderTotalAmt.setTitle(" Order Total: \(currencySymbol+orderTotal)", for: .normal)
         
        if let orderDate = arrOrderDetails?.orderDate {
           if (!orderDate.isEmpty) && (orderDate != "") {
              orderListCell?.orderDateStackView.isHidden = false
              orderListCell?.lblOrderDate.text = " Order Date: \(orderDate)"
           }
        }
    
        return orderListCell ?? UITableViewCell.init()
   }
   func tableView(_ tableView: UITableView,
                  willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      if let orderListCell = cell as? OrderListViewCell {
         orderListCell.backView.layer.masksToBounds = false
         orderListCell.backView.layer.cornerRadius = 8
         orderListCell.backView.layer.applySketchShadow(
            color: UIColor.black8,
            alpha: 1,
            x: 0,
            y: 4,
            blur: 23,
            spread: 0)
      }
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      var orderId: String = ""
      let allDetails = self.viewModel?.arrOrderList[indexPath.row]
      if let orderNo = allDetails?.orderNumber { orderId = orderNo }
      self.navigateToOrderDetailVC(orderId: orderId)
    }
}

// MARK: MANAGE DATE PICKER
extension OrderListViewController {
   
   @IBAction func cancelBtnMethodAction(sender: UIButton) {
      self.isPickerShow = false
      
      showHideDatePicker(isShow: self.isPickerShow)
   }
   
   @IBAction func selectDateMethodAction(sender: UIButton) {
      self.isPickerShow = false
      selectedDate  = self.datePicker.date.toString(dateFormat: "MM/dd/yyyy")
      if self.isComingFrom {
         self.fromDateStr = self.selectedDate
         self.btnFromDate.setTitle(selectedDate+" ", for: .normal) 
         let from: String = self.datePicker.date.toString(dateFormat: "yyyy-MM-dd")
         self.viewModel?.orderListRequest.dateFrom = from
      } else {
         self.toDateStr = self.selectedDate
         self.btnToDate.setTitle(selectedDate+" ", for: .normal)
         let toDate: String = self.datePicker.date.toString(dateFormat: "yyyy-MM-dd")
         self.viewModel?.orderListRequest.dateTo = toDate
      }
      showHideDatePicker(isShow: self.isPickerShow)
      self.getProductList()
   }
   
   func showHideDatePicker(isShow: Bool = false) {
      if isShow {
         self.orderListTableView.isUserInteractionEnabled = false
         self.segmentControl.isUserInteractionEnabled = false
         self.backViewDatePicker.isHidden = false
      } else {
         self.orderListTableView.isUserInteractionEnabled = true
         self.segmentControl.isUserInteractionEnabled = true
         self.backViewDatePicker.isHidden = true
      }
   }
   
   func navigateToOrderDetailVC(orderId: String? = "") {
      let orderDetailVC: OrderDetailsViewController =
              (UIStoryboard.init(name: STORYBOARDCONS.ORDER,
                                 bundle: Bundle.main).instantiateViewController(withIdentifier:
                                   VCIDENTIFIER.ORDERDETAILVC) as? OrderDetailsViewController)!
      orderDetailVC.orderId = orderId ?? ""
      self.navigationController?.pushViewController(orderDetailVC, animated: true)
    }
}

extension OrderListViewController {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !isLoading {
               if ((orderListTableView.contentOffset.y + orderListTableView.frame.size.height) >= orderListTableView.contentSize.height - 50) {
                   loadMoredata()
               }
           }
       }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                  willDecelerate decelerate: Bool) {

        if(!decelerate) && (!isLoading) {
            if ((orderListTableView.contentOffset.y + orderListTableView.frame.size.height) >= orderListTableView.contentSize.height - 50) {
                loadMoredata()
            }
        }
    }
      
     func loadMoredata() {
        let totalCount = Int(self.viewModel?.orderListResponse?.order_count ?? "0") ?? 0
            if( totalCount > self.viewModel?.arrOrderList.count ?? 0) {
                isLoading = true
                var pageNo = Int(self.viewModel?.orderListRequest.currentPage ?? "1")
                pageNo = (pageNo ?? 1) + 1
                self.viewModel?.orderListRequest.currentPage = String(pageNo ?? 1)
                self.getProductList()
            }
       }
}
