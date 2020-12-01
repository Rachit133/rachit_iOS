//
//  ProductDetailViewController.swift
//  Beer Connect
//
//  Created by Synsoft on 12/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit
import SDWebImage
import WebKit

class ProductDetailViewController: BaseViewController {
    
    @IBOutlet weak var tblProductDetails: UITableView!
    
    var viewModal: ProductDetailViewModel?
    var dashboadViewModal: DashboardViewModal?
    var isStockAvailable: Bool = false
    var productDetail = Product()
    var mainProductId: String = ""
    var userId: String = ""
    var currentIndexPath: IndexPath?
    var arrTableData: [TableData]?
    private let producSpacing:CGFloat = 8
    var reamStockQuantity = 0
    var addedQuantity = 0
    var notificationProductId: String = ""
    var productImage = UIImage.init()
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var similarProductCollectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.checkInternetConnectivity()
        initComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.manageNavigationBar()
        getNotificationEvent()
    }
    
    override func viewDidAppear(_ animated: Bool) {}
    
    func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("Home"), object: nil)
    }
    
    deinit {
        self.removeNotification()
    }
    
    func initComponents() {
        
        self.tblProductDetails.estimatedRowHeight = 300
        self.tblProductDetails.rowHeight = UITableView.automaticDimension
        initializeViewModel()
        //manageWebView()
        //manageSideMenu()
        getProductDetailsFromServer()
    }
    
    func manageWebView() {
        //self.videoPlayer.uiDelegate = self
        //self.videoPlayer.navigationDelegate = self
    }
    
    func getNotificationEvent() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.gotoHome(notification:)), name: Notification.Name("Home"), object: nil)
    }
    
    @objc func gotoHome(notification: Notification) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    func manageProductCollection() {
     //   self.similarProductCollectionView.dataSource = self
     //   self.similarProductCollectionView.delegate = self
        collectionViewFlowLayout?.sectionInset = UIEdgeInsets(top: producSpacing, left: 0, bottom: 0, right: producSpacing)
        collectionViewFlowLayout?.minimumLineSpacing = producSpacing
        collectionViewFlowLayout?.minimumInteritemSpacing = producSpacing
    }
    

    
    func initializeViewModel() {
        viewModal = ProductDetailViewModel(delegate: self, cartDelegate: self)
        dashboadViewModal = DashboardViewModal(delegate: self)
    }
    
    func getProductDetailsFromServer(isNotification: Bool = false) {
        
        var currentUserId: String = ""
        var productId: String = ""
        
        if let loginDetails = UserDefaults.standard.retrieve(object: LoginResponse.self, fromKey: "loginUser") {
            
            if let userId = loginDetails.data?.customer?.customerID {
                if !userId.isEmpty{
                    currentUserId = userId
                }
            }

            if let productsId = productDetail.productID?.description {
                if !productsId.isEmpty{
                    productId = productsId
                }
            }
  
            if self.mainProductId.isEmpty ||  self.mainProductId == "" {
                self.mainProductId = productId
            }
            
            self.userId = currentUserId
            viewModal?.productDetailRequest.customerId = self.userId
            viewModal?.productDetailRequest.customerId = self.userId
            viewModal?.productDetailRequest.productId = self.mainProductId

            if isNotification {
              viewModal?.productDetailRequest.productId = notificationProductId
            }
            
            self.viewModal?.getSingleProductsDetailsFromServer()
        }
    }
    
    func manageNavigationBar() {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.title = productDetail.productName?.uppercased()
        //self.lblStockQauntity.isHidden = true
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorConstants.APPBLUECOLOR,
            NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Bold", size: 34)!]
        }
    }
}

extension ProductDetailViewController: DashboardProtocol {
    func onRecievedProductsSuccess() {}
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
    func onRecievedWishlistResponse() {
        getProductDetailsFromServer()
        DispatchQueue.main.async {
            self.view.makeToast(self.dashboadViewModal?.wishlistResponseMsg,
                                                                duration: 1.0,
                                                                position: .bottom)
            self.tblProductDetails.reloadSections([0],
                                                  with: .automatic)
//            self.tblProductDetails.reloadData()
        }
        
        // self.callbackOnWishListUpdate!()
        NotificationCenter.default.post(name: Notification.Name("refreshWishlist"), object: nil, userInfo: nil)
       
    }
    func onCartFailure(errorMsg: String) {
        DispatchQueue.main.async {
            self.tabBarController?.tabBar.items?[2].badgeColor = .clear
            self.tabBarController?.tabBar.items?[2].badgeValue = nil
        }
    }
}

