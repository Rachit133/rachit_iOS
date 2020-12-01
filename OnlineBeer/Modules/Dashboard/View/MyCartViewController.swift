//
//  MyCartViewController.swift
//  Beer Connect
//
//  Created by Synsoft on 24/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit
import Toast_Swift
import SDWebImage

class MyCartViewController: BaseViewController {
    
    //var viewCartRequest = ViewCartRequest()
    var viewCartResponse: ViewCartResponse?

   @IBOutlet weak var btnProceedToCheckOut: UIButton!
   @IBOutlet weak var lblSubTitle: UILabel!
   @IBOutlet weak var lblDiscount: UILabel!
   @IBOutlet weak var lblTotal: UILabel!
   @IBOutlet weak var lblSubTitleVal: UILabel!
   @IBOutlet weak var lblDiscountVal: UILabel!
   @IBOutlet weak var lblTotalVal: UILabel!
   @IBOutlet weak var lblAmountSaved: UILabel!
   @IBOutlet weak var myCartTableView: UITableView!
   //   @IBOutlet weak var removeAllBtn: UIButton!
   @IBOutlet weak var imgEmptyCart: UIImageView!
   @IBOutlet weak var btnContinueShopping: UIButton!
    @IBOutlet weak var backDiscountView: UIView!

   var viewModel: MyCartViewModel?
   var dashboardViewModel: DashboardViewModal?
   var updateViewModel: UpdateCartViewModel?
   var removeItemViewModel: RemoveItemViewModel?
   var deleteCartItemModel: DeleteCartViewModel?
   let appDelegate = UIApplication.shared.delegate as? AppDelegate

   var counter = 1
   var minCounter = 10
   var currencySymbol = "$"
   var successMsg = ""
   
   override func viewDidLoad() {
      super.viewDidLoad()
    }
   
   override func viewWillAppear(_ animated: Bool) {
      NetworkManager.shared.checkInternetConnectivity()
      self.lblAmountSaved.isHidden = true
      self.backDiscountView.isHidden = true
      initializeViewModel()
      self.manageNavigationUI()
      initComponents()
   }
   
   func removeNotification() {
      NotificationCenter.default.removeObserver(self, name: Notification.Name("MyCart"), object: nil)
   }
   
   @IBAction func continueShoppingMethodAction(_ sender: UIButton) {
      self.tabBarController?.selectedIndex = 0
   }
}

// MARK: INIT COMPONENTS & OTHER OPERATIONS
extension MyCartViewController {
   
   func initComponents() {
      self.manageNavigationComponent()
      managePullToRefresh()
      self.myCartTableView.isHidden = true
      getMyCartProducts()
   }
    
   func managePullToRefresh() {
       self.refreshControl.addTarget(self, action: #selector(refresh),
                                          for: UIControl.Event.valueChanged)
      self.myCartTableView.addSubview(refreshControl)
    }
   
    @objc func refresh(sender:AnyObject?) {
        self.getMyCartProducts()
    }
    
   func manageNavigationComponent() {
      //var isRemoveBtnHide: Bool = true
        self.navigationController?.navigationBar.isHidden = false
      if self.viewModel?.arrMyCartProducts?.count ?? 0 > 0 {
             self.setNavigationRightBarButton(viewController: self,isImage: true, imageName: "deletecart", target: self, selector: #selector(self.removeAllCartItems(_:)))

      } else {
           self.navigationItem.rightBarButtonItem = nil
      }
      
   }
   
   func initializeViewModel() {
      self.viewModel = MyCartViewModel(delegate: self)
      self.dashboardViewModel = DashboardViewModal(delegate: self)
      self.updateViewModel = UpdateCartViewModel(delegate: self)
      self.removeItemViewModel = RemoveItemViewModel(delegate: self)
      self.deleteCartItemModel = DeleteCartViewModel(delegate: self)
   }
   
   func getMyCartProducts() {
    if UserDefaults.standard.isKeyPresentInUserDefaults(key: "cartDetails") {
        if let productDetails = UserDefaults.standard.retrieve(object: AddToCartResponse.self, fromKey: "cartDetails") {
           if let cardId: String = productDetails.cartID?.cartId {
              viewModel?.viewCartRequest.cardId = cardId
           }
        }
     }
    if UserDefaults.standard.isKeyPresentInUserDefaults(key: "loginUser") {
        if let loginDetails = UserDefaults.standard.retrieve(object:
           LoginResponse.self,
                                                             fromKey: "loginUser") {
           if let customerId = loginDetails.data?.customer?.customerID {
              viewModel?.viewCartRequest.customerId = customerId
           }
        }
    }
    self.viewModel?.getMyCartProductFromServer()
   }
   
   func manageNavigationUI(){
      self.appDelegate?.navigationController?.navigationBar.isHidden = true
      BaseViewController.showHideRootNavigationBar(isVisible: false)
      self.setNavigationLeftBarButton(viewController: self, isImage: true, imageName: "back", target: self, selector:  #selector(backMethodAction(_:)))
      self.tabBarController?.tabBar.isHidden = false
      self.navigationController?.navigationItem.title = NSLocalizedString("MY_CART_TITLE", comment: "")
      if #available(iOS 11.0, *) {
         self.navigationController?.navigationBar.prefersLargeTitles = true
         self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorConstants.APPBLUECOLOR,
         NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Bold", size: 34)!]
      }
   }
   
   @objc func backMethodAction(_ sender: UIButton) {
      self.tabBarController?.selectedIndex = 0
      //self.navigationController?.popViewController(animated: true)
   }
   
}

// MARK: TABLEVIEW DELEGATE & DATASOURCE METHODS
extension MyCartViewController: UITableViewDelegate, UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return self.viewModel?.viewCartResponse?.data?.products?.count ?? 0
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let myCartCell = tableView.dequeueReusableCell(withIdentifier:
         TABLEVIEWCELLID.MYCARTDETAILCELLID,
                                                     for: indexPath) as? MyCartDetailCell
      
