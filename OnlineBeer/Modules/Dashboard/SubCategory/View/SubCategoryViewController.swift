//
//  SubCategoryViewController.swift
//  Beer Connect
//
//  Created by Synsoft on 12/02/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit
import SDWebImage

class SubCategoryViewController: BaseViewController {
    
    // MARK: - ALL IBOUTLET CONNECTION & VARIABLE DECLARATIONS
    @IBOutlet weak var catCollectionView: UICollectionView!
    @IBOutlet weak var productdCollectionView: UICollectionView!
    @IBOutlet weak var subCatCollectionFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var productFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var categoryCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var imgEmptyCart: UIImageView!
    @IBOutlet weak var lblNoSearchData: UILabel!
    var isLoading = false
    var isfilterClear: Bool = false
    var dashBoardViewModal: DashboardViewModal?
    
    var viewModal: SubCatViewModel?
    var productDetails = ProductCategory.init()
    var productCatDetails = Subcategory.init()

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
    var isComingFromDeals: Bool = false
    var isComingFromProductDetails: Bool = false
    var isComingFromNotification: Bool = false

    var productName: String = ""

    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var catName: String = ""
    var isFilterApplied: Bool = false
    var catMainId: String = ""
    var minPrice: String = ""
    var maxPrice: String = ""
    var productFromDetailId: String = ""
    var filteredData: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.catCollectionView.delegate = self
        self.catCollectionView.dataSource = self
        
        self.productdCollectionView.delegate = self
        self.productdCollectionView.dataSource = self
        
        initializeViewModel()
        self.viewModal?.subCatRequest.currentPage = "1"
        self.viewModal?.searchRequest.currentPage = "1"
        
