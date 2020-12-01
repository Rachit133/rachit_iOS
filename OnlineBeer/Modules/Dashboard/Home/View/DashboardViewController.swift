//
//  DashboardViewController.swift
//  Beer Connect
//
//  Created by Synsoft on 28/01/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit
import LMCSideMenu
import SDWebImage
import SwiftyJSON

class DashboardViewController: BaseViewController {
   
   // MARK: - ALL IBOUTLET CONNECTION & VARIABLE DECLARATION
   @IBOutlet weak var btnMainSearch: UIButton!
   @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
   @IBOutlet weak var dashboardTableView: UITableView!
   @IBOutlet weak var btnMenu: UIButton!
   @IBOutlet weak var catCollectionView: UICollectionView!
   @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout?
   @IBOutlet weak var titleMainImage: UIImageView!
   @IBOutlet weak var logoImage: UIImageView!
   @IBOutlet weak var btnCustomerList: UIButton!

   let screenSize: CGRect = UIScreen.main.bounds
   let appDelegate = UIApplication.shared.delegate as? AppDelegate
   var viewModal: DashboardViewModal?
   var isCustomerListVisible: Bool = false
   var userId: String = ""
   var checkNotificationType = ""
   var categoryId = ""
   var productId = ""
   private let spacing:CGFloat = 12.0
   private let producSpacing:CGFloat = 8
   private var isAdminSales: Bool = false
   private let catSpacing:CGFloat = 12.0

   let sectionInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
   let numberOfItemsPerRow: CGFloat = 3
    let spacingBetweenCells: CGFloat = 15.0
   
   override func viewDidLoad() {
      super.viewDidLoad()
      self.btnCustomerList.isHidden = true
      
    initComponents()
      self.automaticallyAdjustsScrollViewInsets = false
    let layout = UICollectionViewFlowLayout()
         layout.sectionInset = UIEdgeInsets(top: catSpacing, left: catSpacing, bottom: catSpacing, right: catSpacing)
         layout.minimumLineSpacing = catSpacing
         layout.minimumInteritemSpacing = catSpacing
       layout.scrollDirection = .horizontal
         self.catCollectionView?.collectionViewLayout = layout
      
   }
    

   func manageAdminSalePerson() {
    if UserDefaults.standard.isKeyPresentInUserDefaults(key: "adminSalesDetails") {
      if let adminSalesDetails = UserDefaults.standard.retrieve(object: LoginResponse.self, fromKey: "adminSalesDetails") {
         if let adminFlag: Bool = adminSalesDetails.data?.customer?.salePerson {
            self.isAdminSales = adminFlag
            if self.isAdminSales {
                self.btnCustomerList.isHidden = false
            }
         }
      }
    }
   }
   