      myCartCell?.delegate = self
      myCartCell?.btnAddQuantity.tag = 1111
      myCartCell?.btnSubtractQuantity.tag = 0000
      
      myCartCell?.backView.layer.cornerRadius = 8
      myCartCell?.backView.layer.masksToBounds = false
      myCartCell?.backView.layer.applySketchShadow(
         color: UIColor.black8,
         alpha: 1,
         x: 0,
         y: 4,
         blur: 23,
         spread: 0)
      
      
      let productDetails = self.viewModel?.viewCartResponse?.data?.products?[indexPath.row]
      
      if let currSym = productDetails?.currencySymbol {
         self.currencySymbol = currSym
      }
      
      if let productId = productDetails?.productID {
         myCartCell?.productId = productId
      }
      
      if let productName  = productDetails?.productName {
         myCartCell?.lblTitle.text = productName
      }
      
    DispatchQueue.main.async {
        if let productImage = productDetails?.productImage {
           myCartCell?.titleImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
           myCartCell?.titleImage.sd_setImage(with: URL(string: productImage), placeholderImage:  UIImage(named: "catDefault"),
           options: [.continueInBackground, .delayPlaceholder],
           completed: nil)
        } else {
            myCartCell?.titleImage.image = UIImage(named: "catDefault")
        }
    }
      
      if let quantity = productDetails?.quantity {
         myCartCell?.lblQuantityCount.text = quantity.description
      }
    
      
      if let price = productDetails?.productPrice {
        
        if let originalPrice = productDetails?.origionalPrice {
            
            if price != originalPrice {
                
                let attributeString1: NSMutableAttributedString =  NSMutableAttributedString(string: "  \(self.currencySymbol)"+price )
                
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(self.currencySymbol)"+originalPrice)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                
                let combination = NSMutableAttributedString()

                combination.append(attributeString)
                combination.append(attributeString1)
                myCartCell?.lblPrice.attributedText = combination

            } else {
                myCartCell?.lblPrice.text = "\(self.currencySymbol)"+price
            }
        } else {
            myCartCell?.lblPrice.text = "\(self.currencySymbol)"+price
        }
      }
      
      if let subtotal = productDetails?.productSubtotal {
         myCartCell?.lblTotal.text =
            NSLocalizedString("TOTAL_TITLE", comment: "")+self.currencySymbol+subtotal
      }
    
      if let discount = productDetails?.productDiscount , discount != "" {
            myCartCell?.lblDiscount.text = discount
      } else {
            myCartCell?.lblDiscount.text = ""
      }
    
    if let outOfStock = productDetails?.outofstockstatus {
        if outOfStock {
             myCartCell?.viewOutOfStock.isHidden = false
            myCartCell?.lblOutOfStockMessage.text = NSLocalizedString("OUTOFSTOCK", comment: "")
        } else {
             myCartCell?.viewOutOfStock.isHidden = true
        }
    } else {
        myCartCell?.viewOutOfStock.isHidden = true
    }
      