extension ProductDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if section == 0  {
                        return 1
         }
       else if  section == 1 || section == 2 {
            if self.viewModal?.productDetailResponse.productData != nil {
                 return 1
            }
            return 0
        
        } else if section == 3 {
            if self.arrTableData?.count ?? 0 > 0 {
                //self.tblProductDetails.estimatedRowHeight = 100
                return self.arrTableData?.count ?? 0
            } else { return 0 }
        } else if section == 4 {
            return 1
    } else if section == 5 {
            if self.viewModal?.productDetailResponse.productData?.videoUrl != "" {
                self.tblProductDetails.estimatedRowHeight = 85
                return 1
            } else { return 0 }
        } else if section == 6 {
            if self.viewModal?.productDetailResponse.productData?.parentChildCat?.count ?? 0 > 0 {
                return 1
            }
            return 0
    } else if section == 7 {
        if self.viewModal?.productDetailResponse.productData?.parentChildCat?.count ?? 0 > 0 {
            self.tblProductDetails.estimatedRowHeight = 100
            return self.viewModal?.productDetailResponse.productData?.parentChildCat?.count ?? 0
         } else {
             return 0
        }
    }
     else if section == 8 {
            if self.viewModal?.productDetailResponse.productData != nil {
                 return 1
            }
       return 0
    }  else if section == 9 {
            if self.viewModal?.arrSimilarProducts.count ?? 0 > 0 {
                return 1
            } else {
                return 0
            }
    } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let productDetails = self.viewModal?.productDetailResponse

        if indexPath.section == 0 {
            let topCell = tableView.dequeueReusableCell(withIdentifier:
                TABLEVIEWCELLID.PRODUCTDETAILTOPCELLID, for: indexPath) as? ProductDetailTopCell
            topCell?.selectionStyle = .none
            if let wishlistStatus = productDetails?.productData?.wishlist?.lowercased().trim() {
                if wishlistStatus.contains(NSLocalizedString("YES", comment: "")) {
                    topCell?.btnWishlist.setImage(UIImage(named: "wishlistSelectedBig"), for: .normal)
                } else {
                    topCell?.btnWishlist.setImage(UIImage(named: "wishlistBig"),
                                              for: .normal)
                }
            }
            topCell?.btnBack.addTarget(self, action: #selector(ProductDetailViewController.actionMethodOnBack), for: .touchUpInside)
            topCell?.btnWishlist.addTarget(self, action: #selector(ProductDetailViewController.actionMethodOnSetWishlist), for: .touchUpInside)
            return topCell ?? UITableViewCell.init()
            
        } else if indexPath.section == 1 {
            
            let detailImageCell = tableView.dequeueReusableCell(withIdentifier:
                TABLEVIEWCELLID.PRODUCTDETAILIMAGECELLID, for: indexPath) as? ProductDetailImageCell
            detailImageCell?.selectionStyle = .none
            
            DispatchQueue.main.async {
                if let pData = productDetails?.productData {
                    detailImageCell?.loadProductImages(productData: pData )
                }
            }
            var regularPrc = ""
            if let regularPrice = productDetails?.productData?.regularPrice {
                    if !regularPrice.isEmpty { regularPrc = regularPrice }
                    if let salePrice = productDetails?.productData?.salePrice , salePrice != "" {
                    
                    
                    let mainPrc = regularPrc.replacingOccurrences(of: "$", with: "")
                    let salePrc = salePrice.replacingOccurrences(of: "$", with: "")
                    let productPrc: Double = Double(mainPrc) ?? 0.0
                    let discountPrice: Double = Double(salePrc) ?? 0.0
                    
//                    let disCountedVal: Double = ((productPrc - discountPrice) / productPrc) * 100
  
                    let disCountedVal: Double = ((productPrc - discountPrice) / productPrc) * 100

                    let disCountPercnt: Int = Int(disCountedVal)
                    if disCountedVal == 0 {
                        detailImageCell?.lblDiscount.text = productPrc.description
                        detailImageCell?.saleBadgeView.isHidden = true
                    } else if disCountPercnt > 0 {
                        detailImageCell?.saleBadgeView.isHidden = false
                        detailImageCell?.lblDiscount.text = "\(disCountPercnt)%"
                    }
                }
                
        }
            return detailImageCell ?? UITableViewCell.init()
            
        } else if indexPath.section == 2 {
            let productPriceCell = tableView.dequeueReusableCell(withIdentifier:
                TABLEVIEWCELLID.PRODUCTDETAILADDTOCARTCELLID, for: indexPath) as? ProductDetailAddToCartCell
            productPriceCell?.selectionStyle = .none
            var regularPrc = ""
            var salePrc = ""
            
            if let productName = productDetails?.productData?.name {
                productPriceCell?.lblProductName.text = productName
            }
            
            if let productQuantity = productDetails?.productData?.productQuantity {
                productPriceCell?.lblProductQty.text = NSLocalizedString("STOCK_QUANTITY_TITLE", comment: "")+productQuantity.description
             }
            
            if let managingStock = productDetails?.productData?.managingStock {
                 if !managingStock {
                    productPriceCell?.lblProductQty.text = "In Stock"
                }
            }

            productPriceCell?.lblRegularPrice.isHidden = true
            productPriceCell?.lblSalePrice.isHidden = true
//            var currencySymbolStr = ""
//            if let currencySymbol = productDetails?.productData?.currencySymbol {
//                currencySymbolStr = currencySymbol
//            }
            
            if let regularPrice = productDetails?.productData?.regularPrice {
                regularPrc = regularPrice
                if !regularPrice.isEmpty && regularPrice != "" {
                    productPriceCell?.lblRegularPrice.isHidden = false
                    let attributeString1: NSMutableAttributedString =  NSMutableAttributedString(string: " "+regularPrice )
                     productPriceCell?.lblRegularPrice.attributedText = attributeString1
                }
            }
                
            if let salePrice = productDetails?.productData?.salePrice {
                 salePrc = salePrice
                 productPriceCell?.lblSalePrice.isHidden = false
                if !salePrc.isEmpty && salePrc != "" {
                    productPriceCell?.lblSalePrice.textColor = UIColor.salmon
                    productPriceCell?.lblSalePrice.text = salePrice
                    if !regularPrc.isEmpty && regularPrc != "" {
                        let attributeString1: NSMutableAttributedString =  NSMutableAttributedString(string: regularPrc)
                        attributeString1.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString1.length))
                         productPriceCell?.lblRegularPrice.attributedText = attributeString1
                    }
                }
            }
            
            productPriceCell?.btnAddCart.addTarget(self, action: #selector(ProductDetailViewController.actionMethodOnAddToCart), for: .touchUpInside)
            return productPriceCell ?? UITableViewCell.init()
        } else if indexPath.section == 3 {
            
            let productCellInfo = tableView.dequeueReusableCell(withIdentifier:
                           TABLEVIEWCELLID.PRODUCTDETAILINFOCELLID, for: indexPath) as? ProductDetailInfoCell
            productCellInfo?.selectionStyle = .none
            let tableInfo = arrTableData?[indexPath.row]
            
            if let titleName = tableInfo?.title {
                productCellInfo?.lblName.text = titleName
            }
            
            if let range = tableInfo?.condition {
                productCellInfo?.lblRange.text = range
            }
            
            if let discount = tableInfo?.discount {
                productCellInfo?.lblDiscount.text = discount
            }
            
            return productCellInfo ?? UITableViewCell.init()

        }
        else if indexPath.section == 4 {
            let productDecriptionCell = tableView.dequeueReusableCell(withIdentifier:
                                     TABLEVIEWCELLID.PRODUCTDETAILDESCRIPTIONCELLID, for: indexPath) as? ProductDetailDescriptionCell
            productDecriptionCell?.selectionStyle = .none
            
        if let description = productDetails?.productData?.productDataDescription {
            let textDescription = description.trim()
            productDecriptionCell?.lblProductDescription.numberOfLines = 0
            productDecriptionCell?.lblProductDescription.sizeToFit()
            
            var productDescription: String = ""
            productDescription = textDescription.replacingOccurrences(of: "<img src=", with: "")
            productDecriptionCell?.lblProductDescription.attributedText = productDescription.htmlAttributed()
            
//            if  let attString = textDescription.htmlToAttributedString {
//
////                attString.addAttributes([NSAttributedString.Key.foregroundColor: ColorConstants.APPBLUECOLOR,
////                                         NSAttributedString.Key.font: UIFont(name: "SFProText-Medium", size: 14)!], range: NSMakeRange(0, attString.length))
//
//               productDecriptionCell?.lblProductDescription.attributedText = attString
//            }

         //   productDecriptionCell?.lblProductDescription.text = "\n"+textDescription
        }
            
        return productDecriptionCell ?? UITableViewCell.init()

        } else if indexPath.section == 5 {
            
            let productDetailVideoCell = tableView.dequeueReusableCell(withIdentifier:
                                     TABLEVIEWCELLID.PRODUCTDETAILVIDEOCELLID, for: indexPath) as? ProductDetailVideoCell
            productDetailVideoCell?.selectionStyle = .none
            
            guard let videoUrl = productDetails?.productData?.videoUrl else { return UITableViewCell.init() }
            if !videoUrl.isEmpty && videoUrl != "" {
                productDetailVideoCell?.videoPlayer.uiDelegate = self
                productDetailVideoCell?.videoPlayer.navigationDelegate = self
                let myURL = URL(string: videoUrl)
                let myRequest = URLRequest(url: myURL!)
                productDetailVideoCell?.videoPlayer.load(myRequest)
            }
            return productDetailVideoCell ?? UITableViewCell.init()
        }
        else if indexPath.section == 6 {
            let productDetailTypeCell = tableView.dequeueReusableCell(withIdentifier:
                                             TABLEVIEWCELLID.PRODUCTDETAILTYPECELLID, for: indexPath) as? ProductDetailTypeCell
            productDetailTypeCell?.selectionStyle = .none
            return productDetailTypeCell ?? UITableViewCell.init()
        }
        else if indexPath.section == 7 {
            
            let extraProductInfo = productDetails?.productData?.parentChildCat?[indexPath.row]
            let productExtraCell = tableView.dequeueReusableCell(withIdentifier:
            TABLEVIEWCELLID.PRODUCTEXTRADETAILCELLID, for: indexPath) as? ProductExtraDetailsCell
           productExtraCell?.selectionStyle = .none
           productExtraCell?.lblProductType.text = extraProductInfo?.key
           productExtraCell?.btnProductTypeVal.tag = indexPath.row
           productExtraCell?.btnProductTypeVal.setTitle(extraProductInfo?.value, for: .normal)
           productExtraCell?.btnProductTypeVal.addTarget(self, action: #selector(goToProductList(_:)), for: .touchUpInside)
//            lblProductTypeVal.text = extraProductInfo?.value
           return productExtraCell ?? UITableViewCell.init()
        }
        else if indexPath.section == 8 {
            let addToCartCell = tableView.dequeueReusableCell(withIdentifier:
                TABLEVIEWCELLID.PRODUCTADDTOCARTCELLID, for: indexPath) as? AddToCartTableViewCell
                addToCartCell?.selectionStyle = .none
            addToCartCell?.btnAddCart.addTarget(self, action: #selector(ProductDetailViewController.actionMethodOnAddToCart), for: .touchUpInside)
            
            return addToCartCell ?? UITableViewCell.init()
        }  else if indexPath.section == 9 {
            let similarCell = tableView.dequeueReusableCell(withIdentifier:
                TABLEVIEWCELLID.SIMILARPRODUCTCELL, for: indexPath) as? SimilarProductTableViewCell
            similarCell?.selectionStyle = .none
            if let modal = self.viewModal {
                similarCell?.loadData(modal: modal)
            }
            
            similarCell?.callbackOnCellClick = { (productData) -> Void in
                self.navigateToProductDetailScreen(productDetails: productData)
            }
            return similarCell ?? UITableViewCell.init()
            
        }
        else { return UITableViewCell.init() }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50.0
        } else if indexPath.section == 1 {
            return 320.0
        } else if indexPath.section == 2 {
            return UITableView.automaticDimension
        } else if indexPath.section == 3 {
            return 40
        }  else if indexPath.section == 4 {
            return UITableView.automaticDimension
        }  else if indexPath.section == 5 {
            return UITableView.automaticDimension
        }  else if indexPath.section == 6 {
            return 70.0
        } else if indexPath.section == 7 {
            return 32
        } else if indexPath.section == 8 {
            return 70.0
        } else if indexPath.section == 9 {
            return 335.0
        }  else {
            return 20.0
        }
    }
    
}

