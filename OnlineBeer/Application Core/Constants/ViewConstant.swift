//
//  ViewConstant.swift
//  CVDelight_Partner
//
//  Created by Apple on 19/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

// MARK: Storyboard Constant
struct STORYBOARDCONS {
    static let MAIN = "Main"
    static let LOGIN = "Login"
    static let POPUP = "PopUp"
    static let COMMON = "Common"
    static let ONBOARD = "OnBoard"
    static let ORDER = "Order"
    static let NOTIFICATION = "Notification"

    // MARK: TabBar ViewController
    static let DASHBOARD   = "Dashboard"
}

// MARK: View controllers with VC identifier
struct VCIDENTIFIER {
    
    // MARK: Login ViewController
    static let LOGINVC    = "loginVCID"
    static let FORGOTVC = "forgotPasswordVC"
    static let FORGOTMPINCONTROLLER       = "forgotMpinVCID"
    static let FORGOTMPINOTPCONTROLLER    = "forgotMpinOTPVCID"
    static let SETNEWMPINCONTROLLER       = "resetMpinVCID"
    static let REGISTRATIONVC             = "registrationVCID"
    static let SUBCATEGORYVC              = "subCatVCID"

    // MARK: PopUp ViewController
    static let POPUPVC = "PopUpVCID"
    static let UPLOADVC = "uploadInvoicePopUpVCID"
    
    // MARK: Dashboard ViewController
    static let DASHBOARDVC    = "dashboardVCID"
    static let TRANSACTIONVC  = "transactionsVCID"
    static let PROFILEVC      = "userProfileVCID"
    static let USERPROFILEVC  = "profileVCID"
    static let SIDEMENUVC     = "sideMenuVCID"
    static let SEARCHVC       = "searchVCID"
    static let CUSTOMTABBARVC = "customTabBarVCID"
    static let ADDTOCARTVC    = "addCartVCID"
    static let WISHLISTVC     = "wishlistVCID"
    static let ACCOUNTVC      = "accountVCID"
    static let MYCARTVC       = "myCartVCID"
    static let PRODUCTDETAILVC = "productDetailVCID"
    static let ADDTOCARTPOPUPVCID = "addToCartVCID"
    static let SHIPPINGDETAILSVCID = "shippingDetailsVCID"
    static let PAYMENTMETHODVCID = "paymentMethodVCID"
    static let ORDERREVIEWVCID  = "orderReviewVCID"
    static let DASHBOARDNAVVC = "dashboardNavVCID"
    static let ORDERSUCCESSVC = "orderSuccessVCID"
    static let CALENDERPOPUPVC = "calenderPopUpVCID"
    static let SORTVCID = "sortVCID"
    static let ORDERLISTVC = "orderListVCID"
    static let ORDERDETAILVC = "orderDetailVCID"
    static let SETTINGVC = "settingVCID"
    static let NOTIFICATIONVC = "notificationVCID"
    static let CUSTOMERLISTVC = "customerListVCID"
    static let FILTERVC = "filterVCID"
    static let PRODUCTLISTVC = "productListVCID"
    static let PDFVC = "pdfVCID"

}

// MARK: Table View Cell Identifier
struct TABLEVIEWCELLID {
    
    //Registration Header Information
    static let REGISTRATIONINFOHEADERID = "registrationInfoHeaderCell"
    
    //Registration Information Identifier
    static let MEMBERSHIPINFOCELLID = "membershipInfoCellID"
    static let LOGININFOCELLID = "loginInfoCellID"
    static let CONTACTINFOCELLID = "contactInfoCellID"
    static let SEARCHPRODUCTCELLID = "searchProductCellID"

    // MARK: Dashboard cell
    //static let CATEGORYCELLID = "categoryMainCellID"
    static let BESTCATCELLID = "bestCategoryCellID"
   
    // MARK: Profile Cell
    static let MYDETAILSCELLID         = "myDetailsCell"
    static let PROFILEOPTIONCELLID     = "profileOptionCellID"
    static let DEALERPRODUCTCELLID     = "dealProductCellID"
    
    // MARK: Transactions Cell
    static let TRANSACTIONCELLID      = "transactionDetailsCell"
    static let VEHICLEDETAILSCELLID   = "vehicleDetailsCell"
    static let USERDETAILSCELLID      = "userDetailsCell"
    
    // MARK: Transactions History Cell
   static let MYCARTDETAILCELLID        = "myCartDetailCellID"
   static let PAYMENTMETHODCELLID       = "paymentCellID"
   static let FETCHWISHLISTCELLID       = "fetchWishlistCellID"
   static let SORTVIEWCELLID            = "sortCellID"
   static let ORDERLISTCELLID           = "orderListCellID"
   static let ORDERDETAILCELLID         = "orderDetailCellID"
   static let FILTERVIEWCELL            = "filterViewCell"
   static let REFUNDINFOCELLID          = "refundInfoCellID"

    
   // Product Details
    static let PRODUCTDETAILTOPCELLID     = "priceDetailTopCellID"
    static let PRODUCTDETAILIMAGECELLID   = "priceDetailImageCellID"
    static let PRODUCTDETAILADDTOCARTCELLID   = "priceDetailAddToCartCellID"
    static let PRODUCTDETAILPRICECELLID   = "priceDetailPriceCellID"
    static let PRODUCTDETAILINFOCELLID   = "productDetailInfoCellID"
    
    static let PRODUCTDETAILVIDEOCELLID   = "productDetailVideoCell"
    static let PRODUCTDETAILDESCRIPTIONCELLID   = "productDetailDescriptionCell"
    static let PRODUCTDETAILTYPECELLID = "productDetailTypeCellID"
   static let PRODUCTEXTRADETAILCELLID = "productExtraDetailCellID"
    static let PRODUCTADDTOCARTCELLID = "addToCartCellID"
    
   static let SIMILARPRODUCTCELL = "similarProductCell"

    static let NOTIFICATIONCELLID = "notificationCellID"
    //productExtraDetailCellID
}
// MARK: Table View Cell Identifier
struct COLLECTIONVIEWCELLID {
    // MARK: Upload Document cell
    static let UPLOADINVOICECELLID      = "uploadInvoiceCell"
    static let CATEGORYCOLLECTIONCELLID = "categoryCellID"
    static let BESTSELLERCATCELLID      = "bestSellerCatCellID"
    static let CATCOLLECTIONCELLID      = "catCollectionCellID"
}
