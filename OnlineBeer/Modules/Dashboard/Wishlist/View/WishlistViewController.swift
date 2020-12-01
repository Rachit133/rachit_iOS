//
//  WishlistViewController.swift
//  Beer Connect
//
//  Created by Synsoft on 31/01/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit
import SDWebImage

class WishlistViewController: BaseViewController {
    
    @IBOutlet weak var wishlistTableView: UITableView!
    @IBOutlet weak var imgEmptyWishlist: UIImageView!
    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    var viewModel: WishlistViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NetworkManager.shared.checkInternetConnectivity()
        initComponents()
        self.getNotificationEvent()
        self.manageNavigationUI()
    }

   func getNotificationEvent() {
      NotificationCenter.default.addObserver(self,
                                             selector: #selector(self.refreshWishlist),
                                             name: Notification.Name("refreshWishlist"),
                                             object: nil)
   }
   
   @objc func refreshWishlist() {
      
      fetchWishlistProducts()
   }
   
   deinit {
     NotificationCenter.default.removeObserver(self, name: Notification.Name("refreshWishlist"), object: nil)
   }

}

// MARK: INIT COMPONENTS & OTHER OPERATIONS
extension WishlistViewController {
    func initComponents() {
        initializeViewModel()
        managePullToRefresh()
        fetchWishlistProducts()
    }
    
    func initializeViewModel() {
        self.viewModel = WishlistViewModel(delegate: self)
    }
    
    func managePullToRefresh() {
       self.refreshControl.addTarget(self, action: #selector(refresh),
                                          for: UIControl.Event.valueChanged)
      self.wishlistTableView.addSubview(refreshControl)
    }
    
    @objc func refresh(sender:AnyObject?) {
        NetworkManager.shared.checkInternetConnectivity()
        fetchWishlistProducts()
    }
    
    func fetchWishlistProducts() {
      DispatchQueue.main.async {
         self.wishlistTableView.isHidden = true
         self.imgEmptyWishlist.isHidden = true
      }
        if let loginDetails = UserDefaults.standard.retrieve(object:
            LoginResponse.self,
                                                             fromKey: "loginUser") {
            if let customerId = loginDetails.data?.customer?.customerID {
                viewModel?.getWishlistRequest.userId = customerId
            }
            self.viewModel?.getWishlistProductFromServer()
        }
    }
    
    func manageNavigationUI(){
        self.appDelegate?.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        // self.setNavigationLeftBarButton(viewController: self, isImage: true, imageName: "back", target: self, selector:  #selector(backMethodAction(_:)))
        //self.title = "Wishlist"
        self.navigationController?.navigationItem.title = "Wishlist"
        if #available(iOS 11.0, *) {
           self.navigationController?.navigationBar.prefersLargeTitles = true
           self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorConstants.APPBLUECOLOR,
           NSAttributedString.Key.font: UIFont(name: "SFProDisplay-Bold", size: 34)!]
        }
    }
    
    @IBAction func backBtnMethodAction(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
}