extension ProductDetailViewController {
    @objc func goToProductList(_ sender: UIButton) {
       let productDetails = self.viewModal?.productDetailResponse
        var productName: String = ""
        if let productValueId = productDetails?.productData?.parentChildCat?[sender.tag].valueId {
            if productValueId != 0 {
               // print("Value Id is : \(productValueId)")
                
                if let productNameValue = productDetails?.productData?.parentChildCat?[sender.tag].value {
                    if !productNameValue.isEmpty {
                        productName = productNameValue
                    }
                }
                    
                self.showProductListingWithProduct(productId: productValueId.description, productName: productName)
            } else {
                self.view.makeToast(NSLocalizedString("PRODUCT_NOT_FOUND", comment: ""),
                                        duration: 1.5,
                                        position: .bottom)
            }
        }
    }

    func showProductListingWithProduct(productId:String, productName: String) {
        let subCatVC: SubCategoryViewController = (UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD,
                                                                     bundle: Bundle.main).instantiateViewController(withIdentifier:
                                        VCIDENTIFIER.SUBCATEGORYVC) as? SubCategoryViewController)!
        subCatVC.isComingFromProductDetails = true
        subCatVC.productFromDetailId = productId
        subCatVC.productName = productName
        self.navigationController?.pushViewController(subCatVC, animated: true)
    }
    
}