        self.catMainId = self.catId
        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.catCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NetworkManager.shared.checkInternetConnectivity()
        manageCollectionFlowLayout()
        getNotificationEvent()
        self.initComponents()
        self.manageNavigationBar()
        managePullToRefresh()
    }
    
    func initComponents() {
        
        if self.isFilterApplied {
            self.viewModal?.getProductsDetailsFromServer()
        } else {
            manageGetCatRequest()
            getAllCategory()
        }
        
        if #available(iOS 11.0, *) {
            self.catCollectionView.contentInsetAdjustmentBehavior = .never
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
        self.viewModal?.subCatRequest.customerId = self.userId
        self.viewModal?.subCatRequest.userId = self.userId

        if self.isComingFromDeals {
        self.viewModal?.subCatRequest.catId = self.catId
        } else if self.isComingFromProductDetails {
            self.viewModal?.subCatRequest.catId = self.productFromDetailId
            
        } else {
            self.viewModal?.subCatRequest.catId = self.catMainId

            if (self.productDetails.categoryID != nil) && (self.productDetails.categoryID?.description != "") {
                guard let categoryId: Int = self.productDetails.categoryID else { return }
                self.viewModal?.subCatRequest.catId = categoryId.description
            } else if (!(self.productCatDetails.termID?.description.isEmpty ?? false)) && (self.productCatDetails.termID?.description != "") {
                guard let categoryId: Int = self.productCatDetails.termID else { return }
                self.viewModal?.subCatRequest.catId = categoryId.description
            }
        }
    }
    func managePullToRefresh() {
        self.refreshControl.addTarget(self, action: #selector(refresh),
                                      for: UIControl.Event.valueChanged)
        self.productdCollectionView.addSubview(refreshControl)
    }
    @objc func refresh(sender:AnyObject?) {
        self.viewModal?.subCatRequest.currentPage = "1"
        self.viewModal?.searchRequest.currentPage = "1"
        self.getAllCategoriesFromServer()
    }
    func getAllCategoriesFromServer() {
        var categoryId: String? = ""
        if !(self.productDetails.categoryID?.description.isEmpty ?? false) ||
            self.productDetails.categoryID?.description != nil {
            categoryId = self.productDetails.categoryID?.description
        } else if self.productCatDetails.termID?.description.isEmpty ?? false ||
                self.productCatDetails.termID?.description != nil {
            categoryId = self.productCatDetails.termID?.description
        }
        if isComingFromSearch { categoryId = self.productId }
        
        if isComingFromProductDetails { categoryId = self.productFromDetailId }
        
        if isComingFromNotification { categoryId = self.catMainId}
        
        if categoryId == "" ||  categoryId == nil {
            categoryId = self.catId
        }
        populateCategoryRequestDetails(catId: categoryId, orderBy: self.orderByStr)
        getAllCategory()
    }
    
    func manageCollectionFlowLayout() {
        self.productFlowLayout?.scrollDirection = .vertical
        self.productFlowLayout?.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        self.productFlowLayout?.minimumLineSpacing = spacing
        self.productFlowLayout?.minimumInteritemSpacing = spacing
        
        self.subCatCollectionFlowLayout?.scrollDirection = .horizontal
        self.subCatCollectionFlowLayout?.sectionInset = UIEdgeInsets(top: 0, left:CatSpacing, bottom: 0, right: CatSpacing)
        self.subCatCollectionFlowLayout?.minimumLineSpacing = CatSpacing
        self.subCatCollectionFlowLayout?.minimumInteritemSpacing = CatSpacing
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
        
        self.navigationItem.rightBarButtonItems = [item1, item2]
        self.navigationController?.navigationBar.backgroundColor = .lightText
        
        if self.isComingFromDeals {
            self.navigationItem.title = self.navigationTitle
        } else if self.filterNameTitle.isEmpty || self.filterNameTitle != "" {
            self.navigationItem.title = self.filterNameTitle
        } else if self.isComingFromSearch {
            self.navigationItem.title = NSLocalizedString("SEARCH_PRODUCT_TITLE", comment: "")
        } else if self.isComingFromProductDetails {
            self.navigationItem.title = self.productName
        } else if (!(self.productDetails.categoryName?.isEmpty ?? false) && self.productDetails.categoryName != "") {
            if let mainCatName = self.productDetails.categoryName {
                self.navigationItem.title = mainCatName
            }
        }
        
      //  if let catName = self.productCatDetails.name {
       //     self.navigationItem.title = catName
        //}
        
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
        self.tabBarController?.tabBar.isHidden = true
        sortVC.delegate = self
        guard let orderDetails = self.viewModal?.subCatResponse.orderBy else { return }
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
                    self.viewModal?.subCatRequest.currentPage = "1"
                    self.viewModal?.subCatRequest.minprice = ""
                    self.viewModal?.subCatRequest.maxprice = ""
                    self.getAllCategoriesFromServer()
                } else {
                    self.isfilterClear = false
                    self.manageFilterDate(filterDict: filterData)
                    self.filteredData = filterData
                }
            }
         //   self.manageFilterDate(filterDict: filterData)
         //   self.filteredData = filterData
        }
        
        
        filterVC.clearCallback = { (filterData) -> Void in
            if let iFilterClear = filterData["isFilterClear"] as? Bool {
                if iFilterClear == true {
                    self.isfilterClear = iFilterClear
                    self.viewModal?.subCatRequest.currentPage = "1"
                    self.viewModal?.subCatRequest.minprice = ""
                    self.viewModal?.subCatRequest.maxprice = ""
                    self.getAllCategoriesFromServer()
                } else {
                    self.isfilterClear = false
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
            self.viewModal?.subCatRequest.currentPage = "1"
            self.viewModal?.subCatRequest.orderBy = self.orderByStr
            self.viewModal?.subCatRequest.customerId = self.userId
            self.viewModal?.subCatRequest.userId = self.userId
            self.viewModal?.subCatRequest.minprice = startPrice
            self.viewModal?.subCatRequest.maxprice = endPrice
           
        if categoryMainId.isEmpty || categoryMainId == "" {
                
                if !(self.productDetails.categoryID?.description.isEmpty ?? false) && self.productDetails.categoryID?.description != "" {
                    if let mainCatId  = self.productDetails.categoryID?.description {
                        self.viewModal?.subCatRequest.catId = mainCatId
                    }
                } else if !(self.productCatDetails.termID?.description.isEmpty ?? false) && self.productCatDetails.termID?.description != "" {
                    if let mainCatId  = self.productCatDetails.termID?.description {
                        self.viewModal?.subCatRequest.catId = mainCatId
                    }
                } else if isComingFromDeals {
                    self.populateCategoryRequestDetails(catId: catId)
                } else if self.isComingFromProductDetails {
                    self.populateCategoryRequestDetails(catId: self.productFromDetailId)
                }
                if isComingFromSearch {
                    self.viewModal?.subCatRequest.catId = self.productId
                    getAllCategory()
                }
                self.viewModal?.getProductsFromServerByCategory()

            } else {
                
                self.viewModal?.subCatRequest.catId = categoryMainId
                self.isFilterApplied = true
//                if let catName = filterDict["catName"] as? String {
//                    self.navigationItem.title  = catName
//                    self.viewModal?.subCatResponse.catName = catName
//                }
                
//                if let subCate = filterDict["subCategories"] as? [Subcategory] {
//                    self.viewModal?.subCatResponse.subcategories = subCate
//                    self.catCollectionView.reloadData()
//                }
                                
//                self.catMainId = categoryMainId
//                self.minPrice = startPrice
//                self.maxPrice = endPrice
//                self.perform(#selector(moveToNextPage), with: nil, afterDelay: 1.0)
//                let subCatVC: SubCategoryViewController = (UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD, bundle: Bundle.main).instantiateViewController(withIdentifier:
//                    VCIDENTIFIER.SUBCATEGORYVC) as? SubCategoryViewController)!
//                subCatVC.catMainId = categoryMainId
//                subCatVC.minPrice = startPrice
//                subCatVC.maxPrice = endPrice
//                self.navigationController?.pushViewController(subCatVC, animated: true)
            }

    }
    
    @objc func moveToNextPage() {
        let subCatVC: SubCategoryViewController = (UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD, bundle: Bundle.main).instantiateViewController(withIdentifier:
            VCIDENTIFIER.SUBCATEGORYVC) as? SubCategoryViewController)!
        subCatVC.catId = self.catMainId
        subCatVC.minPrice = self.minPrice
        subCatVC.maxPrice =   self.maxPrice
        subCatVC.isComingFromDeals = false
        self.navigationController?.pushViewController(subCatVC, animated: true)
    }
    
    @objc func backMethodAction(_ sender: UIButton) {
        self.filterNameTitle = ""
        self.isComingFromDeals = false
        self.isComingFromSearch = false
        self.isComingFromProductDetails = false
        self.isFilterApplied = false
        self.navigationController?.popViewController(animated: true)
    }
    
    func initializeViewModel() {
        self.getLoginDetails()
        viewModal = SubCatViewModel(delegate: self)
        dashBoardViewModal = DashboardViewModal(delegate: self)
    }
    
    func getLoginDetails() {
        if let loginDetails = UserDefaults.standard.retrieve(object: LoginResponse.self, fromKey: "loginUser") {
                guard let userId: String = loginDetails.data?.customer?.customerID else { return }
                self.userId = userId
             }
    }
    
    func populateCategoryRequestDetails(catId: String? = "", orderBy: String? = "") {
        self.viewModal?.subCatRequest.catId = catId
        //self.viewModal?.subCatRequest.currentPage = "1"
        self.viewModal?.subCatRequest.orderBy = orderBy
        self.viewModal?.subCatRequest.customerId = self.userId
        self.viewModal?.subCatRequest.userId = self.userId
    }
    
    func getAllCategory() {
        
        if let searchTxt = searchtxt {
            if !(searchTxt.isEmpty) {
                self.viewModal?.searchRequest.customerId = self.userId
                self.viewModal?.getProductsDetailsFromServer(searchText: searchTxt)
            } else {
                self.viewModal?.getProductsDetailsFromServer()
            }
        }
        
    }
}

