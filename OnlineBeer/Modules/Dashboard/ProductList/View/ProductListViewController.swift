//
//  SubCategoryViewController.swift
//  Beer Connect
//
//  Created by Synsoft on 12/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit
import SDWebImage

class ProductListViewController: BaseViewController {
    
    // MARK: - ALL IBOUTLET CONNECTION & VARIABLE DECLARATIONS
    @IBOutlet weak var productdCollectionView: UICollectionView!
    @IBOutlet weak var productFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var imgEmptyCart: UIImageView!
    @IBOutlet weak var lblNoSearchData: UILabel!
    var isLoading = false
    var dashBoardViewModal: DashboardViewModal?
    var isfilterClear: Bool = false
    var viewModal: SearchViewModal?
    var productDetails = ProductCategory.init()

    var productId: String = ""
    var catId: String = ""
    var userId: String = ""
    var customerId: String = ""
    var navigationTitle: String = "Beer Category"
    var filterNameTitle: String = ""

    private var successMsg: String = ""
    private let spacing:CGFloat = 15.0
    private let CatSpacing:CGFloat = 2.0
    private var catIdStr = ""
    
    var orderByStr = ""
    var searchtxt: String? = ""
    
    var isComingFromSearch: Bool = false
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var catName: String = ""
    var isFilterApplied: Bool = false
    var catMainId: String = ""
    var minPrice: String = ""
    var maxPrice: String = ""
    var filteredData: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeViewModel()
        self.productdCollectionView.delegate = self
        self.productdCollectionView.dataSource = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func viewWillAppear(_ animated: Bool) {
        NetworkManager.shared.checkInternetConnectivity()
        self.manageNavigationBar()
        manageCollectionFlowLayout()
        getNotificationEvent()
        self.initComponents()
        managePullToRefresh()
    }
    
    func initComponents() {
        if self.isFilterApplied {
            self.viewModal?.getSearchProductsFromServer()
        } else {
            manageGetCatRequest()
            getAllCategory()
        }
        if #available(iOS 11.0, *) {
            self.productdCollectionView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
    }
    