      return myCartCell ?? UITableViewCell.init()
   }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var productId: String = ""
        let productDetails = self.viewModel?.viewCartResponse?.data?.products?[indexPath.row]
        if let cartProductId = productDetails?.productID?.description {
            if !cartProductId.isEmpty {
                productId = cartProductId
            }
        }
        self.navigateToProductDetailScreen(cartProductId: productId)
    }
    
    func navigateToProductDetailScreen(cartProductId: String) {
        let productDetailVC: ProductDetailViewController =
            (UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD,
                               bundle: Bundle.main).instantiateViewController(withIdentifier:
                                VCIDENTIFIER.PRODUCTDETAILVC) as? ProductDetailViewController)!
        productDetailVC.mainProductId = cartProductId
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }

}

// MARK: MANAGE MY CART RESPONSE
extension MyCartViewController: MyCartProtocol {
   func getCartCountStatus(count: Int) {
      //DispatchQueue.main.async {
      //   self.tabBarController?.tabBar.items?[2].badgeColor = ColorConstants.APPBLUECOLOR
      //   self.tabBarController?.tabBar.items?[2].badgeValue = count.description
      // }
   }
   
   
   func onReceivedMyCartSuccess() {
     self.fetchTotalCardCountFromServer()
      DispatchQueue.main.async {
         if self.viewModel?.arrMyCartProducts?.count ?? 0 > 0 {
            self.refreshControl.endRefreshing()
            self.imgEmptyCart.isHidden = true
            self.btnContinueShopping.isHidden = true
            self.manageScreenVisibality(isViewHide: false)
            self.refreshMyCartScreen()
         } else {
            self.refreshControl.endRefreshing()
            self.imgEmptyCart.isHidden = false
            self.btnContinueShopping.isHidden = false
            self.manageScreenVisibality(isViewHide: true)
         }
        
        self.manageNavigationComponent()
      }
   }
   
   func fetchTotalCardCountFromServer() {
      
    if UserDefaults.standard.isKeyPresentInUserDefaults(key: "loginUser") {
        if let loginDetails = UserDefaults.standard.retrieve(object:
           LoginResponse.self,
                                                             fromKey: "loginUser") {
           if let customerId = loginDetails.data?.customer?.customerID {
              dashboardViewModel?.cartCountRequest.customerId = customerId
              dashboardViewModel?.cartCountRequest.cartId = customerId
           }
        }
        self.dashboardViewModel?.getCartCountStatus()
     }
   }
   
   func manageScreenVisibality(isViewHide: Bool) {
      
      self.myCartTableView.isHidden = isViewHide
      self.btnProceedToCheckOut.isHidden = isViewHide
      self.lblSubTitle.isHidden = isViewHide
      self.lblDiscount.isHidden = isViewHide
      self.lblTotal.isHidden = isViewHide
      // self.removeAllBtn.isHidden = isViewHide
   }
   
   func refreshMyCartScreen() {
      var symbol = NSLocalizedString("DOLLER_SYM", comment: "")
      if let currencySymbol = self.viewModel?.viewCartResponse?.data?.currencySymbol {
         symbol = currencySymbol
      }
      
      if let cartSubTotal = self.viewModel?.viewCartResponse?.data?.cartSubtotal {
         self.lblSubTitleVal.text = symbol+cartSubTotal
      }
      
      if let totalVal = self.viewModel?.viewCartResponse?.data?.cartTotal {
         self.lblTotalVal.text = symbol+totalVal
      }
      
      //if let discountAmt = //self.viewModel?.viewCartResponse?.data?.discountAmount {
        // self.lblDiscountVal.text = symbol+discountAmt
      //}
    
     if let amountSaved = self.viewModel?.viewCartResponse?.data?.amountSaved {
        if !amountSaved.isEmpty {
            self.backDiscountView.isHidden = false
            self.lblAmountSaved.isHidden = false
            self.lblAmountSaved.text = amountSaved
        } else {
            self.lblAmountSaved.text = ""
            self.backDiscountView.isHidden = true
            self.lblAmountSaved.isHidden = true
        }
        
        
        //self.lblAmountSaved.text = amountSaved
     }
    
      self.myCartTableView.reloadData()
   }
   
   func onFailure(errorMsg: String) {
      DispatchQueue.main.async {
         self.view.makeToast(errorMsg, duration: 2.0, position: .bottom)
         self.successMsg = ""
      }
   }
}

// MARK: MANAGE MY CART CELL RESPONSE
extension MyCartViewController: MyCartDetailProtocol {
   
