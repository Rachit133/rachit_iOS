//
//  OrderReviewViewController.swift
//  Beer Connect
//
//  Created by Synsoft on 02/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit
import SDWebImage

class OrderReviewViewController: BaseViewController {
    
    @IBOutlet weak var amountSaveHieghtConstraint: NSLayoutConstraint!
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
    @IBOutlet weak var lblAmountSaved: UILabel!
    
    @IBOutlet weak var btnPlaceOrder: UIButton!
    @IBOutlet weak var btnMyCartEdit: UIButton!
    @IBOutlet weak var btnShippingDetailsEdit: UIButton!
    
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
    @IBOutlet weak var orderReviewTableView: UITableView!
    @IBOutlet weak var backShippingView: UIView!
    
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblSubTitleVal: UILabel!
   // @IBOutlet weak var lblDiscountVal: UILabel!
    @IBOutlet weak var lblTotalVal: UILabel!
    @IBOutlet weak var btnChangePayment: UIButton!
    @IBOutlet weak var txtPO: UITextField!
    
    @IBOutlet weak var lblPaymentTitle: UILabel!
    @IBOutlet weak var lblPaymentSubTitle: UILabel!
    @IBOutlet weak var imgPaymentIcon: UIImageView!
    @IBOutlet weak var backSavedAmountView: UIView!

    private var viewModel: OrderReviewViewModel?
    private var checkOutviewModel: ProcessCheckOutViewModel?
    var userId: String = ""
    var paymentMethodType: String = ""
    var paymentTypeDetails = PaymentMethodType.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        manageNavigationBar()
    }
}

extension OrderReviewViewController {
    func initComponents() {
        manageShadowOfView()
        initializeViewModel()
        proceedActionForCheckOut()
    }
    
    func initializeViewModel() {
        self.txtPO.isUserInteractionEnabled = false
        self.txtCommentView.isUserInteractionEnabled = false
        self.viewModel = OrderReviewViewModel(delegate: self)
        self.checkOutviewModel = ProcessCheckOutViewModel(delegate: self)
    }
    
    func proceedActionForCheckOut() {
        if let loginDetails = UserDefaults.standard.retrieve(object: LoginResponse.self, fromKey: "loginUser") {
            if let customerId: String = loginDetails.data?.customer?.customerID {
                self.userId = customerId
                self.viewModel?.orderReviewRequest.customerId = customerId
                self.viewModel?.proceedToCheckOutToServer()
            }
        }
    }
    
    func manageShadowOfView() {
        self.backShippingView.layer.applySketchShadow(
            color: UIColor.black22,
            alpha: 1,
            x: 7,
            y: 10,
            blur: 20,
            spread: 0)
    }
    
