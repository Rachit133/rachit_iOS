//
//  OrderDetailsViewController.swift
//  Beer Connect
//
//  Created by Synsoft on 17/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit
import SDWebImage
import UserNotifications

class OrderDetailsViewController: BaseViewController {
    
    @IBOutlet weak var orderDetailTableView: UITableView!
    @IBOutlet weak var lblOrderPlaced: UILabel!
    @IBOutlet weak var lblOrderPlacedVal: UILabel!
    @IBOutlet weak var lblDeliveryPrepration: UILabel!
    @IBOutlet weak var lblDeliveryPreprationVal: UILabel!
    @IBOutlet weak var lblMainDeliveryDate: UILabel!
    @IBOutlet weak var lblMainDeliveryDateVal: UILabel!
    @IBOutlet weak var lblDelivered: UILabel!
    
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblSubTitleVal: UILabel!
    //  @IBOutlet weak var lblDiscountVal: UILabel!
    @IBOutlet weak var lblTotalVal: UILabel!
    @IBOutlet weak var lblAmountSaved: UILabel!
    
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblStreetAddress: UILabel!
    @IBOutlet weak var lblSuiteUnit: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblState: UILabel!
    @IBOutlet weak var lblZipCode: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblPO: UILabel!
    @IBOutlet weak var lblDeliveryDate: UILabel!
    @IBOutlet weak var lblOrderNote: UILabel!
    @IBOutlet weak var txtCommentView: UITextView!
    @IBOutlet weak var btnDownloadInvoice: UIButton!
    @IBOutlet weak var btnEmailInvoice: UIButton!
    @IBOutlet weak var lblFirstNameVal: UILabel!
    @IBOutlet weak var lblLastNameVal: UILabel!
    @IBOutlet weak var lblCompanyVal: UILabel!
    @IBOutlet weak var lblStreetAddressVal: UILabel!
    @IBOutlet weak var lblSuiteUnitVal: UILabel!
    @IBOutlet weak var lblCityVal: UILabel!
    @IBOutlet weak var lblStateVal: UILabel!
    @IBOutlet weak var lblZipCodeVal: UILabel!
    @IBOutlet weak var lblPhoneNumberVal: UILabel!
    @IBOutlet weak var btnDeliveryDate: UIButton!
    @IBOutlet weak var backgroundShippingView: UIView!
    @IBOutlet weak var txtPONumber: UITextField!
    @IBOutlet weak var backViewTotalAmount: UIView!
    @IBOutlet weak var lblDeliveredDate: UILabel!
    
    @IBOutlet weak var lblTotalRefundAmt: UILabel!
    @IBOutlet weak var lblTotalRefundAmtVal: UILabel!
    @IBOutlet weak var viewForRefundAmt: UIView!
    @IBOutlet weak var viewForYouSaved: UIView!
    
    
    var viewModel: OrderDetailViewModel?
    var userId: String? = ""
    var orderId: String = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var pdfUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NetworkManager.shared.checkInternetConnectivity()
        applyShadowToScreen()
        manageNavigationUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //appDelegate.navigationController?.navigationBar.isHidden = true
        //self.navigationController?.navigationBar.isHidden = true
    }
    
    func manageNavigationUI() {
        if #available(iOS 11.0, *) {
            self.orderDetailTableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        BaseViewController.showHideRootNavigationBar(isVisible: false)
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationLeftBarButton(viewController: self, isImage: true, imageName: "back", target: self, selector:  #selector(backMethodAction(_:)))
        self.title = "Order Details"
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationItem.largeTitleDisplayMode = .always
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorConstants.APPBLUECOLOR,
                                                                                 NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Bold", size: 34)!]
        }
        
    }
    
    func applyShadowToScreen() {
        self.backViewTotalAmount.layer.applySketchShadow(
            color: UIColor.black10,
            alpha: 1,
            x: 0,
            y: 10,
            blur: 20,
            spread: 0)
        
        self.backgroundShippingView.layer.applySketchShadow(
            color: UIColor.black22,
            alpha: 1,
            x: 0,
            y: 10,
            blur: 20,
            spread: 0)
    }
    
    @objc func backMethodAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension OrderDetailsViewController {
    func initComponents() {
        initializeViewModel()
        getOrderDetails()
    }
    
    func initializeViewModel() {
        self.viewModel = OrderDetailViewModel(delegate: self)
    }
    
    func getOrderDetails() {
        if UserDefaults.standard.isKeyPresentInUserDefaults(key: "loginUser") {
            guard let loginDetails =  UserDefaults.standard.retrieve(object:
                LoginResponse.self, fromKey: "loginUser") else { return }
            
            guard let customerId =  loginDetails.data?.customer?.customerID else { return }
            self.userId = customerId
            
            self.viewModel?.orderDetailRequest.userId = self.userId
            self.viewModel?.orderDetailRequest.orderId = self.orderId
            self.viewModel?.getOrderDetailsFromServer()
        }
        
    }
}

