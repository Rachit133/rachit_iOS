//
//  ShippingDetailsViewController.swift
//  Beer Connect
//
//  Created by Synsoft on 26/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit
import SwiftyJSON

class ShippingDetailsViewController: BaseViewController {
    
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
    @IBOutlet weak var btnProceed: UIButton!
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
    @IBOutlet weak var lblNotePlaceHolder: UILabel!
    @IBOutlet weak var shippingDetailTableView: UITableView!
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var viewModal: ShippingDetailsViewModel?
    var selectedDateStr: String? = ""
    var dateFormatter: DateFormatter?
    var timeSlotArray: [String:String]?
    var countries = [String].init()
    
    var selectedDate = Date()
    var minimumDate = Date()
    var maximumDate = Date()
    
    var globalTextFieldTag = 0
    var formattedDate = "";
    var userId: String? = ""
    var cartId: String? = ""
    var selectedDatStr: String = Date.init().toString(dateFormat: "MM/dd/yyyy")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.btnDeliveryDate.setTitle(NSLocalizedString("DATE_SELECT_TITLE", comment: ""), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NetworkManager.shared.checkInternetConnectivity()
        manageShadowOfView()
        manageNavigationBar()
        initComponents()
        populateTextViewData()
    }
    
    func getCartDetails() {
        if let cartDetails = UserDefaults.standard.retrieve(object: AddToCartResponse.self, fromKey: "cartDetails") {
            if let cartID: String = cartDetails.cartID?.cartId {
                self.cartId = cartID
            }
        }
    }
    
    
    func populateTextViewData() {
        //guard let dictValue = (UserDefaults.standard.value(forKey: "shippingData") as? Parameter) else { return }
        self.txtPONumber.keyboardType = .default
        
        guard let shippingDetailsValue: Parameter? = (UserDefaults.standard.value(forKey: "shippingData") as? Parameter?) else { return }
        
        if !(shippingDetailsValue?.isEmpty ?? false) && shippingDetailsValue?.count ?? 0 > 0 {
            
            if let poNumber =  shippingDetailsValue?["po_number"] as? String {
                if !poNumber.isEmpty {
                    self.txtPONumber.text = poNumber
                }
            }
            
            if let orderNoteStr =  shippingDetailsValue?["order_note"] as? String {
                if !orderNoteStr.isEmpty {
                    self.lblNotePlaceHolder.isHidden = true
                    self.txtCommentView.text = orderNoteStr
                }
            }
            
            if let deliveryDateStr = shippingDetailsValue?["delivery_date"] as? String {
                if !deliveryDateStr.isEmpty {
                    self.btnDeliveryDate.setTitle(deliveryDateStr, for: .normal)
                }
            }
        
        }
        
        // self.txtCommentView.text = ""
        //  self.txtCommentView.textColor = UIColor.lightGray
        //  self.txtCommentView.text = "Please enter note."
        
//        if UserDefaults.standard.isKeyPresentInUserDefaults(key: "shippingData") {
//            if let shiipingData = UserDefaults.standard.value(forKey: "shippingData") as? Parameter {
//                if shiipingData.count > 0 {
//                    self.txtCommentView.text = shiipingData["order_note"] as? String
//                    self.txtCommentView.textColor = UIColor.black
//                    if (self.txtCommentView.text != "") {
//                        self.lblNotePlaceHolder.isHidden = true
//                    }
//                }
//            }
//        }
        
    }
    
}

extension ShippingDetailsViewController {
    func initComponents() {
        initializeViewModel()
        getCartDetails()
        getShippingDetailsFromServer()
    }
    
    func initializeViewModel() {
        self.viewModal = ShippingDetailsViewModel(delegate: self)
    }
    
    func getShippingDetailsFromServer() {
        if let loginDetails = UserDefaults.standard.retrieve(object: LoginResponse.self, fromKey: "loginUser") {
            if let customerID: String = loginDetails.data?.customer?.customerID {
                self.userId = customerID
                self.viewModal?.shippingDetailRequest.customerId = customerID
                self.viewModal?.getShippingDetailsProductFromServer()
            }
        }
    }
}

// MARK: Manage  Shipping Detail Screen
extension ShippingDetailsViewController {
    
    func manageShadowOfView() {
        self.backgroundShippingView.layer.applySketchShadow(
            color: UIColor.black22,
            alpha: 1,
            x: 7,
            y: 10,
            blur: 20,
            spread: 0)
    }
    