    func manageNavigationBar() {
        
        if #available(iOS 11.0, *) {
            self.orderReviewTableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationLeftBarButton(viewController: self, isImage: true, imageName: "back", target: self, selector:  #selector(backMethodAction(_:)))
        self.navigationItem.title = "Order Review"
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

extension OrderReviewViewController {
    
    @IBAction func placeOrderMethodAction(_ sender: UIButton) {
        // self.navigationController!.popToRootViewController(animated: true)
        self.placeOrdersToServer()
        //tabBarController?.selectedIndex = 1
        //self.popBack(toControllerType: DashboardViewController.self)
    }
    
    @IBAction func editMyCartMethodAction(_ sender: UIButton) {
        self.popBack(toControllerType: MyCartViewController.self)
    }
    
    @IBAction func editShippingDetailsMethodAction(_ sender: UIButton) {
        self.popBack(toControllerType: ShippingDetailsViewController.self)
    }
    
    @IBAction func changePaymentMethodAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func placeOrdersToServer() {
        var dateStr = ""
        var commentStr = ""
        var poNumberStr = ""
        guard let loginDetails: LoginResponse = UserDefaults.standard.retrieve(object: LoginResponse.self, fromKey: "loginUser") else { return }
        guard let shippingDetailsValue: Parameter = (UserDefaults.standard.value(forKey: "shippingData") as! Parameter) else { return }
        
        if shippingDetailsValue.count > 0 && !shippingDetailsValue.isEmpty {
            if let deliverDateStr: String = shippingDetailsValue["delivery_date"] as? String {
                dateStr = deliverDateStr
            }
            
            if let noteStr: String = shippingDetailsValue["order_note"] as? String {
                commentStr = noteStr
            }
            
            if let poNumber: String = shippingDetailsValue["po_number"] as? String {
                poNumberStr = poNumber
            }
        }
        
        
        let isoDate: String = dateStr
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let myDate = dateFormatter.date(from:isoDate)!
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateStrFormat = dateFormatter.string(from: myDate)
        
        let date1Str: String = dateStrFormat
        let date2Str: String = dateStr
        let orderNoteStr: String = commentStr
        
        var salesTokenId: String = ""
        if let adminSalesDetails = UserDefaults.standard.retrieve(object: LoginResponse.self, fromKey: "adminSalesDetails") {
            if let isSalesPerson: Bool = adminSalesDetails.data?.customer?.salePerson {
                if isSalesPerson {
                    if let tokenIdStr = adminSalesDetails.data?.customer?.hash {
                        salesTokenId = tokenIdStr
                    }
                }
            }
        }
        
        guard let userId: String = loginDetails.data?.customer?.customerID else { return }
        self.checkOutviewModel?.processCheckOutRequest.customerId = userId
        self.checkOutviewModel?.processCheckOutRequest.PaymentMethod = self.paymentMethodType
        self.checkOutviewModel?.processCheckOutRequest.shippingMethod = "free_shipping"
        self.checkOutviewModel?.processCheckOutRequest.orderNote = orderNoteStr
        self.checkOutviewModel?.processCheckOutRequest.poNumber = poNumberStr
        self.checkOutviewModel?.processCheckOutRequest.date1 = date1Str
        self.checkOutviewModel?.processCheckOutRequest.date2 = date2Str
        self.checkOutviewModel?.processCheckOutRequest.dateChanged = true
        self.checkOutviewModel?.processCheckOutRequest.isiOSDevice = "1"
        self.checkOutviewModel?.processCheckOutRequest.salesId = salesTokenId
        self.checkOutviewModel?.processCheckOutToServer()
    }
}

// MARK: TABLEVIEW DELEGATE & DATASOURCE METHODS
extension OrderReviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.orderReviewResponse?.data?.products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderReviewCell = tableView.dequeueReusableCell(withIdentifier:
            TABLEVIEWCELLID.MYCARTDETAILCELLID,
                                                            for: indexPath) as? MyCartDetailCell
        
        orderReviewCell?.backView.layer.cornerRadius = 8
        orderReviewCell?.backView.layer.masksToBounds =  false
        orderReviewCell?.backView.layer.applySketchShadow(
            color: UIColor.black8,
            alpha: 1,
            x: 0,
            y: 4,
            blur: 23,
            spread: 0)
        
        let productDetails = self.viewModel?.orderReviewResponse?.data?.products?[indexPath.row]
        
        if let productId = productDetails?.productID {
            orderReviewCell?.productId = productId
        }
        
        if let productName  = productDetails?.productName {
            orderReviewCell?.lblTitle.text = productName
        }
        
        if let productImage = productDetails?.productImage {
            orderReviewCell?.titleImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            orderReviewCell?.titleImage.sd_setImage(with: URL(string: productImage), placeholderImage: UIImage(named: "catDefault"))
        } else {
            orderReviewCell?.titleImage.image = UIImage(named: "catDefault")
        }
        
        if let quantity = productDetails?.quantity?.description {
            //print("Quantity is \(quantity)")
            orderReviewCell?.lblQuantityCount.text = quantity
        }
        var symbol = "$"
        
        if let price = productDetails?.productPrice {
            if let currencySymbol = productDetails?.currencySymbol {
                symbol = currencySymbol
            }
            orderReviewCell?.lblPrice.text = symbol+""+price
        }
        
        if let subtotal = productDetails?.productSubtotal {
            orderReviewCell?.lblTotal.text = "Total: "+subtotal
        }
        
        if let discount = productDetails?.productDiscount , discount != "" {
            orderReviewCell?.lblDiscount.isHidden = false
            orderReviewCell?.lblDiscount.text = discount
        } else {
            orderReviewCell?.lblDiscount.isHidden = true
            orderReviewCell?.lblDiscount.text = ""
        }
        orderReviewCell?.isUserInteractionEnabled = false
        return orderReviewCell ?? UITableViewCell.init()
    }
}

extension OrderReviewViewController: OrderReviewProtocol {
    