extension OrderDetailsViewController: OrderDetailProtocol {
    func onDownloadFileSuccess(fileData: Data?) {
        
    }
    
//    func saveFileInDirectoryFrom(fileData: Data) {
//        do {
//
//            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
//            guard let orderNo = self.orderId else { return }
//            let pathComponent = resourceDocPath.appendingPathComponent("OrderInvoice-\(orderNo).pdf")
//            let filePath = pathComponent.path
//            if !FileManager.default.fileExists(atPath: filePath) {
//                try fileData.write(to: pathComponent, options: .atomic)
//                print("pdf successfully saved!")
//            } else {
//                self.view.makeToast("Invoice-\(orderNo) already present in your device.",
//                    duration: 1.5,
//                    position: .bottom)
//            }
//
//            var pdfURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
//            pdfURL = pdfURL.appendingPathComponent("OrderInvoice-\(orderNo).pdf") as URL
//            self.pdfUrl = pdfURL
//
//           // print("Url is \(pdfURL)")
//           // self.openPDFScreenForLocation(locationUrl: pdfURL)
//
//            //let data = try! Data(contentsOf: pdfURL)
//            //self.appDelegate.scheduleNotification(invoiceData: data)
//
//        } catch let error{
//            print("error is \(error.localizedDescription)")
//        }
//
//    }
    