extension SubCategoryViewController: SubCatProtocol {
    
    func onRecievedProductSuccess() {
        DispatchQueue.main.async {
            self.isLoading = false
            if self.viewModal?.arrCatProduct?.count ?? 0 > 0 {
                self.refreshControl.endRefreshing()
                self.catCollectionView.reloadData()
                self.catCollectionView.isHidden = false
                self.categoryCollectionHeight.constant = 80.0
            } else {
                self.refreshControl.endRefreshing()
                self.catCollectionView.isHidden = true
                self.categoryCollectionHeight.constant = 0.0
            }

            if let navCatName = self.viewModal?.subCatResponse.catName {
                self.filterNameTitle = navCatName
                self.title = navCatName
                self.navigationController?.navigationItem.title = navCatName
            }
            
            if self.viewModal?.arrProducts?.count ?? 0 > 0 {
                self.refreshControl.endRefreshing()
                self.productdCollectionView.isHidden = false
                self.productdCollectionView.reloadData()
                if self.isComingFromSearch {
                    self.lblNoSearchData.isHidden = true
                }
                self.imgEmptyCart.isHidden = true
            } else {
                self.productdCollectionView.isHidden = true
                self.refreshControl.endRefreshing()
                if self.isComingFromSearch {
                    self.lblNoSearchData.isHidden = false
                    self.lblNoSearchData.text = "No search products found."
                } else {
                    self.imgEmptyCart.isHidden = false
                }
            }

        }
    }
    