    func manageNavigationBar() {
        
        if #available(iOS 11.0, *) {
            self.shippingDetailTableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        self.appDelegate?.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        self.setNavigationLeftBarButton(viewController: self, isImage: true, imageName: "back", target: self, selector:  #selector(backMethodAction(_:)))
        self.navigationItem.title = "Shipping Details"
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

extension ShippingDetailsViewController {
    @IBAction func proceedToNextScreen(_ sender: UIButton) {
        
        let firstName = self.lblFirstNameVal.text
        let lastName = self.lblLastNameVal.text
        let cmpanyName = self.lblCompanyVal.text
        let street1Name = self.lblStreetAddressVal.text
        let street2Name = self.lblSuiteUnitVal.text
        let cityName = self.lblCityVal.text
        let zipCodeName = self.lblZipCodeVal.text
        let stateName = self.lblStateVal.text
        let phoneNo = self.lblPhoneNumberVal.text
        let poNumber = self.txtPONumber.text
        let orderNote = self.txtCommentView.text
        
        if firstName?.isEmpty ?? true,
            lastName?.isEmpty ?? true,
            cmpanyName?.isEmpty ?? true,
            street1Name?.isEmpty ?? true,
            street2Name?.isEmpty ?? true,
            cityName?.isEmpty ?? true,
            zipCodeName?.isEmpty ?? true,
            stateName?.isEmpty ?? true,
            phoneNo?.isEmpty ?? true {
            self.view?.makeToast("All fields are required", title: nil,
                                 image: nil,
                                 completion: nil)
            return
        }
        
        self.shippingDict["po_number"] = poNumber
        self.shippingDict["order_note"] = orderNote
        self.shippingDict["delivery_date"] = self.selectedDatStr
        
        if UserDefaults.standard.isKeyPresentInUserDefaults(key: "cartDetails") {
           if let cartDetails = UserDefaults.standard.retrieve(object: AddToCartResponse.self, fromKey: "cartDetails") {
              if let cardId: String = cartDetails.cartID?.cartId {
                if !cardId.isEmpty && cardId.count > 0 {
                    self.cartId = cardId
                }
            }
           }
        }
        
        let deliveryDateStr = self.btnDeliveryDate.titleLabel?.text
        
        if poNumber?.isEmpty ?? false || poNumber == "" {
            BaseViewController.showBasicAlert(message: NSLocalizedString("REQUIRE_PURCASE_ORDER", comment: ""))
            return
        }
        if deliveryDateStr?.lowercased().trim().contains("select date") ?? false {
            BaseViewController.showBasicAlert(message: NSLocalizedString("REQUIRE_DELIVERY_DATE", comment: ""))
            return
        }
        UserDefaults.standard.set(self.shippingDict, forKey: "shippingData")
        UserDefaults.standard.synchronize()
        
        self.viewModal?.shippingSaveRequest.customerId = self.userId
        self.viewModal?.shippingSaveRequest.cartId = self.cartId
        self.viewModal?.shippingSaveRequest.firstName = firstName
        self.viewModal?.shippingSaveRequest.lastName = lastName
        self.viewModal?.shippingSaveRequest.companyName = cmpanyName
        self.viewModal?.shippingSaveRequest.address1 = street1Name
        self.viewModal?.shippingSaveRequest.address2 = street2Name
        self.viewModal?.shippingSaveRequest.city = cityName
        self.viewModal?.shippingSaveRequest.postCode = zipCodeName
        self.viewModal?.shippingSaveRequest.state = stateName
        self.viewModal?.shippingSaveRequest.phone = phoneNo
        self.viewModal?.shippingSaveRequest.poNumber = poNumber
        self.viewModal?.shippingSaveRequest.orderNote = orderNote
        self.viewModal?.saveShippingDetailsToServer()
    }
    
}


extension ShippingDetailsViewController: ShippingDetailsProtocol {
    func onRecievedSaveAddressSuccess(data: Data) {
        DispatchQueue.main.async {
            
            var arrPaymentMethod = [JSON].init()
            do {
                let json  = try JSON(data:data)
                if json["success"].stringValue.lowercased().trim() == NSLocalizedString("TRUE", comment: "") {
                    if let shippingDataDict = json["data"].dictionary {
                        if shippingDataDict.count > 0 {
                            
                            if let arrayGateways = shippingDataDict["gateways"]?.array {
                                if arrayGateways.count > 0  && !arrayGateways.isEmpty {
                                    arrPaymentMethod = arrayGateways
                                } else {
                                    self.view.makeToast(NSLocalizedString("PAYMENT_NOT_FOUND", comment: ""), duration: 1.0, position: .bottom)
                                }
                            } else {
                                self.view.makeToast(NSLocalizedString("GATEWAY_NOT_FOUND", comment: ""), duration: 1.0, position: .bottom)
                            }
                        }
                    }
                    
                    self.gotoPaymentTypeScreen(paymentMethodData: arrPaymentMethod)
                    self.view.makeToast(NSLocalizedString("ADDRESS_ADDED_MESSAGE", comment: ""), point: CGPoint.zero, title: nil, image: nil, completion: nil)
                    
                }
                
            } catch (let error) {
                self.view.makeToast(error.localizedDescription, point: CGPoint.zero, title: nil, image: nil, completion: nil)
            }
        }
    }
    
    func gotoPaymentTypeScreen(paymentMethodData: [JSON]) {
        let paymentMethodVC: PaymentMethodViewController =
            (UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD,
                               bundle: Bundle.main).instantiateViewController(withIdentifier:
                                VCIDENTIFIER.PAYMENTMETHODVCID) as? PaymentMethodViewController)!
        paymentMethodVC.arrPaymentMethods = paymentMethodData
        self.navigationController?.pushViewController(paymentMethodVC, animated: true)
    }
    
    
    func onRecievedShippingDetailsSuccess() {
        DispatchQueue.main.async {
            self.populateShippingDetails()
        }
    }
    
    func onDetailsFailure(errorMsg: String) {
        DispatchQueue.main.async {
            BaseViewController.showBasicAlert(message: errorMsg)
        }
    }
}

// MARK: POPULATE SHIPPING DETAILS TO UI.
extension ShippingDetailsViewController {
    
    func populateShippingDetails() {
        //let dictValue = UserDefaults.standard.value(forKey: "shippingData") as? Parameter
        
        if let firstName = self.viewModal?.shippingDetailResponse?.data?.userData?.shipping?.firstName {
            self.lblFirstNameVal.text = firstName
        }
        if let lastName = self.viewModal?.shippingDetailResponse?.data?.userData?.shipping?.lastName {
            self.lblLastNameVal.text = lastName
        }
        
        if let cmpanyName = self.viewModal?.shippingDetailResponse?.data?.userData?.shipping?.company {
            self.lblCompanyVal.text = cmpanyName
        }
        
        if   let streetName = self.viewModal?.shippingDetailResponse?.data?.userData?.shipping?.address1 {
            self.lblStreetAddressVal.text = streetName
        }
        
        if let address2 = self.viewModal?.shippingDetailResponse?.data?.userData?.shipping?.address2 {
            self.lblSuiteUnitVal.text = address2
        }
         
        if let cityName = self.viewModal?.shippingDetailResponse?.data?.userData?.shipping?.city {
            self.lblCityVal.text = cityName
        }
        
        if let stateName = self.viewModal?.shippingDetailResponse?.data?.userData?.shipping?.state {
            self.lblStateVal.text = stateName
        }
        
        if let zipCodeName = self.viewModal?.shippingDetailResponse?.data?.userData?.shipping?.postcode {
            self.lblZipCodeVal.text = zipCodeName
        }
        
        if let shippingCountry = self.viewModal?.shippingDetailResponse?.data?.userData?.shipping?.country {
            self.viewModal?.shippingSaveRequest.country = shippingCountry
         }
        
        if  let phoneNo = self.viewModal?.shippingDetailResponse?.data?.userData?.billing?.phone {
            self.lblPhoneNumberVal.text = phoneNo
        }
        
        if  let billingFirstName = self.viewModal?.shippingDetailResponse?.data?.userData?.billing?.firstName {
            self.viewModal?.shippingSaveRequest.billingFirstName = billingFirstName
        }
        
        if  let billingLastName = self.viewModal?.shippingDetailResponse?.data?.userData?.billing?.lastName {
            self.viewModal?.shippingSaveRequest.billingLastName = billingLastName
        }
        
        if  let billingCompany =    self.viewModal?.shippingDetailResponse?.data?.userData?.billing?.company {
            self.viewModal?.shippingSaveRequest.billingCompany = billingCompany
        }
        
        if  let billingAddress1 = self.viewModal?.shippingDetailResponse?.data?.userData?.billing?.address1 {
            self.viewModal?.shippingSaveRequest.billingAddress1 = billingAddress1
        }
        
        if  let billingAddress2 = self.viewModal?.shippingDetailResponse?.data?.userData?.billing?.address2 {
            self.viewModal?.shippingSaveRequest.billingAddress2 = billingAddress2
        }
        
        if  let billingCity = self.viewModal?.shippingDetailResponse?.data?.userData?.billing?.city {
            self.viewModal?.shippingSaveRequest.billingCity = billingCity
        }
        
        if  let billingPostCode = self.viewModal?.shippingDetailResponse?.data?.userData?.billing?.postcode {
            self.viewModal?.shippingSaveRequest.billingPostcode = billingPostCode
        }
        
        if  let billingCountry =    self.viewModal?.shippingDetailResponse?.data?.userData?.billing?.country {
            self.viewModal?.shippingSaveRequest.billingCountry = billingCountry
        }
        
        if  let billingState = self.viewModal?.shippingDetailResponse?.data?.userData?.billing?.state {
            self.viewModal?.shippingSaveRequest.billingState = billingState
        }
    }
}

extension ShippingDetailsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard range.location == 0 else {
            return true
        }

        let newString = (textField.text!.stripped as NSString).replacingCharacters(in: range, with: string) as NSString
        return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
    }
}