    func openPDFScreenForLocation(locationUrl: URL) {
        if #available(iOS 11.0, *) {
            let pdfVC: PDFViewController =
                (UIStoryboard.init(name: STORYBOARDCONS.ORDER,
                                   bundle: Bundle.main).instantiateViewController(withIdentifier:
                                    VCIDENTIFIER.PDFVC) as? PDFViewController)!
            pdfVC.fileLocation = locationUrl
            pdfVC.orderNo = self.orderId
            pdfVC.modalPresentationStyle = .overFullScreen
            self.present(pdfVC,animated: true, completion: nil)
        }
    }
    
    func onReceivedOrderEmailDownloadSuccess() {
        if self.viewModel?.orderEmailDownloadRequest.actionType?.contains("pdf_email") ?? false {
            DispatchQueue.main.async {
                self.view.makeToast("Email sent successfully.",
                                    duration: 1.5,
                                    position: .bottom)
                }
            } else {
                if let fileURL = self.viewModel?.orderEmailDownloadResponse?.url {
                    if !fileURL.isEmpty {
                        let url = URL(string: fileURL)
                        let pdfData = try? Data.init(contentsOf: url!)
                        let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
                        let pdfNameFromUrl = "Invoice-\(String(describing: self.orderId)).pdf"
                        let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
                        let filePath = actualPath.path
                        do {
                            if !FileManager.default.fileExists(atPath: filePath) {
                                try pdfData?.write(to: actualPath, options: .atomic)
                                print("pdf successfully saved!")

                               // DispatchQueue.main.async {

                               // self.view.makeToast("Invoice-\(String(describing: self.orderId)) is successfully saved in your device.",
                                 //   duration: 1.5, position: .bottom)
                                //}
                            } else {
                                DispatchQueue.main.async {

                                self.view.makeToast("Invoice-\(String(describing: self.orderId)) already present in your device.",
                                duration: 1.5, position: .bottom)
                                }
                            }
                            
                            DispatchQueue.main.async {
                                self.openPDFScreenForLocation(locationUrl: actualPath)
                            }
                        } catch {
                            DispatchQueue.main.async {

                                self.view.makeToast("Invoice-\(String(describing: self.orderId)) could not be download.",
                            duration: 1.5, position: .bottom)
                            }
                            
                        }
                }
            }
            }
    }
    
    func onReceivedOrderDetailSuccess() {
        DispatchQueue.main.async {
            var subTotalVal: Double = 0
            var refundVal: Double = 0.0
            var discountStr: String = ""
            var grandTotalStr: String = ""
            var currencySymbolStr: String = ""
            var cityStr: String = ""
            var zipCodeStr: String = ""
            var stateStr: String = ""
            var poNumberStr: String = ""
            var add1Str: String = ""
            var add2Str: String = ""
            var deliveryDateStr: String = ""
            var orderNoteStr: String = ""
            var orderDateStr: String = ""
            var firstNameStr: String = ""
            var lastNameStr: String = ""
            var companyStr: String = ""
            var phoneNumberStr: String = ""
            var refundTotal: String = ""
            var subTotalStr: String = ""
            if let subTotal = self.viewModel?.orderDetailResponse?.ordersData?.subtotal {
                subTotalStr = subTotal.description
                subTotalVal = (subTotal as NSNumber).doubleValue
            }
            
            if let discount = self.viewModel?.orderDetailResponse?.ordersData?.discount?.description {
                discountStr = discount
            }
            
            if let refundTotalAmt = self.viewModel?.orderDetailResponse?.ordersData?.refundstotal {
                if !refundTotalAmt.isEmpty {
                    refundTotal = refundTotalAmt
                    self.lblTotalRefundAmtVal.text = refundTotal
                    self.viewForRefundAmt.isHidden = false
                    let refundSubString = refundTotalAmt.substring(from: 2)
                    refundVal = (refundSubString as NSString).doubleValue
                    
                } else {
                    self.lblTotalRefundAmtVal.text = ""
                    self.viewForRefundAmt.isHidden = true
                }
            } else {
                self.lblTotalRefundAmtVal.text = ""
                self.viewForRefundAmt.isHidden = true
            }
            
            if let grandTotal = self.viewModel?.orderDetailResponse?.ordersData?.grandtotal?.description {
                grandTotalStr = grandTotal
            }
            
            
            if let currencySymbol = self.viewModel?.orderDetailResponse?.ordersData?.currencySymbol?.description {
                currencySymbolStr = currencySymbol
            }
            if let city = self.viewModel?.orderDetailResponse?.ordersData?.city?.description {
                cityStr = city
            }
            if let zipCode = self.viewModel?.orderDetailResponse?.ordersData?.getAddress?.postcode {
                zipCodeStr = zipCode
            }
            if let state = self.viewModel?.orderDetailResponse?.ordersData?.getAddress?.state { stateStr = state
            }
            if let poNumber = self.viewModel?.orderDetailResponse?.ordersData?.poNumber {
                poNumberStr = poNumber
            }
            if let add1 = self.viewModel?.orderDetailResponse?.ordersData?.getAddress?.address1 {
                add1Str = add1
            }
            if let add2 = self.viewModel?.orderDetailResponse?.ordersData?.getAddress?.address2 {
                add2Str = add2
            }
            if let deliveryDate = self.viewModel?.orderDetailResponse?.ordersData?.deliveryDate {
                deliveryDateStr = deliveryDate
            }
            if let orderNote = self.viewModel?.orderDetailResponse?.ordersData?.orderNote {
                orderNoteStr = orderNote
            }
            if let orderDate = self.viewModel?.orderDetailResponse?.ordersData?.orderdate {
                orderDateStr = orderDate
            }
            if let firstName = self.viewModel?.orderDetailResponse?.ordersData?.getAddress?.firstName {
                firstNameStr = firstName
            }
            if let lastName = self.viewModel?.orderDetailResponse?.ordersData?.getAddress?.lastName {
                lastNameStr = lastName
            }
            if let company = self.viewModel?.orderDetailResponse?.ordersData?.getAddress?.company {
                companyStr = company
            }
            if let phoneNumber = self.viewModel?.orderDetailResponse?.ordersData?.getAddress?.phone {
                phoneNumberStr = phoneNumber
            }
            
            if let orderId = self.viewModel?.orderDetailResponse?.ordersData?.orderId {
                self.title = "Order Number: " + orderId
            }
            
            if let deliveredDate = self.viewModel?.orderDetailResponse?.ordersData?.deliveredDate {
                self.lblDeliveredDate.text = deliveredDate
            }
            
            if let amountSaved = self.viewModel?.orderDetailResponse?.ordersData?.amountSaved {
                
                if !amountSaved.isEmpty{
                    self.viewForYouSaved.isHidden = false
                    self.lblAmountSaved.isHidden = false
                    self.lblAmountSaved.text = amountSaved
                } else {
                    self.viewForYouSaved.isHidden = true
                    self.lblAmountSaved.isHidden = true
                    self.lblAmountSaved.text = ""
                }
            } else {
                self.viewForYouSaved.isHidden = true
                self.lblAmountSaved.isHidden = true
                self.lblAmountSaved.text = ""
            }
            
            if !subTotalVal.description.isEmpty ||
                !discountStr.isEmpty ||
                !grandTotalStr.isEmpty ||
                !stateStr.isEmpty ||
                !cityStr.isEmpty ||
                !zipCodeStr.isEmpty ||
                !poNumberStr.isEmpty ||
                !deliveryDateStr.isEmpty ||
                !orderNoteStr.isEmpty ||
                !orderDateStr.isEmpty ||
                !firstNameStr.isEmpty ||
                !lastNameStr.isEmpty ||
                !companyStr.isEmpty ||
                !phoneNumberStr.isEmpty {
                
                self.lblPhoneNumberVal.text = phoneNumberStr
                self.lblCompanyVal.text = companyStr
                self.lblFirstNameVal.text = firstNameStr
                self.lblLastNameVal.text = lastNameStr
                self.lblCityVal.text = cityStr
                self.lblStateVal.text = stateStr
                self.lblZipCodeVal.text = zipCodeStr
                self.lblStreetAddressVal.text = add1Str
                self.lblSuiteUnitVal.text = add2Str
                self.btnDeliveryDate.setTitle(deliveryDateStr, for: .normal)
                self.txtCommentView.text = orderNoteStr
                self.txtPONumber.text = poNumberStr
                
                self.lblSubTitleVal.text = currencySymbolStr+subTotalStr.description
                
                if !refundTotal.isEmpty && refundTotal.count > 0 {
                    let mainSubtotal = subTotalVal - refundVal
                    let doubleStr = String(format: "%.2f", mainSubtotal)
                    self.lblTotalVal.text = currencySymbolStr+doubleStr.description
                } else {
                    self.lblTotalVal.text = currencySymbolStr+grandTotalStr
                }
                
                //self.lblDiscountVal.text = currencySymbolStr+discountStr
                self.lblMainDeliveryDateVal.text = deliveryDateStr
                
                //let dateFormatter = DateFormatter()
                //  self.lblDeliveryDate.text = deliveryDateStr
                
                //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSS"
                //if let orderObjDate = dateFormatter.date(from: orderDateStr) {
                 //   let orderDateStr = orderObjDate.toString(dateFormat: "MM/dd/yyyy")
                self.lblOrderPlacedVal.text = orderDateStr
                //} else {
                  //  self.lblOrderPlacedVal.text = ""
               // }
                
                let dateFormatter1 = DateFormatter()
                dateFormatter1.dateFormat = "MM/dd/yyyy"
                
                if let deliveryDateObj = dateFormatter1.date(from: deliveryDateStr) {
                    dateFormatter1.dateFormat = "MM/dd/yyyy"
                    
                    var dayComponent    = DateComponents()
                    dayComponent.day    = -1
                    let theCalendar     = Calendar.current
                    let previousDate    = theCalendar.date(byAdding: dayComponent,
                                                           to: deliveryDateObj)
                    let previousDateStr = previousDate?.toString(dateFormat: "MM/dd/yyyy")
                    self.lblDeliveryPreprationVal.text = previousDateStr
                }
            }
            
            self.orderDetailTableView.reloadData()
          //  if self.viewModel?.arrOrderItems.count ?? 0 > 0 || self.viewModel?.arrRefunds.count ?? 0 > 0 {
            //}
        }
    }
    
    func onFailure(errorMsg: String) {
        
    }
}


