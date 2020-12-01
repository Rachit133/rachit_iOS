//
//  SearchViewController.swift
//  Beer Connect
//
//  Created by Synsoft on 31/01/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController {

   @IBOutlet weak var txtMainSearch: UITextField!
   @IBOutlet weak var tblProductSearch: UITableView!
   @IBOutlet weak var imgViewNoData: UIImageView!
   let appDelegate = UIApplication.shared.delegate as! AppDelegate

   var timer = Timer()
   var viewModal: SearchViewModal?
   var arrRecentSearch = [Product].init()
   var isRecentItemAvailable = false
   var isLoading = false
    var searchText: String = ""
   override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      NotificationCenter.default.addObserver(self, selector: #selector(self.clearSearchText), name: Notification.Name("clearSearchData"), object: nil)
   }
    
    @objc func clearSearchText() {
        self.viewModal?.arrRecentSearch = []
        self.viewModal?.searchResponse?.productCount = "0"
        self.viewModal?.searchRequest.currentPage = "1"
        self.viewModal?.searchResponse?.products = []
        self.imgViewNoData.isHidden = true
        self.tblProductSearch.reloadData()
    }
   
   override func viewWillAppear(_ animated: Bool) {
       NetworkManager.shared.checkInternetConnectivity()
      initComponents()
      if self.arrRecentSearch.count > 0 {
         self.tblProductSearch.reloadData()
      }
      self.manageNavigationUI()
   }
}

// MARK: - Method Initiation
extension SearchViewController {
   func initComponents() {
      initializeSearchViewModel()
      openSearchTextField()
   }

   func initializeSearchViewModel() {
      self.tblProductSearch.delegate = self
      self.tblProductSearch.dataSource = self
      self.viewModal = SearchViewModal(delegate: self)
   }
   func openSearchTextField() {
      self.txtMainSearch.becomeFirstResponder()
      self.txtMainSearch.modifyClearButtonWithImage(image: UIImage(named: "clearBtn") ?? UIImage.init())

   }
   
   func manageNavigationUI() {
      self.appDelegate.navigationController?.navigationBar.isHidden = true
      self.navigationController?.navigationBar.isHidden = false
      self.title = NSLocalizedString("SEARCH_TITLE", comment: "")
      self.navigationItem.backBarButtonItem?.title = ""
      self.setNavigationLeftBarButton(viewController: self, isImage: true, imageName: "back", target: self, selector:  #selector(backMethodAction(_:)))
     // self.setNavigationRightBarButton(viewController: self, isImage: true, imageName: "filter", target: self, selector:#selector(filterMethodAction(_:)))
      
      if #available(iOS 11, *) {
          self.navigationController?.navigationBar.prefersLargeTitles = true
          self.navigationController?.navigationItem.largeTitleDisplayMode = .always
         self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorConstants.APPBLUECOLOR,
         NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Bold", size: 34)!]
        
      }
   }
   
   @objc func filterMethodAction(_ sender: UIButton) {
      let filterVC: FilterViewController =
          (UIStoryboard.init(name: STORYBOARDCONS.ORDER,
                             bundle: Bundle.main).instantiateViewController(withIdentifier:
                               VCIDENTIFIER.FILTERVC) as? FilterViewController)!
       self.tabBarController?.tabBar.isHidden = true
      self.navigationController?.pushViewController(filterVC, animated: true)
   }
   
   @objc func backMethodAction(_ sender: UIButton) {
      self.tabBarController?.selectedIndex = 0
      self.navigationController?.popViewController(animated: true)
   }
}

extension SearchViewController: UITextFieldDelegate {

   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      let textFieldText: NSString = (textField.text ?? "") as NSString
      var txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
      txtAfterUpdate = txtAfterUpdate.trim()
      searchText = txtAfterUpdate
      stopPreventingFromContinuesTyping()
      return true
   }
   
    func stopPreventingFromContinuesTyping() {
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                                  selector: #selector(getSearchProducts),
                                                  object: nil)
        self.perform(#selector(getSearchProducts),
                         with: nil,
                         afterDelay: 0.5)
    }
    
    @objc func getSearchProducts() {
        NetworkManager.shared.checkInternetConnectivity()
        if self.searchText.count == 0 { clearSearchDetails() }
        else if self.searchText.count > 2 {
            //self.txtMainSearch.resignFirstResponder()
            self.callSearchProductAPI(updateTxt: self.searchText)
        }
    }
    
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      goToSearchProducts()
      return true
   }
   
   func callSearchProductAPI(updateTxt: String) {
      self.viewModal?.searchRequest.search = updateTxt
      self.viewModal?.searchRequest.currentPage = "1"
      self.viewModal?.searchProductFromServer()
   }
   
   func clearSearchDetails() {
      self.viewModal?.searchResponse?.products?.removeAll()
      self.viewModal?.arrRecentSearch.removeAll()
      self.tblProductSearch.reloadData()
      self.tblProductSearch.isHidden = true
   }
}


extension SearchViewController {
   func goToSearchProducts() {
    
    if self.txtMainSearch.text?.isEmpty ?? false {
        self.view.makeToast(NSLocalizedString("Enter some text to search products.", comment: ""), duration: 2.0, position: .bottom)
      } else {
         let productListVC: ProductListViewController = (UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD,
         bundle: Bundle.main).instantiateViewController(withIdentifier:
           VCIDENTIFIER.PRODUCTLISTVC) as? ProductListViewController)!
         productListVC.searchtxt = self.txtMainSearch.text
         productListVC.isComingFromSearch = true
         self.navigationController?.pushViewController(productListVC, animated: true)
      }
   }
}