    func showCustomerListOnDashboard() {
    let customerListPopVC: CustomerListViewController =
                    (UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD,
                                        bundle: Bundle.main).instantiateViewController(withIdentifier:
                                            VCIDENTIFIER.CUSTOMERLISTVC) as? CustomerListViewController)!
    customerListPopVC.modalPresentationStyle = .overFullScreen
    customerListPopVC.delegate = self
    self.present(customerListPopVC, animated: true, completion: nil)
}
    
   override func viewWillAppear(_ animated: Bool) {
      manageCustomerListData()
      getDetailsFromLoginData()
      manageViewUIWithNavigationBar()
   }
    
    func manageNotificationData() {
        
        if UserDefaults.standard.isKeyPresentInUserDefaults(key: "NotificationData") {
            let notifyData = UserDefaults.standard.value(forKey: "NotificationData") as! [String:String]
           
            for (key,value) in notifyData {
                checkNotificationType=key
                if key=="category"{ categoryId = value }
                else if key=="product"{ productId = value }
            }
        }
        
        if checkNotificationType == "category"{
            let subCatVC: SubCategoryViewController =
                                (UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD,
                                bundle: Bundle.main).instantiateViewController(withIdentifier:
                                VCIDENTIFIER.SUBCATEGORYVC) as? SubCategoryViewController)!
            subCatVC.isComingFromNotification = true
            subCatVC.catMainId = self.categoryId
            self.navigationController?.pushViewController(subCatVC, animated: true)
        } else if checkNotificationType == "product" {
            
            let productDetailVC: ProductDetailViewController =
                    (UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD,
                        bundle: Bundle.main).instantiateViewController(withIdentifier:
                                    VCIDENTIFIER.PRODUCTDETAILVC) as? ProductDetailViewController)!
                 productDetailVC.notificationProductId = productId
                 self.navigationController?.pushViewController(productDetailVC, animated: true)
        }
            
        self.checkNotificationType=""
    }
    
    func manageCustomerListData() {
      if UserDefaults.standard.isKeyPresentInUserDefaults(key: "adminLogin") {
            let isAdminLogin = UserDefaults.standard.bool(forKey: "adminLogin")
             if isAdminLogin {
                self.showCustomerListOnDashboard()
                return
            }
        }
    }
    
   func manageViewUIWithNavigationBar() {
    self.tabBarController?.tabBar.isHidden = false
    self.appDelegate?.navigationController?.navigationBar.isHidden = true
    self.navigationController?.navigationBar.isHidden = true
    self.btnMainSearch.layer.shadowColor = UIColor.black53.cgColor
    self.btnMainSearch.layer.shadowOffset = CGSize.zero
    self.btnMainSearch.layer.shadowOpacity = 23.0
    self.btnMainSearch.layer.shadowRadius = 8.0
    self.btnMainSearch.layer.applySketchShadow(color: UIColor.black53, alpha: 1.0, x: 0, y: 4, blur: 23, spread: 0)
    self.btnMainSearch.layer.cornerRadius = 8
    self.btnMainSearch.layer.masksToBounds =  false
}
    
   func populateServerImages() {
      let onLaunchDetails = self.getOnLaunchDetails()
      
      self.titleMainImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
      self.titleMainImage.sd_setImage(with: URL(string: onLaunchDetails.backImg), placeholderImage: UIImage(named: "dashboardBack"), options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, url) in
         if error != nil {
            self.titleMainImage.contentMode = .scaleToFill
            self.titleMainImage.image = UIImage(named: "dashboardBack")
         } else {
            self.titleMainImage.contentMode = .scaleToFill
            self.titleMainImage.image = image
         }
      })
      
      self.logoImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
      
      self.logoImage.sd_setImage(with: URL(string: onLaunchDetails.logoUrl), placeholderImage: UIImage(named: "logo"), options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, url) in
         if error != nil {
            self.logoImage.contentMode = .scaleAspectFill
            self.logoImage.image = UIImage(named: "logo")
         } else {
            self.logoImage.contentMode = .scaleAspectFill
            self.logoImage.image = image
         }
      })
   }
   
   override func viewDidDisappear(_ animated: Bool) {
      //self.catCollectionView.reloadData()
   }
}

extension DashboardViewController {
   func initComponents() {
    populateServerImages()
    initializeViewModel()
    manageAdminSalePerson()
    setUpSideMenu()
    conformProtocol()
    dashboardTableView.tableFooterView = UIView()
   }
   
   func initializeViewModel() {
      viewModal = DashboardViewModal(delegate: self)
   }
   
   func getDetailsFromLoginData() {
    if UserDefaults.standard.isKeyPresentInUserDefaults(key: "loginUser") {
        if let loginDetails = UserDefaults.standard.retrieve(object: LoginResponse.self, fromKey: "loginUser") {
           guard let userId: String = loginDetails.data?.customer?.customerID else { return }
           self.userId = userId
           self.viewModal?.dashboardRequest.userId = self.userId
           self.viewModal?.getProductsFromServer()
        }
    }
   }
   
   func conformProtocol() {
      //  self.catCollectionView.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
      
      self.catCollectionView.dataSource = self
      self.catCollectionView.delegate = self
      //collectionViewFlowLayout?.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
      // self.collectionViewFlowLayout.itemSize = CGSize(width: (self.view.bounds.width - (self.catCollectionView.contentInset.left + self.catCollectionView.contentInset.right)) / 2, height: 110)
      
      //ollectionViewFlowLayout?.minimumLineSpacing = 0
      //collectionViewFlowLayout?.minimumInteritemSpacing = 0
      
      if self.sideMenuVC != nil {
         self.sideMenuVC?.delegate = self
      }
   }
   
   @IBAction func showMenu(_ sender: UIButton) { showSideMenu() }
}