extension OrderDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if self.viewModel?.arrOrderItems.count ?? 0 > 0 {
                return self.viewModel?.arrOrderItems.count ?? 0
            }
        } else if section == 1 {
            if self.viewModel?.arrRefunds.count ?? 0 > 0 {
                return self.viewModel?.arrRefunds.count ?? 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let orderDetailCell = tableView.dequeueReusableCell(withIdentifier:
                TABLEVIEWCELLID.ORDERDETAILCELLID,
                                                                      for: indexPath) as? OrderDetailViewCell else { return UITableViewCell.init() }
            let orderItemsDetails = self.viewModel?.arrOrderItems[indexPath.row]
            
            var itemname: String = ""
            var itemqty: Int = 0
            var itemcurrency: String = "$"
            var itemtotal: String = ""
            var subtotalVal: Float = 0
            
            if let itemCurrency = orderItemsDetails?.itemCurrency {
                if !itemCurrency.isEmpty {
                    itemcurrency = itemCurrency
                }
            }

            orderDetailCell.lblOrderItemTitle.isHidden = true
            if let itemName = orderItemsDetails?.itemName  {
                if !itemName.isEmpty {
                    orderDetailCell.lblOrderItemTitle.isHidden = false
                    itemname = itemName
                    orderDetailCell.lblOrderItemTitle.text = itemname
                }
            }
            
            orderDetailCell.lblOrderQuantity.isHidden = true
            if let itemQty = orderItemsDetails?.itemQty {
                if !itemQty.isEmpty {
                    orderDetailCell.lblOrderQuantity.isHidden = false
                    let textPartOne = NSMutableAttributedString(string: "Order Quantity : "+itemQty,
                                                                attributes: nil)
                    orderDetailCell.lblOrderQuantity.attributedText = textPartOne
                    itemqty = (itemQty as NSString).integerValue
                }
            }
            
            orderDetailCell.lblOrderItemPrice.isHidden = true
            
            if let itemTotal = orderItemsDetails?.itemTotal?.description {
                if !itemTotal.isEmpty {
                    itemtotal = itemTotal
                    orderDetailCell.lblOrderItemPrice.isHidden = false
                    orderDetailCell.lblOrderItemPrice.text = itemcurrency+itemtotal
                }
            }
            
            orderDetailCell.lblLineItemTotal.isHidden = true
            
            if let subTotal = orderItemsDetails?.itemSubtotal {
                if subTotal != 0 {
                    orderDetailCell.lblLineItemTotal.isHidden = false
                    let textPartOne = NSMutableAttributedString(string: "Item Total: "+itemcurrency+subTotal.description,attributes: nil)
                    orderDetailCell.lblLineItemTotal.attributedText = textPartOne
                    subtotalVal = subTotal
                }
            }
            
            orderDetailCell.imgOrderDetailProduct.image = UIImage(named: "catDefault")

            if let itemImageUrl = orderItemsDetails?.itemImage {
                if !itemImageUrl.isEmpty {
                    orderDetailCell.imgOrderDetailProduct.sd_imageIndicator = SDWebImageActivityIndicator.gray
                     orderDetailCell.imgOrderDetailProduct.sd_setImage(with: URL(string: itemImageUrl), placeholderImage: UIImage(named: "catDefault"))
                }
            }
            
            if let youSavedValue = orderItemsDetails?.youSaved, youSavedValue != "" {
                orderDetailCell.lblYouSaved.isHidden = false
                orderDetailCell.lblYouSaved.text = youSavedValue.trim()
            } else {
                orderDetailCell.lblYouSaved.isHidden = true
                orderDetailCell.lblYouSaved.text = ""
            }
            
           orderDetailCell.lblRefundTotal.isHidden = true
           orderDetailCell.lblRefundQuantity.isHidden = true
           
            var refundTotalAmt: Float = 0
            
            if let refundTotal = orderItemsDetails?.itemRefundedTotal, refundTotal != 0 {
                if refundTotal != 0 {
                    refundTotalAmt = refundTotal
                    let resultTotalVal = subtotalVal + refundTotalAmt

                    let fontAttribute = [NSAttributedString.Key.font: UIFont(name: "SFProText-Semibold", size: 15)]

                    let currencyFormatter = NumberFormatter()
                    currencyFormatter.numberStyle = .currency
                    currencyFormatter.currencyCode = itemcurrency
                    
                    let itemSubTotal = currencyFormatter.string(from: subtotalVal as NSNumber)!
                  
                    let attributeString1: NSMutableAttributedString =  NSMutableAttributedString(string: "Item Total: ")
                    attributeString1.addAttributes(fontAttribute as [NSAttributedString.Key : Any], range: NSMakeRange(0, attributeString1.length))
                    
                    let attributedString2 = NSMutableAttributedString(string:itemSubTotal)
                    attributedString2.addAttributes(fontAttribute as [NSAttributedString.Key : Any], range: NSMakeRange(0, attributedString2.length))
                    attributedString2.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString2.length))
                    
                    let attributeString3: NSMutableAttributedString =  NSMutableAttributedString(string: "  "+itemcurrency+resultTotalVal.description)
                    attributeString3.addAttributes(fontAttribute as [NSAttributedString.Key : Any], range: NSMakeRange(0, attributeString3.length))
                    
                    let combination = NSMutableAttributedString()
                    combination.append(attributeString1)
                    combination.append(attributedString2)
                    combination.append(attributeString3)
                    orderDetailCell.lblLineItemTotal.attributedText = combination
                }}
            
            if let refundQty = orderItemsDetails?.itemRefundedQty,
                                                orderItemsDetails?.itemRefundedQty != 0 {
                if refundQty != 0 {
                    orderDetailCell.lblOrderQuantity.isHidden = false
                    let resultItemQty = itemqty + refundQty
                    let currencyFormatter = NumberFormatter()
                    let itemQuantity = currencyFormatter.string(from: itemqty as NSNumber)!
                    let fontAttribute = [NSAttributedString.Key.font: UIFont(name: "SFProText-Semibold", size: 15)]

                    let attributeString1: NSMutableAttributedString =  NSMutableAttributedString(string: "Order Qauntity :  ")
                    attributeString1.addAttributes(fontAttribute as [NSAttributedString.Key : Any], range: NSMakeRange(0, attributeString1.length))
                    
                    let attributedString2 = NSMutableAttributedString(string: itemQuantity)
                    attributedString2.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString2.length))
                    attributedString2.addAttributes(fontAttribute as [NSAttributedString.Key : Any], range: NSMakeRange(0, attributedString2.length))
                                      
                    
                    let attributeString3: NSMutableAttributedString =  NSMutableAttributedString(string: "  "+resultItemQty.description)
                    attributeString3.addAttributes(fontAttribute as [NSAttributedString.Key : Any], range: NSMakeRange(0, attributeString3.length))

                    let combination = NSMutableAttributedString()
                    combination.append(attributeString1)
                    combination.append(attributedString2)
                    combination.append(attributeString3)
                    orderDetailCell.lblOrderQuantity.attributedText = combination
                }
            }
            return orderDetailCell
            
        } else if indexPath.section == 1 {
            
            guard let refundInfoCell = tableView.dequeueReusableCell(withIdentifier:
                TABLEVIEWCELLID.REFUNDINFOCELLID,
                                                                     for: indexPath) as? RefundInfoCell else { return UITableViewCell.init() }
            let refundInfo = self.viewModel?.arrRefunds[indexPath.row]
            
            refundInfoCell.lblRefundReason.isHidden = false
            refundInfoCell.lblRefundDetails.isHidden = false
            refundInfoCell.lblRefundAmt.isHidden = false
            
            if let refundAmt = refundInfo?.refundAmount {
                if !refundAmt.isEmpty {
                    refundInfoCell.lblRefundAmt.isHidden = false
                    refundInfoCell.lblRefundAmt.text = "Refund Amount"+refundAmt
                }
            }
            
            if let refundDetails = refundInfo?.refundDetails {
                if !refundDetails.isEmpty {
                    refundInfoCell.lblRefundDetails.isHidden = false
                    refundInfoCell.lblRefundDetails.text = refundDetails
                    
                }
            }
            
            if let refundReason = refundInfo?.refundReason {
                if !refundReason.isEmpty {
                    refundInfoCell.lblRefundReason.isHidden = false
                    refundInfoCell.lblRefundReason.text = refundReason
                }
            }
            
            return refundInfoCell
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let orderItemCell = cell as? OrderDetailViewCell {
                orderItemCell.backView.layer.applySketchShadow(
                    color: UIColor.black10,
                    alpha: 1,
                    x: 0,
                    y: 4,
                    blur: 16,
                    spread: 0)
            }
        } else {
            if let refundInfoCell = cell as? RefundInfoCell {
                refundInfoCell.refundBackView.layer.applySketchShadow(
                    color: UIColor.black10,
                    alpha: 1,
                    x: 0,
                    y: 10,
                    blur: 20,
                    spread: 0)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var rowHeight:CGFloat = 0.0
        if indexPath.section == 0 {
            rowHeight = 165.0
            return rowHeight
        } else {
            rowHeight = 95.0
            return rowHeight
        }
    }
}