// MARK: PRODUCT DETAILS RESPONSE
extension ProductDetailViewController: ProductDetailProtocol {
    func onRecievedProductDetailSuccess() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.populateProductDetails()
            self.tblProductDetails.reloadData()
            self.tblProductDetails.layoutIfNeeded()
        }
    }
    
    func onFailure(errorMsg: String) {
        DispatchQueue.main.async {
            self.view.makeToast(errorMsg, duration: 1.5, position: .bottom)
        }
    }
    
        func populateProductDetails() {
            let productDetails = self.viewModal?.productDetailResponse
            arrTableData = [TableData].init()
            
            guard let arrTabDetails = productDetails?.productData?.tableData else { return }
        
            guard let arrExtraDetails = productDetails?.productData?.parentChildCat else { return }

            if !(arrTabDetails.isEmpty ) &&
                arrTabDetails.count > 0 {
                var firstTableData = TableData.init()
                firstTableData.title = "Name"
                firstTableData.condition = "Range"
                firstTableData.discount = "Discount"
                arrTableData = arrTabDetails
                arrTableData?.insert(firstTableData, at: 0)
            }
                
            if !(arrExtraDetails.isEmpty ) &&
                arrExtraDetails.count > 0 {}
            
            if let stockQuantity = productDetails?.productData?.stockStatus?.lowercased().trim() {
            self.isStockAvailable = stockQuantity.contains(            NSLocalizedString("IN_STOCK", comment: ""))

            if isStockAvailable {
                if let stockQuanity = productDetails?.productData?.stockQuantity {
                    reamStockQuantity = stockQuanity
                }
            }
                
            if let managingStock = productDetails?.productData?.managingStock {
               if !managingStock {
                   reamStockQuantity = 100
               }
            }
        }

//        let sectionIndex0 = IndexSet(integer: 0)
//        self.tblProductDetails.reloadSections(sectionIndex0, with: .none)
//
//        let sectionIndex1 = IndexSet(integer: 1)
//        self.tblProductDetails.reloadSections(sectionIndex1, with: .none)
//
//        let sectionIndex2 = IndexSet(integer: 2)
//        self.tblProductDetails.reloadSections(sectionIndex2, with: .none)
            
            
            
        // self.tblProductDetails.reloadData()
       //        if let productName = productDetails?.productData?.name {
        //            self.lblProductName.lineBreakMode = .byWordWrapping
        //            self.lblProductName.adjustsFontSizeToFitWidth = true
        //            self.lblProductName.text = productName
        //        }
        
        //        if let stockQuantity = productDetails?.productData?.stockStatus?.lowercased().trim() {
        //            self.isStockAvailable = stockQuantity.contains(            NSLocalizedString("IN_STOCK", comment: ""))
        //
        //            if isStockAvailable {
        //                if let stockQuanity = productDetails?.productData?.stockQuantity {
        //                    self.lblStockQauntity.isHidden = false
        //                    reamStockQuantity = stockQuanity
        //                    self.lblStockQauntity.text = NSLocalizedString("STOCK_QUANTITY_TITLE", comment: "")+"\(stockQuanity)"
        //                }
        //            }
        //        }
        
        //        var regularPrc = ""
        //        var salePrc = ""
        //
        //        self.lblRegularPrice.isHidden = true
        //        self.lblSalePrice.isHidden = true
        //        self.imgRegularPrice.isHidden = true
        //        self.imgSalePrice.isHidden = true
        //
        //        if let regularPrice = productDetails?.productData?.regularPrice {
        //            if !regularPrice.isEmpty { regularPrc = regularPrice }
        //            self.imgRegularPrice.isHidden = false
        //            self.lblRegularPrice.isHidden = false
        //            self.lblRegularPrice.text = regularPrc
        //        }
        //
        //        if let salePrice = productDetails?.productData?.salePrice , salePrice != "" {
        //
        //            if !salePrice.isEmpty {
        //                salePrc = salePrice
        //                self.imgSalePrice.isHidden = false
        //                self.lblSalePrice.isHidden = false
        //            }
        //
        //            self.lblSalePrice.text = salePrc
        //
        //            if !regularPrc.isEmpty || regularPrc != "" {
        //                let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: regularPrc)
        //                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
        //                                             value: 2, range: NSMakeRange(0,
        //                                                                          attributeString.length))
        //                self.lblRegularPrice.attributedText = attributeString
        //            }
        //
        //            let mainPrc = regularPrc.replacingOccurrences(of: "$", with: "")
        //            let salePrc = salePrice.replacingOccurrences(of: "$", with: "")
        //
        //            let productPrc: Double = Double(mainPrc) ?? 0.0
        //            let discountPrice: Double = Double(salePrc) ?? 0.0
        //
        //            let disCountedVal: Double = ((productPrc - discountPrice) / productPrc) * 100
        //
        //            let disCountPercnt: Int = Int(disCountedVal)
        //            if disCountedVal == 0 {
        //                self.lblRegularPrice.text = productPrc.description
        //                self.saleBadgeView.isHidden = true
        //            } else if disCountPercnt > 0 {
        //                self.saleBadgeView.isHidden = false
        //                self.lblDiscount.text = "\(disCountPercnt)%"
        //            }
        //        }
        //
        //        var mainContentSize: CGFloat = 0.0//self.contentViewHeight.frame.size.height
        //
        //        if let description = productDetails?.productData?.productDataDescription {
        //            let textDescription = description.trim()
        //            self.lblProductDescription.text = textDescription
        //            mainContentSize += self.lblProductDescription.frame.size.height
        //        }
        
        // self.parentChildStackView.isHidden = true
        //  self.productInfoBackView.isHidden = true
        //  self.productTypeView.isHidden = true
        //  self.playerBackView.isHidden = true
        
        //  guard let productDetailsInfo = productDetails else { return  }
        //  guard let arrTabDetails = productDetailsInfo.productData?.tableData else { return }
        //        self.arrTableData = arrTabDetails
        
        //        self.tableDataHieghtConstraint.constant = 0
        //        mainContentSize -= 100
        //        if !(self.arrTableData?.isEmpty ?? false) &&
        //            self.arrTableData?.count ?? 0 > 0 {
        //            self.productInfoBackView.isHidden = false
        //            addProductInfoViewAccordingToDetails()
        //
        //            let tableDataHieght = (arrTableData?.count ?? 0) * 40
        //            mainContentSize += CGFloat(tableDataHieght)
        //        }
        //
        //        guard let videoUrl = productDetailsInfo.productData?.videoUrl else { return }
        //
        //        self.videoViewHieghtConstraint.constant = 0.0
        //        mainContentSize -= 200.0
        //        if (!videoUrl.isEmpty) && (videoUrl != "") {
        //            self.videoViewHieghtConstraint.constant = 200.0
        //            mainContentSize += 200.0
        //            self.playerBackView.isHidden = false
        //            let myURL = URL(string: videoUrl)
        //            let myRequest = URLRequest(url: myURL!)
        //            self.videoPlayer.load(myRequest)
        //        }
        //
        //        self.similarProductHeightConstraint.constant = 0
        //        mainContentSize -= 310
        //        if viewModal?.arrSimilarProducts.count ?? 0 > 0 {
        //            self.similarProductHeightConstraint.constant = 300
        //            mainContentSize += 310
        //        }
        //        self.productExtraHeightConstraint.constant = 0
        //        mainContentSize -= self.productExtraHeightConstraint.constant
        //        if let arrParentChildDetails =
        //            self.viewModal?.productDetailResponse.productData?.parentChildCat {
        //            if (!arrParentChildDetails.isEmpty) && arrParentChildDetails.count > 0 {
        //                self.parentChildStackView.isHidden = false
        //                self.productTypeView.isHidden = false
        //                let tableDataHieght = (arrParentChildDetails.count) * 42
        //                self.addProductDetailsViewAccordingToDetails(arrDetails: arrParentChildDetails)
        //                mainContentSize += CGFloat(tableDataHieght)
        //            }
        //        }
        //
        //        self.contentViewHeight.frame.size.height += mainContentSize - 200
        //        if self.view.frame.size.height > self.contentViewHeight.frame.size.height {
        //            self.view.frame.size.height -= 50.0
        //        }
        //
        //        self.tblProductDetails.layoutSubviews()
        //}
    }
    
}