extension DashboardViewController: UserProfileProtocol {
   func onMenuOptionClick(tabBarName: String, tabIndex: Int) {
      DispatchQueue.main.async {
         if tabBarName.lowercased().trim().contains("order history") {
            let orderListVC: OrderListViewController =
               (UIStoryboard.init(name: STORYBOARDCONS.ORDER,
                                  bundle: Bundle.main).instantiateViewController(withIdentifier:
                                    VCIDENTIFIER.ORDERLISTVC) as? OrderListViewController)!
            //self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(orderListVC, animated: true)
         
         } else if tabBarName.lowercased().trim().contains("logout") {
            self.tabBarController?.tabBar.items?[2].badgeColor = nil
            self.tabBarController?.tabBar.items?[2].badgeValue = nil
            self.tabBarController?.navigationController?.popToRootViewController(animated: true)
     
         } else if tabBarName.lowercased().trim().contains("notification") {
            let notificationVC: NotificationViewController =
               (UIStoryboard.init(name: STORYBOARDCONS.NOTIFICATION,
                                  bundle: Bundle.main).instantiateViewController(withIdentifier:
                                    VCIDENTIFIER.NOTIFICATIONVC) as? NotificationViewController)!
            self.navigationController?.pushViewController(notificationVC, animated: true)
         } else if tabBarName.lowercased().trim().contains("setting") {
            let settingVC: SettingViewController =
               (UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD,
                                  bundle: Bundle.main).instantiateViewController(withIdentifier:
                                    VCIDENTIFIER.SETTINGVC) as? SettingViewController)!
            self.navigationController?.pushViewController(settingVC, animated: true)
        }
          else {
            self.tabBarController?.selectedIndex = tabIndex
         }
      }
   }
    @IBAction func showCustomerListMethodAction(_ sender: UIButton) {
           self.showCustomerListOnDashboard()
       }
}

// MARK: - TableView Datasoruce & Delegate Methods
extension DashboardViewController: UITableViewDataSource, UITableViewDelegate {
   
   func numberOfSections(in tableView: UITableView) -> Int {
      return 2
   }
   
   func tableView(_ tableView: UITableView,
                  numberOfRowsInSection section: Int) -> Int {
      if section == 0 {
         if self.viewModal?.arrDealsProduct?.count ?? 0 > 2 {
            return 2
         } else {
            return self.viewModal?.arrDealsProduct?.count ?? 0
         }
      } else if section == 1 {
         return 1
      } else {
         return 1
      }
   }
   