// MARK: TABLEVIEW DELEGATE & DATASOURCE METHODS
extension WishlistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.arrWishlistProducts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fetchWishlistCell = tableView.dequeueReusableCell(withIdentifier:
            TABLEVIEWCELLID.FETCHWISHLISTCELLID,
                                                              for: indexPath) as? FetchWishlistCell
        fetchWishlistCell?.backFetchWishlistView.layer.cornerRadius = 8
        fetchWishlistCell?.backFetchWishlistView.layer.masksToBounds =  false
        fetchWishlistCell?.backFetchWishlistView.layer.applySketchShadow(color: UIColor.black8, alpha: 1.0, x: 0, y: 4, blur: 23.0, spread: 0)
        
        fetchWishlistCell?.lblQuantityCount.isHidden = true
        
        let productDetails = self.viewModel?.arrWishlistProducts?[indexPath.row]
        
        if let productName  = productDetails?.productName {
            fetchWishlistCell?.lblTitle.text = productName
        }
        
        DispatchQueue.main.async {
            if let productImage = productDetails?.productImage {
                fetchWishlistCell?.titleImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
                fetchWishlistCell?.titleImage.sd_setImage(with: URL(string: productImage), placeholderImage:  UIImage(named: "catDefault"),
                options: [.continueInBackground, .delayPlaceholder],
                completed: nil)
               // sd_setImage(with: URL(string: productImage), placeholderImage: UIImage(named: "catDefault"))
            } else {
                fetchWishlistCell?.titleImage.image = UIImage(named: "catDefault")
            }
        }
        
        if let price = productDetails?.productPrice {
          //  fetchWishlistCell?.btnPrice.setTitle("  "+price, for: .normal)
             fetchWishlistCell?.lblPrice.text = " " + price
        }
        
        if let price = productDetails?.productPrice {
             
             if let salePrice = productDetails?.salePrice, salePrice != "" {
                 
                 if price != salePrice {
                     
                     let attributeString1: NSMutableAttributedString =  NSMutableAttributedString(string:
                        "  " + salePrice )
                     
                     let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: " " + price)
                     attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                     
                     let combination = NSMutableAttributedString()

                     combination.append(attributeString)
                     combination.append(attributeString1)
                     fetchWishlistCell?.lblPrice.attributedText = combination
                   // fetchWishlistCell?.btnPrice.setAttributedTitle(combination, for: .normal)

                 } else {
                    fetchWishlistCell?.lblPrice.text = " " + price
                    
                   // fetchWishlistCell?.btnPrice.setTitle("  "+price, for: .normal)
                 }
             } else {
                fetchWishlistCell?.lblPrice.text = " " + price
                 //fetchWishlistCell?.btnPrice.setTitle("  "+price, for: .normal)
             }
           }
        
        
        if let quntity  = productDetails?.productQuantity?.description {
            fetchWishlistCell?.lblQuantityCount.isHidden = false
            fetchWishlistCell?.lblQuantityCount.text =         NSLocalizedString("STOCK_QUANTITY_TITLE", comment: "")+quntity
        }
        
        if let managingStock = productDetails?.managingStock {
            if !managingStock {
                  fetchWishlistCell?.lblQuantityCount.text = "In Stock"
            }
        }
        return fetchWishlistCell ?? UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print("Tab Index is \(indexPath.item)")
        if let productDetails = self.viewModel?.arrWishlistProducts?[indexPath.row] {
            self.navigateToProductDetailScreen(productDetails: productDetails)
        }
      }
}


// MARK: MANAGE WISHLIST RESPONSE
extension WishlistViewController: FetchWishlistProtocol {
    func onReceivedWishlistSuccess() {
        DispatchQueue.main.async {
            if self.viewModel?.arrWishlistProducts?.count ?? 0 > 0 {
                self.refreshControl.endRefreshing()
                self.wishlistTableView.isHidden = false
                self.imgEmptyWishlist.isHidden = true
                self.wishlistTableView.reloadData()
            } else {
                self.refreshControl.endRefreshing()
                self.imgEmptyWishlist.isHidden = false
                self.wishlistTableView.isHidden = true
            }
        }
    }
    
    func onFailure(errorMsg: String) {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.view.makeToast(errorMsg, duration: 2.0, position: .bottom)
        }
        
    }
}

extension WishlistViewController {
   func navigateToProductDetailScreen(productDetails: Product) {
      let productDetailVC: ProductDetailViewController =
         (UIStoryboard.init(name: STORYBOARDCONS.DASHBOARD,
                            bundle: Bundle.main).instantiateViewController(withIdentifier:
                              VCIDENTIFIER.PRODUCTDETAILVC) as? ProductDetailViewController)!
      productDetailVC.productDetail = productDetails
//      productDetailVC.callbackOnWishListUpdate = { () -> Void in
//        DispatchQueue.main.async {
//            self.perform(#selector(self.refreshWishlist), with: nil, afterDelay: 0.5)
//        }
//        
//      }
      self.navigationController?.pushViewController(productDetailVC, animated: true)
   }
}