// MARK: ADD TO CART PROTOCOL
extension ProductDetailViewController: AddToCartProtocol {
    func getProductCartCount() {
        var cartId : String? = ""
        if let cartDetails = UserDefaults.standard.retrieve(object: AddToCartResponse.self, fromKey: "cartDetails") {
            if let cartID: String = cartDetails.cartID?.cartId {
                cartId = cartID
            }
        }
        
        if let loginDetails = UserDefaults.standard.retrieve(object: LoginResponse.self, fromKey: "loginUser") {
            if let customerID: String = loginDetails.data?.customer?.customerID {
                if !(cartId?.isEmpty ?? false) {
                    self.dashboadViewModal?.cartCountRequest.cartId = cartId
                } else {
                    self.dashboadViewModal?.cartCountRequest.cartId = customerID
                }
                self.dashboadViewModal?.cartCountRequest.customerId = customerID
                self.dashboadViewModal?.getCartCountStatus()
            }
        }
    }
    func onAddCartProductSuccess() {
        DispatchQueue.main.async {
            if self.viewModal?.addCartSuccessMsg?.count ?? 0 > 0 {
                var successMsg: String = ""
                guard let productName = self.productDetail.productName else { return }
                if !productName.isEmpty {
                    successMsg = productName
                }
                self.view.makeToast("\(successMsg) added to cart.", duration: 1.5, position: .bottom)
                self.getProductCartCount()

                let productId = self.productDetail.productID?.description ?? "id"
                
               if let result = UserDefaults.standard.value(forKey: "addedCartValue") as? [String: String] {
                   print(result)
                   var dictCart = result
                   let quantity = Int(dictCart[productId] ?? "0") ?? 0
                   dictCart[productId] = String(quantity + self.addedQuantity)
                   UserDefaults.standard.set(dictCart, forKey: "addedCartValue")
               } else {
                let someDict:[String:String] = [productId: String(self.addedQuantity)]
                   UserDefaults.standard.set(someDict, forKey: "addedCartValue")
               }
                
                self.getProductDetailsFromServer()
            }
        }
    }
    func onAddToCartFailure(errorMsg: String) {
        DispatchQueue.main.async {
            let alertTitle = NSLocalizedString("ALERT_ERROR_TITLE", comment: "")
            BaseViewController.showBasicAlert(message: errorMsg, title: alertTitle)
        }
    }
}