   func tableView(_ tableView: UITableView,
                  cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      if indexPath.section == 0 {
         
         let dealerCat = tableView.dequeueReusableCell(withIdentifier:
            TABLEVIEWCELLID.DEALERPRODUCTCELLID,
                                                       for: indexPath) as? DealProductsCell
         dealerCat?.selectionStyle = .none
         
        let dealsDetails = self.viewModal?.arrDealsProduct?[indexPath.row]
         
         if let productName = dealsDetails?.productName {
            dealerCat?.lblProductTitle.text = productName
         }
         
         var regularPrc = ""
         dealerCat?.discountPrice.isHidden = true
         dealerCat?.lblProductPrice.isHidden = true
         dealerCat?.disCountView.isHidden = true
         
        if let regularPrice = dealsDetails?.regularPrice {
               if !(regularPrice.isEmpty) && (regularPrice != "") {
                  regularPrc = regularPrice
                  dealerCat?.lblProductPrice.isHidden = false
                  let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: regularPrice)
                  dealerCat?.lblProductPrice.attributedText = attributeString
               }
         }
                 
         if let salePrice = dealsDetails?.salePrice {
            if (!salePrice.isEmpty) && (salePrice != "") {
                dealerCat?.discountPrice.isHidden = false
                dealerCat?.lblProductPrice.isHidden = false
                dealerCat?.discountPrice.text = salePrice
             if (!regularPrc.isEmpty) && (regularPrc != "") {
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: regularPrc)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                dealerCat?.lblProductPrice.attributedText = attributeString
             }
                     
            let mainPrc = regularPrc.replacingOccurrences(of: "$", with: "")
            let salePrc = salePrice.replacingOccurrences(of: "$", with: "")
                     
            let productPrc: Double = Double(mainPrc) ?? 0.0
            let discountPrice: Double = Double(salePrc) ?? 0.0
                     
            //let disCountedVal: Double = ((productPrc - discountPrice) / ((productPrc + discountPrice)/2)) * 100
            let disCountedVal: Double = ((productPrc - discountPrice) / productPrc) * 100

            let disCountPercnt: Int = Int(disCountedVal)
                     
             if disCountedVal == 0 {
                dealerCat?.disCountView.isHidden = true
                dealerCat?.discountPrice.isHidden = true
                dealerCat?.lblProductPrice.isHidden = false
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: productPrc.description)
                dealerCat?.lblProductPrice.attributedText = attributeString
             } else if disCountPercnt > 0 {
                dealerCat?.disCountView.isHidden = false
                dealerCat?.lblDiscountPercentage.text = "\(disCountPercnt)%"
             }
                  }
               }
        
         if let productImg = dealsDetails?.productImage {
            dealerCat?.productTitleImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            dealerCat?.productTitleImage.sd_setImage(with: URL(string: productImg),
                                                     placeholderImage: UIImage(named: "catDefault"))
         } else {
             dealerCat?.productTitleImage.image = UIImage(named: "catDefault")
         }
         if let quantity = dealsDetails?.productQuantity {
            dealerCat?.lblProductQuantity.text = "Stock Quantity: \(quantity)"
         }
        
         if let managingStock = dealsDetails?.managingStock {
            if !managingStock {
                dealerCat?.lblProductQuantity.text = "In Stock"
            }
         }
         return dealerCat ?? UITableViewCell.init()
      }
         
      else {
         
         let bestCatCell = tableView.dequeueReusableCell(withIdentifier:
            TABLEVIEWCELLID.BESTCATCELLID,
                                                         for: indexPath) as? BestCategoryCell
         
         bestCatCell?.selectionStyle = .none
         bestCatCell?.bestSellerCollectionView.delegate = self
         bestCatCell?.bestSellerCollectionView.dataSource = self
         bestCatCell?.bestSellerCollectionView.reloadData()
         bestCatCell?.collectionViewFlowLayout?.scrollDirection = .vertical
         collectionViewFlowLayout?.sectionInset = UIEdgeInsets(top: spacing, left: 0, bottom: spacing, right: 0)
         collectionViewFlowLayout?.minimumLineSpacing = spacing
         collectionViewFlowLayout?.minimumInteritemSpacing = spacing
         return bestCatCell ?? UITableViewCell.init()
      }
   }
   
   func tableView(_ tableView: UITableView,
                  willDisplay cell: UITableViewCell,
                  forRowAt indexPath: IndexPath) {
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      if indexPath.section == 0 {
         return 160.0
      } else {
         return 560.0
      }
   }
   
   func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return 50
   }
   
   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      let headerView: UIView?
      if section == 0 || section == 1 {
         
         headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
         let label = UILabel()
         label.frame = CGRect.init(x: 16,
                                   y: 10,
                                   width: (headerView?.frame.width ?? 0.0) - 10,
                                   height: (headerView?.frame.height ?? 0.0) - 10)
         
         let frame: CGRect = tableView.frame
         let btnSeeAll: UIButton = UIButton(frame:
            CGRect(x: frame.size.width - 95, y: 5, width: 80, height: 45))
         btnSeeAll.setTitle("See all", for: .normal)
         btnSeeAll.titleLabel?.font = openSansBold16
         btnSeeAll.setTitleColor(ColorConstants.COLORACTIVITYINDICATOR, for: .normal)
         btnSeeAll.addTarget(self, action: #selector(DashboardViewController.showSubCategoryMethodAction(sender:)), for: .touchUpInside)
         headerView?.addSubview(btnSeeAll)
         
         if section == 0 {
            label.text = NSLocalizedString("DEALS_TITLE", comment: "")
            btnSeeAll.tag = section
         } else {
            btnSeeAll.tag = section
            label.text = NSLocalizedString("SELLER_TITLE", comment: "")
         }
         
         label.font = openSansBold18
         label.textColor = ColorConstants.BLACKCOLOR
         headerView?.addSubview(label)
         return headerView
      }
      return UIView.init()
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      guard let productDetails = self.viewModal?.arrDealsProduct?[indexPath.row] else { return  }
      self.navigateToProductDetailScreen(productDetails: productDetails)
   }
   
   @objc func showSubCategoryMethodAction(sender: UIButton) {
      
      let subCatVC: SubCategoryViewController = (UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD,
                                                                   bundle: Bundle.main).instantiateViewController(withIdentifier:
                                                                     VCIDENTIFIER.SUBCATEGORYVC) as? SubCategoryViewController)!
      
      //subCatVC.isComingFromMainCat = false
      subCatVC.isComingFromSearch = false
      //subCatVC.userId = self.userId
      //subCatVC.customerId = self.userId
      if sender.tag == 0 {
         if self.viewModal != nil {
            guard let categoryId: Int = self.viewModal?.response?.dealProducts?.categoryId else { return }
            subCatVC.navigationTitle = NSLocalizedString("DEALS_TITLE", comment: "")
            subCatVC.isComingFromDeals = true
            subCatVC.catId = categoryId.description
         }
      } else {
         if self.viewModal != nil {
            guard let categoryId: Int = self.viewModal?.response?.bestSellingProducts?.categoryId else { return }
            subCatVC.isComingFromDeals = true
            subCatVC.navigationTitle = NSLocalizedString("SELLER_TITLE", comment: "")
            subCatVC.catId = categoryId.description
         }
      }
      self.navigationController?.pushViewController(subCatVC, animated: true)
   }
}

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
   
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      if collectionView.tag == 111 {
         return 1
      } else {
         return 1
      }
   }
   
   func collectionView(_ collectionView: UICollectionView,
                       numberOfItemsInSection section: Int) -> Int {
      if collectionView.tag == 111 {
         return self.viewModal?.arrProduct?.count ?? 0
      } else {
         if self.viewModal?.arrBestSellerProduct?.count ?? 0 > 4 {
            return 4
         } else {
            return self.viewModal?.arrBestSellerProduct?.count ?? 0
         }
      }
   }
   
   func collectionView(_ collectionView: UICollectionView,
                       cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      if collectionView.tag == 111 {
         guard let cell: CategoryCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier:
            COLLECTIONVIEWCELLID.CATEGORYCOLLECTIONCELLID,
                                                                                     for: indexPath) as? CategoryCollectionCell else {
                                                                                       return (collectionView.dequeueReusableCell(withReuseIdentifier: COLLECTIONVIEWCELLID.CATEGORYCOLLECTIONCELLID,
                                                                                                                                  for: indexPath) as? CategoryCollectionCell)!
         }
        
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        
        cell.backViewForCat.layer.shadowColor = UIColor.black32.cgColor
        cell.backViewForCat.layer.shadowOffset = CGSize(width: 0, height: 4)
        cell.backViewForCat.layer.shadowOpacity = 8.0
        cell.backViewForCat.layer.shadowRadius = 8.0
        cell.backViewForCat.layer.cornerRadius = 12.0
        cell.backViewForCat.layer.masksToBounds = false

//        cell.backViewForCat.layer.applySketchShadow(
//            color: UIColor.black32,
//            x: 0,
//            y: 4,
//            blur: 20,
//            spread: 0)
         let productDetails = self.viewModal?.arrProduct?[indexPath.row]
         cell.lblCatTitle.text = productDetails?.categoryName
        
        DispatchQueue.main.async {
           if let imageURL = productDetails?.categoryImage {
              
              cell.category.sd_imageIndicator = SDWebImageActivityIndicator.gray

              cell.category?.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "catDefault"), options: [.continueInBackground, .delayPlaceholder], completed: { (image, error, cacheType, url) in
                 if error != nil {
                    cell.category.image = UIImage(named: "catDefault")
                 } else {
                    cell.category.image = image
                 }
              })
           }
        }
        
         return cell
      }
      else {
         
         guard let bestSellercell: BestSellerProductCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier:
            COLLECTIONVIEWCELLID.BESTSELLERCATCELLID,
                                                                                                        for: indexPath) as? BestSellerProductCollectionCell else {
                                                                                                         return (collectionView.dequeueReusableCell(withReuseIdentifier: COLLECTIONVIEWCELLID.BESTSELLERCATCELLID,
                                                                                                                                                    for: indexPath) as? BestSellerProductCollectionCell)!
         }
         
        bestSellercell.layer.shouldRasterize = true
        bestSellercell.layer.rasterizationScale = UIScreen.main.scale
        
        let productDetails = self.viewModal?.arrBestSellerProduct?[indexPath.item]
         bestSellercell.disCountView.isHidden = true
         bestSellercell.btnProductWishlist.tag = indexPath.item
         bestSellercell.btnProductWishlist.addTarget(self, action: #selector(setWishlistActionMethod(sender:)), for: .touchUpInside)
         
        var regularPrc = ""
        
        if let wishlistStr = productDetails?.wishlist?.lowercased().trim() {
        if wishlistStr == NSLocalizedString("YES", comment: "") {
            bestSellercell.btnProductWishlist.setBackgroundImage(UIImage(named: "wishlist"), for: .normal)
        } else {
            bestSellercell.btnProductWishlist.setBackgroundImage(UIImage(named: "wishlistDisable"), for: .normal)
        }
        }
        
        bestSellercell.lblDiscountPrice.isHidden = true
        bestSellercell.lblRegularPrice.isHidden = true

         if let regularPrice = productDetails?.regularPrice {
            if !regularPrice.isEmpty {
               regularPrc = regularPrice
               bestSellercell.lblRegularPrice.isHidden = false
               let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: regularPrc)
               bestSellercell.lblRegularPrice.attributedText = attributeString
            }
         }
         
         if let salePrice = productDetails?.salePrice {
            if (!salePrice.isEmpty) && (salePrice != "") {
               bestSellercell.lblDiscountPrice.isHidden = false
                
               bestSellercell.lblDiscountPrice.text = salePrice
               
               if !regularPrc.isEmpty {
                  bestSellercell.lblRegularPrice.isHidden = false
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: regularPrc)
                  attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                  bestSellercell.lblRegularPrice.attributedText = attributeString
               }
               
               let mainPrc = regularPrc.replacingOccurrences(of: NSLocalizedString("DOLLER_SYM", comment: ""), with: "")
               let salePrc = salePrice.replacingOccurrences(of: NSLocalizedString("DOLLER_SYM", comment: ""), with: "")
               
               let productPrc: Double = Double(mainPrc) ?? 0.0
               let discountPrice: Double = Double(salePrc) ?? 0.0
               
             //  let disCountedVal: Double = ((productPrc - discountPrice) / ((productPrc + discountPrice)/2)) * 100
               
               let disCountedVal: Double = ((productPrc - discountPrice) / productPrc) * 100
                
               let disCountPercnt: Int = Int(disCountedVal)
               if disCountedVal == 0 {
                  bestSellercell.disCountView.isHidden = true
                  bestSellercell.lblDiscountPrice.isHidden = true
                  let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: productPrc.description)
                  bestSellercell.lblRegularPrice.attributedText = attributeString
               } else if disCountPercnt > 0 {
                  bestSellercell.disCountView.isHidden = false
                  bestSellercell.lblDiscountPercentage.text = "\(disCountPercnt)%"
               }
            } else {
                bestSellercell.lblDiscountPrice.isHidden = false
                bestSellercell.lblDiscountPrice.text = " "
            }
         }
         
         if let productName = productDetails?.productName {
            bestSellercell.lblProductTitle.text = productName
         }
         
         if let productQuantity = productDetails?.productQuantity {
            bestSellercell.lblStockQuantity.text = NSLocalizedString("STOCK_QUANTITY_TITLE", comment: "")+productQuantity.description
         }
        
        if let managingStock = productDetails?.managingStock {
                       if !managingStock {
                             bestSellercell.lblStockQuantity.text = "In Stock"
                       }
        }
         
        
        DispatchQueue.main.async {
         if let imageURL = productDetails?.productImage {
            
            bestSellercell.productTitleImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            
            bestSellercell.productTitleImage.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "catDefault"), options: [.continueInBackground, .delayPlaceholder], completed: { (image, error, cacheType, url) in
               if error != nil {
                  bestSellercell.productTitleImage.image = UIImage(named: "catDefault")
               } else {
                  bestSellercell.productTitleImage.image = image
               }
            })
         } else {
             bestSellercell.productTitleImage.image = UIImage(named: "catDefault")
         }
        }
        return bestSellercell
      }
   }
   
   func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      if collectionView.tag == 111 {
         self.viewWillLayoutSubviews()
      } else {
        cell.layer.masksToBounds =  false
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.cornerRadius = 18.0
         cell.layer.applySketchShadow(
            color: UIColor.black8,
            alpha: 1,
            x: 0,
            y: 4,
            blur: 23,
            spread: 0)
        
      }
   }
   
   func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       sizeForItemAt indexPath: IndexPath) -> CGSize {
      
      if collectionView.tag == 111 {
        
        let numberOfItemsPerRow:CGFloat = 3
        let spacingBetweenCells:CGFloat = 12
               
        let totalSpacing = (1.5 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
               
           let width = (collectionView.bounds.width - totalSpacing)/numberOfItemsPerRow
           return CGSize(width: width, height: width)
        
        //let totalSpacing = (1.8 * sectionInsets.left) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
        //let width = (collectionView.bounds.width - totalSpacing)/numberOfItemsPerRow
        //return CGSize(width: 115.0, height: 115.0)
      
      } else {
         let numberOfItemsPerRow:CGFloat = 2
         let spacingBetweenCells:CGFloat = 8
         
         let totalSpacing = (0.8 * self.producSpacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
         let width = (collectionView.bounds.width - totalSpacing)/numberOfItemsPerRow
         return CGSize(width: width, height: 254.0)
      }
   }
   
   func collectionView(_ collectionView: UICollectionView,
                       didSelectItemAt indexPath: IndexPath) {
      
      if collectionView.tag == 111 {
         let categoryDetails = self.viewModal?.arrProduct?[indexPath.item]
         
         let subCatVC: SubCategoryViewController =
            (UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD,
                               bundle: Bundle.main).instantiateViewController(withIdentifier:
                                 VCIDENTIFIER.SUBCATEGORYVC) as? SubCategoryViewController)!
         subCatVC.isComingFromSearch = false
         if categoryDetails != nil {
            //subCatVC.userId = self.userId
            //subCatVC.customerId = self.userId
            subCatVC.productDetails = categoryDetails ?? ProductCategory.init()
         }
         self.navigationController?.pushViewController(subCatVC, animated: true)
         
      } else  {
         guard let productDetails = self.viewModal?.arrBestSellerProduct?[indexPath.item] else { return  }
         self.navigateToProductDetailScreen(productDetails: productDetails)
      }
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      if collectionView != self.catCollectionView {
         return 10
        // return spacingBetweenCells
      } else {
        return 12
      }
   }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView != self.catCollectionView {
            return 10.0
        } else {
            return 12.0
        }
    }
    
   func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       insetForSectionAt section: Int) -> UIEdgeInsets {
      if collectionView.tag == 111 {

//        let totalCellWidth = 10 * collectionView.numberOfItems(inSection: 0)
//        let totalSpacingWidth = 2 * (collectionView.numberOfItems(inSection: 0) - 1)
//
//        let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 3
//        let rightInset = leftInset
        
        let sizeInset: CGFloat = 0.8
        var leftInset: CGFloat = 0.34
        let cellWidth: CGFloat = 110.0
        
        let collectionWidth = collectionView.frame.width
        if DeviceType.iPhone4OrLess { leftInset = 0.48
        } else if DeviceType.iPhoneSE { leftInset = 0.5}
        //else if DeviceType.iPhone8 { leftInset = 0.32 }
        else if DeviceType.iPhone8Plus { leftInset = 0.28 }
        else if DeviceType.iPhoneXr { leftInset = 0.26 }

        let inset: CGFloat = collectionWidth * leftInset - cellWidth * sizeInset
        return UIEdgeInsets(top: catSpacing, left: catSpacing, bottom: catSpacing, right: inset)
        //return UIEdgeInsets(top:catSpacing, left: catSpacing, bottom: catSpacing, right: catSpacing)

      } else {
         return UIEdgeInsets(top: 0, left:0, bottom: 0, right: 0)
      }
   }
   
}