    func onOrderReviewSuccess() {
        DispatchQueue.main.async {
            if self.viewModel?.arrMyCartProducts?.count ?? 0 > 0 {
                self.populateShippingDetails()
                self.refreshOrderReviewScreen()
            }
        }
    }
    
    func refreshOrderReviewScreen() {
        var symbol = "$"
        self.btnChangePayment.setTitle("Change", for: .normal)
        if let currencySymbol = self.viewModel?.orderReviewResponse?.data?.currencySymbol {
            symbol = currencySymbol
        }
        
        if let cartSubTotal = self.viewModel?.orderReviewResponse?.data?.cartSubtotal {
            self.lblSubTitleVal.text = symbol+cartSubTotal
        }
        
        if let totalVal = self.viewModel?.orderReviewResponse?.data?.cartTotal {
            self.lblTotalVal.text = symbol+totalVal
        }
        
//        if let discountAmt = self.viewModel?.orderReviewResponse?.data?.discountAmount {
//            self.lblDiscountVal.text = symbol+discountAmt.description
//        }
        
        if let amountSaved = self.viewModel?.orderReviewResponse?.data?.amountSaved {
            if !amountSaved.isEmpty {
                self.amountSaveHieghtConstraint.constant = 28.0
                self.backSavedAmountView.isHidden = false
                self.lblAmountSaved.isHidden = false
                self.lblAmountSaved.text = amountSaved
            } else {
                self.amountSaveHieghtConstraint.constant = 0.0
                self.backSavedAmountView.isHidden = true
                self.lblAmountSaved.isHidden = true
                self.lblAmountSaved.text = ""
            }
        } else {
            self.amountSaveHieghtConstraint.constant = 0.0
            self.backSavedAmountView.isHidden = true
            self.lblAmountSaved.isHidden = true
            self.lblAmountSaved.text = ""
        }
        
        self.lblPaymentTitle.text = paymentTypeDetails.methodTitle
        self.lblPaymentSubTitle.text = paymentTypeDetails.title
        
        
        self.orderReviewTableView.reloadData()
    }
    
    func onOrderReviewFailure(errorMsg: String) {
        DispatchQueue.main.async {
            self.view.isHidden = false
            self.orderReviewTableView.isHidden = false
            let alertTitle = NSLocalizedString("ALERT_ERROR_TITLE", comment: "")
            BaseViewController.showBasicAlert(message: errorMsg, title: alertTitle)
        }
        
    }
    
}

extension OrderReviewViewController {
    func populateShippingDetails() {
        
        guard let shippingDetails = UserDefaults.standard.retrieve(object: ShippingDetailResponse.self, fromKey: "shippingDetails") else { return }
        
        guard let dictValue: Parameter = (UserDefaults.standard.value(forKey: "shippingData") as! Parameter) else { return }
        
        if let firstName = shippingDetails.data?.userData?.shipping?.firstName {
            self.lblFirstNameVal.text = firstName
        }
        if let lastName = shippingDetails.data?.userData?.shipping?.lastName {
            self.lblLastNameVal.text = lastName
        }
        
        if let address2 = shippingDetails.data?.userData?.shipping?.address2 {
            if !address2.isEmpty { self.lblSuiteUnitVal.text = address2 }
        }
        if let cmpanyName = shippingDetails.data?.userData?.shipping?.company {
            self.lblCompanyVal.text = cmpanyName
        }
        if   let streetName = shippingDetails.data?.userData?.shipping?.address1 {
            self.lblStreetAddressVal.text = streetName
        }
        if   let cityName = shippingDetails.data?.userData?.shipping?.city {
            self.lblCityVal.text = cityName
        }
        if   let stateName = shippingDetails.data?.userData?.shipping?.state {
            self.lblStateVal.text = stateName
        }
        if     let zipCodeName = shippingDetails.data?.userData?.shipping?.postcode {
            self.lblZipCodeVal.text = zipCodeName
        }
        if  let phoneNo = shippingDetails.data?.userData?.billing?.phone {
            self.lblPhoneNumberVal.text = phoneNo
        }
        
        if let poNumber: String = dictValue["po_number"] as? String,
            let orderNote: String = dictValue["order_note"] as? String,
            let deliverDateStr: String = dictValue["delivery_date"] as? String {
            
            //         self.lblFirstNameVal.text = firstName
            //         self.lblLastNameVal.text = lastName
            //         self.lblCompanyVal.text = cmpanyName
            //         self.lblStreetAddressVal.text = streetName
            //         self.lblCityVal.text = cityName
            //         self.lblStateVal.text = stateName
            //         self.lblZipCodeVal.text = zipCodeName
            //         self.lblPhoneNumberVal.text = phoneNo
            
            if !orderNote.isEmpty || orderNote != "" {
                if orderNote.lowercased().trim().contains("please enter note.") {
                    self.txtCommentView.text = ""
                } else {
                    self.txtCommentView.text = orderNote
                }
            }
            self.txtPO.text = poNumber
            self.btnDeliveryDate.isUserInteractionEnabled = false
            if !deliverDateStr.isEmpty || deliverDateStr != "" {
                self.btnDeliveryDate.setTitle(" "+deliverDateStr, for: .normal)
            } else {
                self.btnDeliveryDate.setTitle("", for: .normal)
            }
        }
    }
    