// MARK: ADD PRODUCT QUANTITY
extension ProductDetailViewController: AddCartQuantityProtocol {
    
    func onDissmissCurrentView() {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setQuantity(qty: Int) {
        manageCartCount(quantity: qty)
    }
    
    func manageCartCount(quantity: Int) {
        UserDefaults.standard.save(customObject: quantity, inKey: "ItemQuantity")
        //print("Quantity is \(quantity)")
        self.tabBarController?.tabBar.isHidden = false
        addProductToMyCart(quantity: quantity)
    }
    
    func addProductToMyCart(quantity: Int) {
        
        if let loginDetails = UserDefaults.standard.retrieve(object: LoginResponse.self,
                                                             fromKey: "loginUser") {
            if let customerId = loginDetails.data?.customer?.customerID {
                self.viewModal?.addToCartRequest.customerId = customerId
            }
        }
        self.viewModal?.addToCartRequest.quantity = quantity.description
        if let productId = self.productDetail.productID {
            self.viewModal?.addToCartRequest.productId = productId.description
        }
        addedQuantity = quantity
        self.viewModal?.addProductsToCart()
    }
}

extension ProductDetailViewController {
    
    @objc func actionMethodOnBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func actionMethodOnSetWishlist() {
        if let productId = self.productDetail.productID {
            self.dashboadViewModal?.wishlistRequest.productId = productId.description
            self.dashboadViewModal?.wishlistRequest.userId = self.userId
            self.dashboadViewModal?.setUserWishlist()
        }
    }
    