extension ShippingDetailsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.populateTextViewData()
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        
        if newText.count == 0 {
            lblNotePlaceHolder.isHidden = false
        } else {
            lblNotePlaceHolder.isHidden = true
        }
        
        return true;
    }
}

// MARK: Manage Date Picker Response
extension ShippingDetailsViewController {
    @IBAction func requestDeliveryDateActionMethod(_ sender: UIButton) {
        let calenderPopUpVC: CalenderPopUpViewController =
            (UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD,
                               bundle: Bundle.main).instantiateViewController(withIdentifier:
                                VCIDENTIFIER.CALENDERPOPUPVC) as? CalenderPopUpViewController)!
        self.tabBarController?.tabBar.isHidden = true
        calenderPopUpVC.modalPresentationStyle = .overFullScreen
        calenderPopUpVC.shippingDetailResponse = self.viewModal?.shippingDetailResponse
        calenderPopUpVC.delegate = self
        self.present(calenderPopUpVC, animated: true, completion: nil)
    }
    
    func getWeekDayNo(weekday: String)->String {
        switch(weekday.lowercased()){
        case "sunday":
            return "0"
        case "monday":
            return "1"
        case "tuesday":
            return "2"
        case "wednesday":
            return "3"
        case "thursday":
            return "4"
        case "friday":
            return "5"
        case "saturday":
            return "6"
        default:
            break
        }
        return ""
    }
    
    func getTimeSlots(selectedDate: String) {
        
        self.timeSlotArray = Dictionary<String,String>()
        
        NetworkManager.shared.makeRequestToServer(for: TIMESLOTS,
                                                  method: .POST,
                                                  params: ["selected_date":selectedDate],
                                                  isActivityShow: true,
                                                  completionSuccess: { (getTimeSlotData) in
                                                    
                                                    if let data = getTimeSlotData {
                                                        
                                                        do {
                                                            let json  = try JSON(data:data)
                                                            print(json)
                                                            
                                                            for index in json.arrayValue {
                                                                self.timeSlotArray?[index["format"].stringValue] = index["value"].stringValue
                                                            }
                                                        } catch let error {
                                                            // handle error
                                                            //print("Error is \(error.localizedDescription)")
                                                        }
                                                    }
                                                    
        }) {(errorObj) in
            self.view.makeToast(errorObj.msg,
                                duration: 2.0,
                                position: .bottom)
        }
    }
}

extension ShippingDetailsViewController: FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return maximumDate
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return minimumDate
    }
}

extension ShippingDetailsViewController: CalenderPopUpProtocol {
    func getSelectedDate(selectedDateStr: String) {
        if !selectedDatStr.isEmpty {
            self.selectedDatStr = selectedDateStr
            self.btnDeliveryDate.setTitle("  "+selectedDateStr, for: .normal)
        }
    }
}