    func popBack<T: UIViewController>(toControllerType: T.Type) {
        if var viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            viewControllers = viewControllers.reversed()
            for currentViewController in viewControllers {
                if currentViewController .isKind(of: toControllerType) {
                    self.navigationController?.popToViewController(currentViewController, animated: true)
                    break
                }
            }
        }
    }
}

extension OrderReviewViewController: ProcessCheckOutProtocol {
    func onProcessCheckOutSuccess() {
        getCartCountStatusFromServer()
        DispatchQueue.main.async {
            self.manageSalesPersonVisibility()
            self.goToPaymentSuccessScreen()
        }
    }
    
    func manageSalesPersonVisibility() {
        if let adminSalesDetails = UserDefaults.standard.retrieve(object: LoginResponse.self, fromKey: "adminSalesDetails") {
            if let isSalesPerson: Bool = adminSalesDetails.data?.customer?.salePerson {
                if isSalesPerson {
                    UserDefaults.standard.set(true, forKey: "adminLogin")
                }
            }
        }
    }
    
    func getCartCountStatusFromServer() {
        guard let cartDetails: AddToCartResponse = UserDefaults.standard.retrieve(object: AddToCartResponse.self, fromKey: "cartDetails") else { return }
        guard let cartId: String = cartDetails.cartID?.cartId else { return }
        self.checkOutviewModel?.cartCountRequest.cartId = cartId
        self.checkOutviewModel?.cartCountRequest.customerId = self.userId
        self.checkOutviewModel?.getCartCountStatus()
    }
    
    func onCartCountSuccess(cartCount: Int) {
        DispatchQueue.main.async {
            if cartCount > 0 {
                self.tabBarController?.tabBar.items?[2].badgeColor = ColorConstants.APPBLUECOLOR
                self.tabBarController?.tabBar.items?[2].badgeValue = cartCount.description
            } else {
                self.tabBarController?.tabBar.items?[2].badgeColor = nil
                self.tabBarController?.tabBar.items?[2].badgeValue = nil
            }
        }
    }
    
    func onProcessCheckOutFailure(errorMsg: String, code : String) {
        DispatchQueue.main.async {
            var alertTitle: String = ""
            if code == "product out of stock error" {
                alertTitle = NSLocalizedString("OUT_OF_STOCK_TITLE", comment: "")
                self.showOutOfStockAlert(title: alertTitle, errorMsg: errorMsg)
            } else {
                alertTitle = NSLocalizedString("ALERT_ERROR_TITLE", comment: "")
                BaseViewController.showBasicAlert(message: errorMsg, title: alertTitle)
            }
        }
    }
    
    func showOutOfStockAlert(title:String, errorMsg: String) {
        let alert = UIAlertController(title: title, message: errorMsg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
            self.popBack(toControllerType: MyCartViewController.self)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func goToPaymentSuccessScreen() {
        guard let orderSuccessMsg: String = self.checkOutviewModel?.processCheckOutResponse?.message else { return }
        self.view.makeToast(orderSuccessMsg,
                            duration: 2.0,
                            position: .bottom)
        
        let orderSuccessVC: OrderSuccessViewController =
            (UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD,
                               bundle: Bundle.main).instantiateViewController(withIdentifier:
                                VCIDENTIFIER.ORDERSUCCESSVC) as? OrderSuccessViewController)!
        self.navigationController?.pushViewController(orderSuccessVC, animated: true)
        // }
    }
}