    @IBAction func addQuantityMethodAction(_ sender: UIButton) {
        
        if !isStockAvailable || reamStockQuantity == 0 {
            self.view.makeToast((self.viewModal?.productDetailResponse.productData?.name ?? "")+""+NSLocalizedString("OUT_OF_STOCK_MESSAGE", comment: ""),
                                duration: 1.0,
                                position: .bottom)
            return
        }
        
        let addToCartPopUpVC: AddToCartPopUpViewController =
            (UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD,
                               bundle: Bundle.main).instantiateViewController(withIdentifier:
                                VCIDENTIFIER.ADDTOCARTPOPUPVCID) as? AddToCartPopUpViewController)!
        self.tabBarController?.tabBar.isHidden = true
        addToCartPopUpVC.modalPresentationStyle = .overFullScreen
        addToCartPopUpVC.productQuantity = reamStockQuantity
        addToCartPopUpVC.delegate = self
        UIApplication.shared.keyWindow?.rootViewController?.present(addToCartPopUpVC, animated: true, completion: nil)
        
        //self.present(addToCartPopUpVC, animated: true, completion: nil)
    }
    
    @objc func actionMethodOnAddToCart() {
       
    }
}

extension ProductDetailViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
       // NetworkManager.shared.hideProgressActivity()
       // self.videoPlayer.stopLoading()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
      //  NetworkManager.shared.showProgressActivity()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
       // NetworkManager.shared.hideProgressActivity()
    }
}