    func onFailure(errorMsg: String) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.refreshControl.endRefreshing()
            let alertTitle = NSLocalizedString("ALERT_ERROR_TITLE", comment: "")
            BaseViewController.showBasicAlert(message: errorMsg, title: alertTitle)
        }
    }
}

extension SubCategoryViewController:
    UICollectionViewDataSource,
    UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.catCollectionView {
            return self.viewModal?.arrCatProduct?.count ?? 0
        } else {
            return self.viewModal?.arrProducts?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.catCollectionView {

            guard let catCell: CategoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier:
                COLLECTIONVIEWCELLID.CATCOLLECTIONCELLID,
                                                                                               for: indexPath) as? CategoryCollectionViewCell else {
                                                                                                return (collectionView.dequeueReusableCell(withReuseIdentifier: COLLECTIONVIEWCELLID.CATCOLLECTIONCELLID,
                                                                                                                                           for: indexPath) as? CategoryCollectionViewCell)!
            }
            
            catCell.layer.shouldRasterize = true
            catCell.layer.rasterizationScale = UIScreen.main.scale
            
            let subCatDetails = self.viewModal?.arrCatProduct?[indexPath.item]
         
            catCell.lblCatTitle.isHidden = true
            
            if let name = subCatDetails?.name {
                catCell.lblCatTitle.isHidden = false
                catCell.lblCatTitle.text = name
            }
            
            DispatchQueue.main.async {
                if let imageURL = self.viewModal?.subCatResponse.categoryImage {
                    catCell.catImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    catCell.catImage.sd_setImage(with: URL(string: imageURL), placeholderImage:  UIImage(named: "catDefault"),
                    options: [.continueInBackground, .delayPlaceholder],
                    completed: nil)

                } else {
                    catCell.catImage.image = UIImage(named: "catDefault")
                }
            }
            return catCell
            
        } else {
            
            guard let bestSellercell: BestSellerProductCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier:
                COLLECTIONVIEWCELLID.BESTSELLERCATCELLID,
                                                                                                           for: indexPath) as? BestSellerProductCollectionCell else {
                                                                                                            return (collectionView.dequeueReusableCell(withReuseIdentifier: COLLECTIONVIEWCELLID.BESTSELLERCATCELLID,
                                                                                                                                                       for: indexPath) as? BestSellerProductCollectionCell)!
            }
            
            bestSellercell.layer.shouldRasterize = true
            bestSellercell.layer.rasterizationScale = UIScreen.main.scale
            
            if self.viewModal?.arrProducts?.count ?? 0 < indexPath.item {
                 return bestSellercell
            }
            
        
            let productDetails = self.viewModal?.arrProducts?[indexPath.item]
            bestSellercell.disCountView.isHidden = true
        
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
                    
                    //let disCountedVal: Double = ((productPrc - discountPrice) / ((productPrc + discountPrice)/2)) * 100
                    
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
            
            return bestSellercell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == self.catCollectionView {
        } else {
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
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.catCollectionView {
            
            let numberOfItemsPerRow:CGFloat = 4
            let spacingBetweenCells:CGFloat = 5
            
            let totalSpacing = (0 * self.CatSpacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
            let width = (collectionView.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: width)
            
        } else {
            
            let numberOfItemsPerRow:CGFloat = 2
            let spacingBetweenCells:CGFloat = 15
            let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
            let width = (collectionView.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: 270)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == self.catCollectionView {
            return UIEdgeInsets(top: 0 ,left: 0, bottom: 0 , right: 0)
            
        } else {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.catCollectionView {
            let categoryDetails = self.viewModal?.arrCatProduct?[indexPath.item]
            guard let mainCatId = categoryDetails?.termID?.description else { return }
            catIdStr = mainCatId
            self.navigateToSubCatVC(catDetails: categoryDetails ?? Subcategory.init())
            //print("Main Cat Id \(catIdStr)")
            //self.populateCategoryRequestDetails(catId: catIdStr)
            //self.viewModal?.getProductsFromServerByCategory()
        } else {
            guard let productDetails = self.viewModal?.arrProducts?[indexPath.item] else { return }
            navigateToProductDetailScreen(productDetails: productDetails)
        }
    }
    
}

extension SubCategoryViewController {
    
    func navigateToSubCatVC(catDetails: Subcategory) {
        
    let subCatVC: SubCategoryViewController = (UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD,
                                                                          bundle: Bundle.main).instantiateViewController(withIdentifier:
                                                                            VCIDENTIFIER.SUBCATEGORYVC) as? SubCategoryViewController)!
             
        subCatVC.userId = self.userId
        subCatVC.catId = catIdStr
        subCatVC.productCatDetails = catDetails
        self.navigationController?.pushViewController(subCatVC, animated: true)
    }
}

extension SubCategoryViewController {
    
    func navigateToProductDetailScreen(productDetails: Product) {
        let productDetailVC: ProductDetailViewController =
            (UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD,
                               bundle: Bundle.main).instantiateViewController(withIdentifier:
                                VCIDENTIFIER.PRODUCTDETAILVC) as? ProductDetailViewController)!
        productDetailVC.productDetail = productDetails
        self.navigationController?.pushViewController(productDetailVC, animated: true)
    }
}