    func getNotificationEvent() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.gotoHome(notification:)), name: Notification.Name("Home"), object: nil)
    }
    
    @objc func gotoHome(notification: Notification) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func manageGetCatRequest() {
        self.lblNoSearchData.isHidden = true
        self.viewModal?.searchRequest.currentPage = "1"
        self.viewModal?.searchRequest.customerId = self.userId
    }
    
    func managePullToRefresh() {
        self.refreshControl.addTarget(self, action: #selector(refresh),
                                      for: UIControl.Event.valueChanged)
        self.productdCollectionView.addSubview(refreshControl)
    }
    
    @objc func refresh(sender:AnyObject?) {
        self.viewModal?.searchRequest.currentPage = "1"
        self.getAllCategoriesFromServer()
    }
    
    func getAllCategoriesFromServer() {
        populateCategoryRequestDetails(catId: "", orderBy: self.orderByStr)
        getAllCategory()
    }
    
    func manageCollectionFlowLayout() {
        self.productFlowLayout?.scrollDirection = .vertical
        self.productFlowLayout?.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        self.productFlowLayout?.minimumLineSpacing = spacing
        self.productFlowLayout?.minimumInteritemSpacing = spacing
    }
    
    func manageNavigationBar() {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        self.appDelegate?.navigationController?.navigationBar.isHidden = true
        
        self.setNavigationLeftBarButton(viewController: self,
                                        isImage: true,
                                        imageName: "back",
                                        target: self,
                                        selector:  #selector(backMethodAction(_:)))
        
        let filterImage    = UIImage(named: "filter")!
        let sortImage  = UIImage(named: "sortby")!

        let filterButton = UIButton(type: .custom)
        filterButton.setImage(filterImage, for: .normal)
        filterButton.addTarget(self, action: #selector(filterMethodAction(_:)),
                               for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: filterButton)

        let sortButton = UIButton(type: .custom)
        sortButton.setImage(sortImage, for: .normal)
        sortButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        sortButton.addTarget(self, action: #selector(sortMethodAction(_:)), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: sortButton)

        self.navigationItem.rightBarButtonItems = [item1,item2]
        self.navigationController?.navigationBar.backgroundColor = .lightText
        
        if self.isComingFromSearch {
            self.navigationItem.title = NSLocalizedString("SEARCH_PRODUCT_TITLE", comment: "")
        }
    
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorConstants.APPBLUECOLOR,
            NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Bold", size: 34)!]
        }
        
    }
    
    @objc func sortMethodAction(_ sender: UIButton) {
        let sortVC: SortViewController = (UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD,
                        bundle: Bundle.main).instantiateViewController(withIdentifier:
                                                                VCIDENTIFIER.SORTVCID) as? SortViewController)!
        sortVC.modalPresentationStyle = .overCurrentContext
        sortVC.modalTransitionStyle = .crossDissolve
        self.tabBarController?.tabBar.isHidden = false
        sortVC.delegate = self
        guard let orderDetails = self.viewModal?.searchResponse?.orderBy else { return }
        sortVC.orderByDetails = orderDetails
        present(sortVC, animated: true, completion: nil)
    }
    
    @objc func filterMethodAction(_ sender: UIButton) {
        let filterVC: FilterViewController =
            (UIStoryboard.init(name: STORYBOARDCONS.ORDER,
                               bundle: Bundle.main).instantiateViewController(withIdentifier:
                                VCIDENTIFIER.FILTERVC) as? FilterViewController)!
        self.tabBarController?.tabBar.isHidden = true
       
        if !isfilterClear {
            if self.filteredData.count != 0 {
            
           if let mainArray = self.filteredData["mainArray"] as? [Any] {
                 filterVC.filterData = mainArray
           }
            if let filterId = self.filteredData["filteredId"] as? [Int] {
                  filterVC.arySelectedFilter = filterId
            }
            if let filterName = self.filteredData["filteredName"] as? [String] {
                 filterVC.arySelectedFilterName = filterName
            }
            if let minPrice = self.filteredData["startPrice"] as? String {
                filterVC.minPrice = minPrice
            }
            if let maxPrice = self.filteredData["endPrice"] as? String {
                filterVC.maxPrice = maxPrice
            }
        }
        }
        
        filterVC.callback = { (filterData) -> Void in
            if let iFilterClear = filterData["isFilterClear"] as? Bool {
                if iFilterClear == true {
                    self.isfilterClear = iFilterClear
                    self.viewModal?.searchRequest.currentPage = "1"
                    self.viewModal?.searchRequest.minPrice = ""
                    self.viewModal?.searchRequest.maxPrice = ""
                    self.getAllCategoriesFromServer()
                } else {
                    self.isfilterClear = false
                    self.manageFilterDate(filterDict: filterData)
                    self.filteredData = filterData
                }
            }
        }
        
        filterVC.clearCallback = { (filterData) -> Void in
            if let iFilterClear = filterData["isFilterClear"] as? Bool {
                if iFilterClear == true {
                    self.isfilterClear = iFilterClear
                    self.viewModal?.searchRequest.currentPage = "1"
                    self.viewModal?.searchRequest.minPrice = ""
                    self.viewModal?.searchRequest.maxPrice = ""
                    self.getAllCategoriesFromServer()
                }
            }
         //   self.manageFilterDate(filterDict: filterData)
         //   self.filteredData = filterData
        }
        self.navigationController?.pushViewController(filterVC, animated: true)
    }
    
    func manageFilterDate(filterDict: [String:Any]) {
        
        self.isFilterApplied = false
        var startPrice: String = ""
        var endPrice: String = ""
        var categoryMainId: String = ""
        
        if let stPrice = filterDict["startPrice"] as? String {
            if !stPrice.isEmpty && stPrice != "" {
                startPrice = stPrice
            }
        }
    
        if let edPrice = filterDict["endPrice"] as? String {
            if !edPrice.isEmpty && edPrice != "" {
                endPrice = edPrice
            }
        }
    
        if let catId = filterDict["catId"] as? String {
            categoryMainId = catId
        }
        
        self.viewModal?.searchRequest.currentPage = "1"
        self.viewModal?.searchRequest.orderBy = self.orderByStr
        self.viewModal?.searchRequest.customerId = self.userId
        self.viewModal?.searchRequest.minPrice = startPrice
        self.viewModal?.searchRequest.maxPrice = endPrice
           
        if categoryMainId.isEmpty || categoryMainId == "" {
            getAllCategory()
        } else {
            self.viewModal?.searchRequest.categoryId = categoryMainId
            self.searchtxt = ""
            self.isFilterApplied = true
        }
    }
    
    @objc func moveToNextPage() {
        let subCatVC: ProductListViewController = (UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD, bundle: Bundle.main).instantiateViewController(withIdentifier:
            VCIDENTIFIER.PRODUCTLISTVC) as? ProductListViewController)!
        subCatVC.catId = self.catMainId
        subCatVC.minPrice = self.minPrice
        subCatVC.maxPrice =   self.maxPrice
        self.navigationController?.pushViewController(subCatVC, animated: true)
    }
    
    @objc func backMethodAction(_ sender: UIButton) {
        self.filterNameTitle = ""
        self.isComingFromSearch = false
        self.isFilterApplied = false
        self.navigationController?.popViewController(animated: true)
    }
    
    func initializeViewModel() {
        self.getLoginDetails()
        viewModal = SearchViewModal(delegate: self)
        dashBoardViewModal = DashboardViewModal(delegate: self)
    }
    
    func getLoginDetails() {
        if UserDefaults.standard.isKeyPresentInUserDefaults(key: "loginUser") {
            if let loginDetails = UserDefaults.standard.retrieve(object: LoginResponse.self, fromKey: "loginUser") {
            guard let userId: String = loginDetails.data?.customer?.customerID else { return }
            self.userId = userId
            }
        }
    }
    
    func populateCategoryRequestDetails(catId: String? = "", orderBy: String? = "") {
        self.viewModal?.searchRequest.categoryId = catId
        self.viewModal?.searchRequest.orderBy = orderBy
        self.viewModal?.searchRequest.customerId = self.userId
    }
   
    func getAllCategory() {
        if let searchTxt = searchtxt {
            if !(searchTxt.isEmpty) {
                self.viewModal?.searchRequest.search = searchTxt
                self.viewModal?.getSearchProductsFromServer()
            }
        }
    }
}