// MARK: - SEARCH PRODUCTS API Response
extension SearchViewController: SearchProtocol {
   
   func onSearchSuccess() {
      DispatchQueue.main.async {
        self.isLoading = false
         if self.viewModal?.arrRecentSearch == nil || self.viewModal?.arrRecentSearch.count == 0 {
            self.tblProductSearch.isHidden = true
            self.imgViewNoData.isHidden = false
         } else {
            self.imgViewNoData.isHidden = true
            self.tblProductSearch.isHidden = false
            self.tblProductSearch.reloadData()
         }
      }
   }
   
   func onLoginFailure(errorMsg: String) {
      DispatchQueue.main.async {
         self.isLoading = false
         let alertTitle = NSLocalizedString("ALERT_ERROR_TITLE", comment: "")
         BaseViewController.showBasicAlert(message: "Currently Server not responding. Please try later", title: alertTitle)
      }
   }

   func onSearchFailure(errorMsg: String) {
      DispatchQueue.main.async {
         let alertTitle = NSLocalizedString("ALERT_ERROR_TITLE", comment: "")
         BaseViewController.showBasicAlert(message: errorMsg, title: alertTitle)
      }
   }
   
   func onValidationErrorAlert(title: String, message: String) {
      DispatchQueue.main.async {
         BaseViewController.showBasicAlert(message: message, title: title)
      }
   }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
   
   func tableView(_ tableView: UITableView,
                  numberOfRowsInSection section: Int) -> Int {
    
    return self.viewModal?.arrRecentSearch.count ?? 0
     // if self.viewModal?.searchResponse?.products?.count == 0 {
      //   return self.arrRecentSearch.count
   //  } else {
//      if self.viewModal?.searchResponse?.products?.count ?? 0 >= 10 {
//         return 10
//      } else {
//         return self.viewModal?.searchResponse?.products?.count ?? 0
//      }
   }
   
   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      if self.arrRecentSearch.count > 0 {
         let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
           label.textColor = UIColor.red
           label.font = openSansBold18
           label.text = "Recents search \(self.arrRecentSearch.count)"
           return label
      }
      return UIView.init()
   }
   
   func tableView(_ tableView: UITableView,
                  cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let searchCell = tableView.dequeueReusableCell(withIdentifier:
                                                      TABLEVIEWCELLID.SEARCHPRODUCTCELLID,
                                                      for: indexPath) as? SearchProductCell
    if ((self.viewModal?.arrRecentSearch.count ?? 0)-1 < indexPath.row) {
            return searchCell ?? UITableViewCell.init()
      }
      let productDetails = self.viewModal?.arrRecentSearch[indexPath.row]
      
      if productDetails != nil {
         
         var productName: String = ""
         
         if productDetails?.productName != nil && !(productDetails?.productName?.isEmpty ?? false) {
            productName = productDetails?.productName ?? ""
            
            let attrString: NSMutableAttributedString = NSMutableAttributedString(string: productName)
            let range = (productName as NSString).range(of: self.txtMainSearch.text ?? "", options: .caseInsensitive)
            attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.darkBlueGrey, range: range)
            searchCell?.lblProductTitle.attributedText = attrString
            searchCell?.imgProduct?.image = UIImage(named: "mainSearch")
         }
      }
      return searchCell ?? UITableViewCell.init()
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 52
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
      let productDetails = (self.viewModal?.arrRecentSearch[indexPath.row]) ?? Product.init()
      self.navigateToProductDetailScreen(productDetails: productDetails)
   
   }
    
   func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if(!isLoading)

        {
            if ((tblProductSearch.contentOffset.y + tblProductSearch.frame.size.height) >= tblProductSearch.contentSize.height - 50)

            {

                loadMoredata()

            }
        }
    }

    //Pagination

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        if(!decelerate && !isLoading)
        {
            if ((tblProductSearch.contentOffset.y + tblProductSearch.frame.size.height) >= tblProductSearch.contentSize.height - 50)
            {
                loadMoredata()
            }
        }
    }
    
    func loadMoredata() {
        let totalCount = Int(self.viewModal?.searchResponse?.productCount ?? "0") ?? 0
        if( totalCount > self.viewModal?.arrRecentSearch.count ?? 0) {
            isLoading = true
            var pageNo = Int(self.viewModal?.searchRequest.currentPage ?? "1")
            pageNo = (pageNo ?? 1) + 1
            self.viewModal?.searchRequest.currentPage = String(pageNo ?? 1)
            self.viewModal?.searchRequest.search = txtMainSearch.text ?? ""
            self.viewModal?.searchProductFromServer()
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.viewModal?.arrRecentSearch = []
        self.viewModal?.searchResponse?.products = []
        self.viewModal?.searchResponse?.productCount = "0"
        self.viewModal?.searchRequest.currentPage = "1"
        self.imgViewNoData.isHidden = true
        self.tblProductSearch.reloadData()
        return true
    }


}

extension SearchViewController {
   func navigateToProductDetailScreen(productDetails: Product) {
      let productDetailVC: ProductDetailViewController =
         (UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD,
                            bundle: Bundle.main).instantiateViewController(withIdentifier:
                              VCIDENTIFIER.PRODUCTDETAILVC) as? ProductDetailViewController)!
      productDetailVC.productDetail = productDetails
      self.navigationController?.pushViewController(productDetailVC, animated: true)
   }
}