extension SubCategoryViewController {
    
    @objc func setWishlistActionMethod(sender: UIButton){
        let productDetails = self.viewModal?.subCatResponse.products[sender.tag]
        
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

extension SubCategoryViewController {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(!isLoading)

        {
            if ((productdCollectionView.contentOffset.y + productdCollectionView.frame.size.height) >= productdCollectionView.contentSize.height - 50)

            {

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
    
    func loadMoredata()
    {
        let totalCount = Int(self.viewModal?.subCatResponse.productCount ?? "0") ?? 0
        if( totalCount > self.viewModal?.arrProducts?.count ?? 0) {
            isLoading = true
            var pageNo = Int(self.viewModal?.subCatRequest.currentPage ?? "1")
            pageNo = (pageNo ?? 1) + 1
            self.viewModal?.subCatRequest.currentPage = String(pageNo ?? 1)
            self.viewModal?.searchRequest.currentPage = String(pageNo ?? 1)
            self.getAllCategoriesFromServer()
//            self.viewModal?.searchRequest.search = txtMainSearch.text ?? ""
//            self.viewModal?.searchProductFromServer()
        }
   }
}

// Dashboard Req/Res Delegates Methods
extension SubCategoryViewController: DashboardProtocol {
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
        if self.isComingFromDeals {
            self.populateCategoryRequestDetails(catId: catId)
            self.viewModal?.getProductsFromServerByCategory()
        } else {
            if catId.count > 0 || !(catId.isEmpty) {
                self.populateCategoryRequestDetails(catId: catId)
                self.viewModal?.getProductsFromServerByCategory()
            } else {
                self.getAllCategoriesFromServer()
            }
        }
    }
    func onRecievedProductsSuccess() {}
    func getProductCartCount() {
        if let loginDetails = UserDefaults.standard.retrieve(object: LoginResponse.self, fromKey: "loginUser") {
            if let customerID: String = loginDetails.data?.customer?.customerID {
                self.dashBoardViewModal?.cartCountRequest.customerId = customerID
                self.dashBoardViewModal?.cartCountRequest.cartId = customerID
                self.dashBoardViewModal?.getCartCountStatus()
            }
        }
    }
}

extension SubCategoryViewController: SortProtocol {
    func getSortVal(sortVal: String) {
        self.tabBarController?.tabBar.isHidden = false
        orderByStr = sortVal
        self.viewModal?.searchRequest.currentPage = "1"
        self.viewModal?.subCatRequest.currentPage = "1"
        if isComingFromDeals {
            if (!self.catId.isEmpty) && (self.catId != "") {
                self.populateCategoryRequestDetails(catId: catId,orderBy: self.orderByStr)
                self.viewModal?.getProductsFromServerByCategory()
            }
        } else if catIdStr.count > 0 || !(catIdStr.isEmpty) {
            self.populateCategoryRequestDetails(catId: catIdStr,orderBy: self.orderByStr)
            self.viewModal?.getProductsFromServerByCategory()
        } else if isComingFromProductDetails {
            self.populateCategoryRequestDetails(catId: self.productId,orderBy: self.orderByStr)
            self.viewModal?.getProductsFromServerByCategory()
        } else if self.isFilterApplied {
            self.initComponents()
        } else if isComingFromNotification {
            self.populateCategoryRequestDetails(catId: self.catMainId,orderBy: self.orderByStr)
            self.viewModal?.getProductsFromServerByCategory()
        } else {
            self.getAllCategoriesFromServer()
        }
    }
}