extension DashboardViewController {
   
   @objc func setWishlistActionMethod(sender: UIButton){
      let productDetails = self.viewModal?.arrBestSellerProduct?[sender.tag]
      
      if let productId = productDetails?.productID {
         self.viewModal?.wishlistRequest.productId = productId.description
         self.viewModal?.wishlistRequest.userId = self.userId
         self.viewModal?.setUserWishlist()
         getDetailsFromLoginData()
      }
   }
   
   @IBAction func searchProducts(_ sender: UIButton) {
      let searchVC: SearchViewController = (UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD,
                                                              bundle: Bundle.main).instantiateViewController(withIdentifier:
                                                               VCIDENTIFIER.SEARCHVC) as? SearchViewController)!
      self.navigationController?.pushViewController(searchVC, animated: true)
      //self.tabBarController?.selectedIndex = 1
   }
}

// Dashboard Req/Res Delegates Methods
extension DashboardViewController: DashboardProtocol {
    func onAdminCustomerLoginSuccess() {
        // Manage Sales Person as Customer
        self.getDetailsFromLoginData()
    }
    
   func onCartFailure(errorMsg: String) {
      DispatchQueue.main.async {
         self.tabBarController?.tabBar.items?[2].badgeColor = nil
         self.tabBarController?.tabBar.items?[2].badgeValue = nil
      }
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
   
   func onRecievedWishlistResponse() {
      DispatchQueue.main.async {
         self.view.makeToast(self.viewModal?.wishlistResponseMsg, duration: 1.0, position: .bottom)
      }
    NotificationCenter.default.post(name: Notification.Name("refreshWishlist"), object: nil, userInfo: nil)
      self.getDetailsFromLoginData()
   }
   
   func onRecievedProductsSuccess() {
      DispatchQueue.main.async {
         
        if let backImageURL = self.viewModal?.response?.bgImageUrl {
            
            if !backImageURL.isEmpty {
                self.titleMainImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.titleMainImage.sd_setImage(with: URL(string: backImageURL), placeholderImage: UIImage(named: "dashboardBack"), options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, url) in
                   if error != nil {
                      self.titleMainImage.contentMode = .scaleToFill
                      self.titleMainImage.image = UIImage(named: "dashboardBack")
                   } else {
                      self.titleMainImage.contentMode = .scaleToFill
                      self.titleMainImage.image = image
                   }
                })
            }
        }
        
        
        if let logoImageUrl = self.viewModal?.response?.logoUrl {
            if !logoImageUrl.isEmpty {
                self.logoImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                self.logoImage.sd_setImage(with: URL(string: logoImageUrl), placeholderImage: UIImage(named: "logo"), options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, url) in
                   if error != nil {
                      self.logoImage.contentMode = .scaleAspectFill
                      self.logoImage.image = UIImage(named: "logo")
                   } else {
                      self.logoImage.contentMode = .scaleAspectFill
                      self.logoImage.image = image
                   }
                })
            }
        }
        
         self.catCollectionView.reloadData()
         self.dashboardTableView.reloadData()
      }
      
      getProductCartCount()
   }
   
   func onFailure(errorMsg: String) {
      DispatchQueue.main.async {
         let alertTitle = NSLocalizedString("ALERT_ERROR_TITLE", comment: "")
         BaseViewController.showBasicAlert(message: errorMsg, title: alertTitle)
      }
   }
   
   func getProductCartCount() {
    if UserDefaults.standard.isKeyPresentInUserDefaults(key: "loginUser") {
        if let loginDetails = UserDefaults.standard.retrieve(object: LoginResponse.self, fromKey: "loginUser") {
           if let customerID: String = loginDetails.data?.customer?.customerID {
              self.viewModal?.cartCountRequest.customerId = customerID
              self.viewModal?.cartCountRequest.cartId = customerID
              self.viewModal?.getCartCountStatus()
           }
        }

    }
   }
    
    func applyBlurEffect(image: UIImage, gussianValue:Float = 0.0) -> UIImage{
        let imageToBlur = CIImage(image: image)
        let blurfilter = CIFilter(name: "CIGaussianBlur")
        blurfilter?.setValue(imageToBlur, forKey: "inputImage")
        blurfilter?.setValue(13.4, forKey: "inputRadius")
        let resultImage = blurfilter?.value(forKey: "outputImage") as! CIImage
        let blurredImage = UIImage(ciImage: resultImage)
        return blurredImage
    }
}


extension DashboardViewController {
   func navigateToProductDetailScreen(productDetails: Product) {
      let productDetailVC: ProductDetailViewController =
         (UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD,
                            bundle: Bundle.main).instantiateViewController(withIdentifier:
                              VCIDENTIFIER.PRODUCTDETAILVC) as? ProductDetailViewController)!
      productDetailVC.productDetail = productDetails
      self.navigationController?.pushViewController(productDetailVC, animated: true)
   }
}

extension DashboardViewController: CustomerSelectedProtocol {
    func onCustomerSelected(customerId: String) {
        var adminTokenId: String = ""
        if UserDefaults.standard.isKeyPresentInUserDefaults(key: "adminSalesDetails") {
            if let adminSalesDetails = UserDefaults.standard.retrieve(object: LoginResponse.self, fromKey: "adminSalesDetails") {
                if let tokenId = adminSalesDetails.data?.customer?.hash {
                    if !(tokenId.isEmpty) && tokenId != "" { adminTokenId = tokenId }
                }
                self.viewModal?.adminCustomerLoginRequest.id = customerId
                self.viewModal?.adminCustomerLoginRequest.tokenId = adminTokenId
                self.viewModal?.salesPersonAsCustomerLoginRequest()
            }
        }
    }
}