   func deleteCurrentProduct(cartCell: MyCartDetailCell) {
      let alertController = UIAlertController(title: NSLocalizedString("DELETE_TITLE", comment: "")
, message: NSLocalizedString("DELETE_MESSAGE", comment: ""), preferredStyle: .alert)
      
      // Create the actions
      let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default) {
         UIAlertAction in
        
        if UserDefaults.standard.isKeyPresentInUserDefaults(key: "loginUser") {
            if let loginDetails = UserDefaults.standard.retrieve(object:
               LoginResponse.self,
                                                                 fromKey: "loginUser") {
               if let customerId = loginDetails.data?.customer?.customerID {
                  self.removeItemViewModel?.removeItemRequest.customerId = customerId
                  self.removeItemViewModel?.removeItemRequest.productId = String(cartCell.productId)
               }
               self.removeItemViewModel?.removeItemFromServer()
            }
        }
      }
      
      let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""), style: UIAlertAction.Style.cancel) {
         UIAlertAction in
         //NSLog("Cancel Pressed")
      }
      
      // Add the actions
      alertController.addAction(okAction)
      alertController.addAction(cancelAction)
      
      // Present the controller
      self.present(alertController, animated: true, completion: nil)
   }
   
   func getCartDetails(cartCell: MyCartDetailCell) {
      if let loginDetails = UserDefaults.standard.retrieve(object:
         LoginResponse.self,
                                                           fromKey: "loginUser") {
         if let customerId = loginDetails.data?.customer?.customerID {
            self.updateViewModel?.updateCartRequest.customerId = customerId
         }
         
      }
      
      if cartCell.btnAddQuantity.tag == 1111 {
         if let addCounter = cartCell.lblQuantityCount.text {
            
            let addQty = (addCounter as NSString).integerValue
            //print("Add Val \(String(describing: addQty))")
            
            self.updateViewModel?.updateCartRequest.quantity = addQty
            self.updateViewModel?.updateCartRequest.productId = cartCell.productId
            self.updateViewModel?.updateCartProductFromServer()
         }
      } else if cartCell.btnSubtractQuantity.tag == 0000 {
         
         if let minusCounter = cartCell.lblQuantityCount.text {
            let substractQty = (minusCounter as NSString).integerValue
            self.updateViewModel?.updateCartRequest.quantity = substractQty
            self.updateViewModel?.updateCartRequest.productId = cartCell.productId
            self.updateViewModel?.updateCartProductFromServer()
         }
      }
   }
   
   func onErrorRecieved(errorMsg: String) {
      DispatchQueue.main.async {
         self.view.makeToast(errorMsg, duration: 2.0, position: .bottom)
         self.successMsg = ""
      }
      
   }
   
}


// MARK: Update MY CART PRODUCT QUANTITY
extension MyCartViewController: UpdateCartProtocol {
   func onReceivedUpdateCartSuccess() {
      
      if let msg = self.updateViewModel?.successMsg {
         self.successMsg = msg
      }
      
      self.refreshMyCardScreen()
   }
   
   func onUpdateCartFailure(errorMsg: String) {
      DispatchQueue.main.async {
         self.view.makeToast(errorMsg, duration: 2.0, position: .bottom)
         self.successMsg = ""
      }
   }
   
   func refreshMyCardScreen() {
      getMyCartProducts()
   }
}

// MARK: REMOVE PRODUCT RESPONSE
extension MyCartViewController: RemoveItemProtocol {
   func onReceivedRemoveItemSuccess() {
      
      if let msg = self.removeItemViewModel?.successMsg {
         self.successMsg = msg
      }
      refreshMyCardScreen()
   }
   
   func onRemoveItemFailure(errorMsg: String) {
      DispatchQueue.main.async {
         self.view.makeToast(errorMsg, duration: 2.0, position: .bottom)
         self.successMsg = ""
      }
   }
}

// MARK: DELETE CART RESPONSE
extension MyCartViewController: DeleteCartProtocol {
   
   @objc func removeAllCartItems(_ sender: UIButton) {
      let alertController = UIAlertController(title:
        NSLocalizedString("DELETE_TITLE",                                                                       comment: "")
, message: NSLocalizedString("DELETE_CART_MESSAGE", comment: ""),
  preferredStyle: .alert)
      
      // Create the actions
      let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default) {
         UIAlertAction in
         if let loginDetails = UserDefaults.standard.retrieve(object:
            LoginResponse.self,
                                                              fromKey: "loginUser") {
            
            if let customerId = loginDetails.data?.customer?.customerID {
               self.deleteCartItemModel?.deleteCartRequest.customerId = customerId
            }
            
            if let customerId = loginDetails.data?.customer?.customerID {
               self.viewModel?.cartCountRequest.customerId = customerId
               self.viewModel?.cartCountRequest.cartId = customerId
               self.viewModel?.getCartCountStatus()
            }
            self.deleteCartItemModel?.deleteCartFromServer()
         }
      }
      