extension ProductDetailViewController {
    func navigateToProductDetailScreen(productDetails: Product) {
        let productDetailVC: ProductDetailViewController =
            (UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD,
                               bundle: Bundle.main).instantiateViewController(withIdentifier:
                                VCIDENTIFIER.PRODUCTDETAILVC) as? ProductDetailViewController)!
        productDetailVC.productDetail = productDetails
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }
}

// MARK: SET USER WISHLIST
extension ProductDetailViewController {
    
    @IBAction func setWishlistActionMethod(sender: UIButton){
        self.currentIndexPath = IndexPath.init(item: sender.tag, section: 0)
        let productDetails = self.viewModal?.arrSimilarProducts[sender.tag]
        if let productId = productDetails?.productID {
            self.dashboadViewModal?.wishlistRequest.productId = productId.description
            self.dashboadViewModal?.wishlistRequest.userId = self.userId
            self.dashboadViewModal?.setUserWishlist()
        }
    }
    
    @IBAction func searchProducts(_ sender: UIButton) {
        let searchVC: SearchViewController = (UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD,
                                                                bundle: Bundle.main).instantiateViewController(withIdentifier:
                                                                    VCIDENTIFIER.SEARCHVC) as? SearchViewController)!
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
}

extension String {
    var htmlToAttributedString: NSMutableAttributedString? {
        guard let data = data(using: .utf8) else { return NSMutableAttributedString() }
        do {
            return try NSMutableAttributedString(data: data, options: [.documentType: NSMutableAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSMutableAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
        func htmlAttributed() -> NSAttributedString? {
            do {
                let htmlCSSString = "<style>" +
                    "html *" +
                    "{" +
                    "font-size: 10pt !important;" +
                    "color: #1b2749 !important;" +
                    "font-family: SFProText-Medium !important;" +
                "}</style> \(self)"

                guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                    return nil
                }

                return try NSAttributedString(data: data,
                                              options: [.documentType: NSAttributedString.DocumentType.html,
                                                        .characterEncoding: String.Encoding.utf8.rawValue],
                                              documentAttributes: nil)
            } catch {
                print("error: ", error)
                return nil
            }
        }
    
}