extension ProductListViewController: SearchProtocol {
    func onSearchSuccess() {
        DispatchQueue.main.async {
            self.isLoading = false
            if self.viewModal?.arrRecentSearch.count ?? 0 > 0 {
                self.refreshControl.endRefreshing()
                self.productdCollectionView.isHidden = false
                self.productdCollectionView.reloadData()
                if self.isComingFromSearch {
                    self.lblNoSearchData.isHidden = true
                }
            } else {
                self.productdCollectionView.isHidden = true
                self.refreshControl.endRefreshing()
                if self.isComingFromSearch {
                    self.lblNoSearchData.isHidden = false
                    self.lblNoSearchData.text = "No search products found."
                }
            }
        }
    }
    
    func onSearchFailure(errorMsg: String) {
         DispatchQueue.main.async {
                   self.isLoading = false
                   self.refreshControl.endRefreshing()
                   let alertTitle = NSLocalizedString("ALERT_ERROR_TITLE", comment: "")
                   BaseViewController.showBasicAlert(message: errorMsg, title: alertTitle)
               }
    }
    
    func onValidationErrorAlert(title: String, message: String) { }

}

extension ProductListViewController:
    UICollectionViewDataSource,
    UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return self.viewModal?.arrRecentSearch.count ?? 0 }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            guard let bestSellercell: BestSellerProductCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier:
                COLLECTIONVIEWCELLID.BESTSELLERCATCELLID,
                                                                                                           for: indexPath) as? BestSellerProductCollectionCell else {
                                                                                                            return (collectionView.dequeueReusableCell(withReuseIdentifier: COLLECTIONVIEWCELLID.BESTSELLERCATCELLID,
                                                                                                                                                       for: indexPath) as? BestSellerProductCollectionCell)!
            }
        
        
        bestSellercell.layer.shouldRasterize = true
        bestSellercell.layer.rasterizationScale = UIScreen.main.scale
            
        if self.viewModal?.arrRecentSearch.count ?? 0 < indexPath.item { return bestSellercell }
            
        let productDetails = self.viewModal?.arrRecentSearch[indexPath.item]
            bestSellercell.disCountView.isHidden = true
            
            bestSellercell.btnProductWishlist.tag = indexPath.item
            bestSellercell.btnProductWishlist.addTarget(self, action: #selector(setWishlistActionMethod(sender:)), for: .touchUpInside)
            
            if let wishlistStr = productDetails?.wishlist?.lowercased().trim() {
                if wishlistStr == "yes" {
                    bestSellercell.btnProductWishlist.setBackgroundImage(UIImage(named: "wishlist"), for: .normal)
                } else {
                    bestSellercell.btnProductWishlist.setBackgroundImage(UIImage(named: "wishlistDisable"), for: .normal)
                }
            }
            bestSellercell.lblDiscountPrice.isHidden = true
            bestSellercell.lblRegularPrice.isHidden = true

            var regularPrc = ""

            if let regularPrice = productDetails?.regularPrice {
                if !regularPrice.isEmpty {
                    regularPrc = regularPrice
                    bestSellercell.lblRegularPrice.isHidden = false
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: regularPrc)
                    bestSellercell.lblRegularPrice.attributedText = attributeString
                }
            }
            
            if let salePrice = productDetails?.salePrice {
                if !(salePrice.isEmpty) && (salePrice != "") {
                    bestSellercell.lblDiscountPrice.isHidden = false
                    bestSellercell.lblRegularPrice.isHidden = false
                    bestSellercell.lblDiscountPrice.text = salePrice
                    
                    if !regularPrc.isEmpty {
                        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: regularPrc)
                        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                        bestSellercell.lblRegularPrice.attributedText = attributeString
                    }
                    
                    let mainPrc = regularPrc.replacingOccurrences(of: "$", with: "")
                    let salePrc = salePrice.replacingOccurrences(of: "$", with: "")
                    
                    let productPrc: Double = Double(mainPrc) ?? 0.0
                    let discountPrice: Double = Double(salePrc) ?? 0.0
                    
                   // let disCountedVal: Double = ((productPrc - discountPrice) / ((productPrc + discountPrice)/2)) * 100
                    let disCountedVal: Double = ((productPrc - discountPrice) / productPrc) * 100

                    
                    let disCountPercnt: Int = Int(disCountedVal)
                    if disCountedVal == 0 {
                        bestSellercell.disCountView.isHidden = true
                        bestSellercell.lblDiscountPrice.isHidden = true
                        bestSellercell.lblRegularPrice.isHidden = false
                        bestSellercell.lblRegularPrice.text = productPrc.description
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
                bestSellercell.lblProductTitle.isHidden = false
                bestSellercell.lblProductTitle.text = productName
            }
            
            if let productQuantity = productDetails?.productQuantity {
                bestSellercell.lblStockQuantity.text = "Stock Quantity: "+productQuantity.description
            }
            
            if let managingStock = productDetails?.managingStock {
                if !managingStock {
                      bestSellercell.lblStockQuantity.text = "In Stock"
                }
            }
            
            DispatchQueue.main.async {
                 if let imageURL = productDetails?.productImage {
                    bestSellercell.productTitleImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    bestSellercell.productTitleImage.sd_setImage(with: URL(string: imageURL), placeholderImage:  UIImage(named: "catDefault"),
                        options: [.continueInBackground, .delayPlaceholder],
                        completed: nil)
                 } else {
                    bestSellercell.productTitleImage.image = UIImage(named: "catDefault")
                }
            }
            return bestSellercell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            cell.layer.cornerRadius = 8
            cell.layer.masksToBounds =  false
            cell.layer.applySketchShadow(
                color: UIColor.black8,
                alpha: 1,
                x: 0,
                y: 4,
                blur: 23,
                spread: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            let numberOfItemsPerRow:CGFloat = 2
            let spacingBetweenCells:CGFloat = 15
            let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
            let width = (collectionView.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: 270)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.view.endEditing(true)
            guard let productDetails = self.viewModal?.arrRecentSearch[indexPath.item]
            else { return }
            self.navigateToProductDetailScreen(productDetails: productDetails)
        }
    }
}