// MARK: EMAIL/ DOWNLOAD INVOIDE AAPI FUNCTINALITY
extension OrderDetailsViewController {
    
    @IBAction func downloadOrderInvoiceMethod(_ sender: UIButton) {
        self.viewModel?.orderEmailDownloadRequest.actionType = "pdf_download"
        self.viewModel?.orderEmailDownloadRequest.orderId = self.orderId
        self.viewModel?.getRequestForEmailOrDownloadReciept()
    }
    
    @IBAction func emailOrderInvoiceMethod(_ sender: UIButton) {
        openEmailDialog()
    }
    
    func openEmailDialog() {
        self.showInputDialog(title: "EMAIL ID", subtitle: nil, actionTitle: "SEND", cancelTitle: "CANCEL", inputPlaceholder: "Please enter email address to get invoice.", inputKeyboardType: .emailAddress, cancelHandler: { (cancelAction) in }) { (emailId: String?) in
            
            if let emailAddress: String = emailId {
                
                if !emailAddress.isEmpty {
                    if emailAddress.isValidEmail(email: emailAddress) {
                        self.sendEmailRequestToServerWith(emailStr: emailAddress)
                    } else {
                        self.view.makeToast("Your email id is invalid.", duration: 1.5, position: .bottom)
                    }
                } else {
                    self.view.makeToast("Please enter email id to send your invoice.", duration: 1.5, position: .bottom)
                }
            }
        }
    }
    
    func sendEmailRequestToServerWith(emailStr: String? = "") {
        self.viewModel?.orderEmailDownloadRequest.emailTo = emailStr
        self.viewModel?.orderEmailDownloadRequest.actionType = "pdf_email"
        self.viewModel?.orderEmailDownloadRequest.orderId = self.orderId
        self.viewModel?.getRequestForEmailOrDownloadReciept()
    }
}