      let cancelAction = UIAlertAction(title: NSLocalizedString("CANCEL", comment: ""), style: UIAlertAction.Style.cancel) {
         UIAlertAction in
         //NSLog("Cancel Pressed")
      }
      alertController.addAction(okAction)
      alertController.addAction(cancelAction)
      self.present(alertController, animated: true, completion: nil)
      
      
   }
   
   func onReceivedDeleteCartSuccess() {
   
      DispatchQueue.main.async {
        self.clearAllSavedShippingData()
         if let msg = self.deleteCartItemModel?.successMsg {
            self.successMsg = msg
         }
         self.tabBarController?.tabBar.items?[2].badgeColor = nil
         self.tabBarController?.tabBar.items?[2].badgeValue = nil
      }
      refreshMyCardScreen()
   }
    
   func clearAllSavedShippingData() {
      UserDefaults.standard.removeObject(forKey: "shippingDetails")
      UserDefaults.standard.removeObject(forKey: "shippingData")
      UserDefaults.standard.synchronize()
   }
   
   func onDeleteCartFailure(errorMsg: String) {
      DispatchQueue.main.async {
         self.view.makeToast(errorMsg, duration: 2.0, position: .bottom)
         self.successMsg = ""
      }
   }
}
 
extension MyCartViewController {
   @IBAction func proceedToNextScreen(_ sender: UIButton) {
      viewCartResponse = ViewCartResponse.init()
      NetworkManager.shared.makeRequestToServer(for: VIEWCART,
                                                     method: .POST,
                                                     params: viewModel?.viewCartRequest.dictionary ?? [:],
                                                     isActivityShow: true,
                                                     completionSuccess: { (viewCartData) in
                                                        
                                                        if viewCartData != nil {
                                                           self.viewCartResponse = self.viewCartResponse?.getMyCartDetailsFrom(repsonseData: viewCartData ?? Data.init())
                                                           if self.viewCartResponse != nil {
                                                              DispatchQueue.main.async {
                                                                if self.viewCartResponse?.data?.outofstockstatus ?? false {
                                                                    BaseViewController.showBasicAlert(message: self.viewCartResponse?.data?.outofstockmsg ?? "")
                                                                } else {
                                                                    let shippingDetailsVC: ShippingDetailsViewController =
                                                                       (UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD,
                                                                                          bundle: Bundle.main).instantiateViewController(withIdentifier:
                                                                                            VCIDENTIFIER.SHIPPINGDETAILSVCID) as? ShippingDetailsViewController)!
                                                                    self.navigationController?.pushViewController(shippingDetailsVC, animated: true)
                                                                }
                                                            }
                                                            
                                                           } else {
                                                             
                                                           } } else {
                                                          
                                                        }
           }) {(errorObj) in
              print("Failure Response is \(errorObj.localizedDescription)")
           }
   }
}


extension MyCartViewController: DashboardProtocol {
   func onCartFailure(errorMsg: String) {
      DispatchQueue.main.async {
         self.tabBarController?.tabBar.items?[2].badgeColor = .clear
         self.tabBarController?.tabBar.items?[2].badgeValue = nil
      }
   }
   
   func onRecievedWishlistResponse() {}
   
   func onRecievedProductsSuccess() {}
   
   func onCartCountSuccess(cartCount: Int) {
    
     if let addedProducts = self.viewModel?.viewCartResponse?.data?.products {
        var dict:[String:String] = [:]
        for productData in addedProducts {
            let productId = String(productData.productID ?? 0)
            dict[productId] = String(productData.quantity ?? 0)
        }
         UserDefaults.standard.set(dict, forKey: "addedCartValue")
     }
    
      DispatchQueue.main.async {
         if cartCount != 0{
            self.tabBarController?.tabBar.items?[2].badgeColor = ColorConstants.APPBLUECOLOR
            self.tabBarController?.tabBar.items?[2].badgeValue = cartCount.description
         } else {
            self.clearAllSavedShippingData()
            self.tabBarController?.tabBar.items?[2].badgeColor = nil
            self.tabBarController?.tabBar.items?[2].badgeValue = nil
         }
         if !self.successMsg.isEmpty {
            self.view.makeToast(self.successMsg, duration: 2.0, position: .bottom)
            self.successMsg = ""
         }
      }
   }
}