extension ProductListViewController {
    func navigateToProductDetailScreen(productDetails: Product) {
        let productDetailVC: ProductDetailViewController =
            (UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD,
                               bundle: Bundle.main).instantiateViewController(withIdentifier:
                                VCIDENTIFIER.PRODUCTDETAILVC) as? ProductDetailViewController)!
        productDetailVC.productDetail = productDetails
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }
}

extension ProductListViewController {
    
    @objc func setWishlistActionMethod(sender: UIButton){
        let productDetails = self.viewModal?.searchResponse?.products?[sender.tag]
        
        if let productId = productDetails?.productID {
            self.productId = productId.description
            self.dashBoardViewModal?.wishlistRequest.productId = productId.description
            self.dashBoardViewModal?.wishlistRequest.userId = self.userId
            self.successMsg = ""
            self.dashBoardViewModal?.setUserWishlist()
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

extension ProductListViewController {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(!isLoading) {
            if ((productdCollectionView.contentOffset.y + productdCollectionView.frame.size.height) >= productdCollectionView.contentSize.height - 50) {

                loadMoredata()

            }
        }
    }

    //Pagination

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        if(!decelerate && !isLoading)
        {
            if ((productdCollectionView.contentOffset.y + productdCollectionView.frame.size.height) >= productdCollectionView.contentSize.height - 50)
            {
                loadMoredata()
            }
        }
    }
    
    func loadMoredata() {
        let totalCount = Int(self.viewModal?.searchResponse?.productCount ?? "0") ?? 0
        if (totalCount > self.viewModal?.arrRecentSearch.count ?? 0) {
            isLoading = true
            var pageNo = Int(self.viewModal?.searchRequest.currentPage ?? "1")
            pageNo = (pageNo ?? 1) + 1
            self.viewModal?.searchRequest.currentPage = String(pageNo ?? 1)
            self.getAllCategoriesFromServer()
        }
   }
}

// Dashboard Req/Res Delegates Methods
extension ProductListViewController: DashboardProtocol {
    func onFailure(errorMsg: String) {
    }
    func onCartFailure(errorMsg: String) {
        self.tabBarController?.tabBar.items?[2].badgeColor = .clear
        self.tabBarController?.tabBar.items?[2].badgeValue = nil
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
            if let successStr = self.dashBoardViewModal?.wishlistResponseMsg {
                self.successMsg = successStr
            }
            if !self.successMsg.isEmpty {
                self.view.makeToast(self.successMsg, duration: 1.0, position: .bottom)
            }
        }
        NotificationCenter.default.post(name: Notification.Name("refreshWishlist"), object: nil, userInfo: nil)
            if catId.count > 0 || !(catId.isEmpty) {
                self.populateCategoryRequestDetails(catId: catId)
                self.viewModal?.getSearchProductsFromServer()
            } else {
                self.getAllCategoriesFromServer()
            }
        }
    func onRecievedProductsSuccess() {}
    func getProductCartCount() {
        if UserDefaults.standard.isKeyPresentInUserDefaults(key: "loginUser") {

        if let loginDetails = UserDefaults.standard.retrieve(object: LoginResponse.self, fromKey: "loginUser") {
            if let customerID: String = loginDetails.data?.customer?.customerID {
                self.dashBoardViewModal?.cartCountRequest.customerId = customerID
                self.dashBoardViewModal?.cartCountRequest.cartId = customerID
                self.dashBoardViewModal?.getCartCountStatus()
            }
        }
        }
        
    }
}

extension ProductListViewController: SortProtocol {
    func getSortVal(sortVal: String) {
        self.tabBarController?.tabBar.isHidden = false
        orderByStr = sortVal
        self.viewModal?.searchRequest.currentPage = "1"
        if self.isFilterApplied {
            self.initComponents()
        } else { self.getAllCategoriesFromServer() }
    }
}
