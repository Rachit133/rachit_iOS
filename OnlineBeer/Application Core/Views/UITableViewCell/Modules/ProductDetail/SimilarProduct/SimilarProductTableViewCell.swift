//
//  SimilarProductTableViewCell.swift
//  Beer Connect
//
//  Created by Dilip Patidar on 05/04/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit
import SDWebImage

class SimilarProductTableViewCell: UITableViewCell {
    var viewModal: ProductDetailViewModel?
    var callbackOnCellClick: ((_ productData: Product) -> Void)?
    var wishlistResponse: GetWishlistResponse?
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout?
    
    private let producSpacing:CGFloat = 8
    @IBOutlet weak var similarProductCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionViewFlowLayout?.sectionInset = UIEdgeInsets(top: producSpacing, left: 0, bottom: 0, right: producSpacing)
        collectionViewFlowLayout?.minimumLineSpacing = producSpacing
        collectionViewFlowLayout?.minimumInteritemSpacing = producSpacing
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func loadData(modal: ProductDetailViewModel) {
        
        viewModal = modal
        self.similarProductCollectionView.reloadData()
        
        
    }
    
}

extension SimilarProductTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.viewModal?.arrSimilarProducts.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let bestSellercell: BestSellerProductCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier:
            COLLECTIONVIEWCELLID.BESTSELLERCATCELLID,
                                                                                                       for: indexPath) as? BestSellerProductCollectionCell else {
                                                                                                        return (collectionView.dequeueReusableCell(withReuseIdentifier: COLLECTIONVIEWCELLID.BESTSELLERCATCELLID,
                                                                                                                                                   for: indexPath) as? BestSellerProductCollectionCell)!
        }
        
        bestSellercell.layer.shouldRasterize = true
        bestSellercell.layer.rasterizationScale = UIScreen.main.scale
        
        let productDetails = self.viewModal?.arrSimilarProducts[indexPath.item]
        bestSellercell.btnProductWishlist.tag = indexPath.item
        //  bestSellercell.btnProductWishlist.addTarget(self, action: #selector(setWishlistActionMethod(sender:)), for: .touchUpInside)
        
        if let wishlistStr = productDetails?.wishlist?.lowercased().trim() {
            if wishlistStr == "yes" {
                bestSellercell.btnProductWishlist.setBackgroundImage(UIImage(named: "wishlist"), for: .normal)
                bestSellercell.btnProductWishlist.accessibilityLabel = "1"
            } else {
                bestSellercell.btnProductWishlist.setBackgroundImage(UIImage(named: "wishlistDisable"), for: .normal)
                bestSellercell.btnProductWishlist.accessibilityLabel = "0"
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
        
        
        guard let productName: String = productDetails?.productName else {
            bestSellercell.lblProductTitle.isHidden = true
            return bestSellercell
        }
        
        if productName.count > 0 {
            bestSellercell.lblProductTitle.isHidden = false
            bestSellercell.lblProductTitle.text = productName
        }
        
        
        bestSellercell.lblDiscountPrice.isHidden = true
        var regularPrc = ""
        if let regularPrice = productDetails?.regularPrice {
            if !regularPrice.isEmpty {
                regularPrc = regularPrice
                bestSellercell.lblRegularPrice.isHidden = false
                bestSellercell.lblRegularPrice.text = regularPrice
            } else {
                bestSellercell.lblRegularPrice.isHidden = true
            }
        }
        bestSellercell.disCountView.isHidden = true
        
        if let salePrice = productDetails?.salePrice, salePrice != "" {
            if !salePrice.isEmpty {
                bestSellercell.lblDiscountPrice.isHidden = false
                bestSellercell.lblDiscountPrice.text = salePrice
                
                if !regularPrc.isEmpty {
                    let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: productDetails?.regularPrice ?? "")
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
                    bestSellercell.lblRegularPrice.text = productPrc.description
                    bestSellercell.disCountView.isHidden = true
                    bestSellercell.lblDiscountPrice.isHidden = true
                    
                } else if disCountPercnt > 0 {
                    bestSellercell.disCountView.isHidden = false
                    bestSellercell.lblDiscountPercentage.text = "\(disCountPercnt)%"
                }
            }
        }
        
        return bestSellercell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let relatedCell = cell as? BestSellerProductCollectionCell {
            relatedCell.viewForProduct.layer.cornerRadius = 8
            relatedCell.viewForProduct.layer.masksToBounds =  false
            relatedCell.viewForProduct.layer.applySketchShadow(
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
        
        let numberOfItemsPerRow:CGFloat = 2
        let spacingBetweenCells:CGFloat = 5
        
        let totalSpacing = (0.8 * self.producSpacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells)
        let width = (collectionView.bounds.width - totalSpacing)/numberOfItemsPerRow
        return CGSize(width: width-18, height: 270.0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        print("Tab Index is \(indexPath.item)")
        guard let productDetails = self.viewModal?.arrSimilarProducts[indexPath.item] else { return  }
        self.callbackOnCellClick!(productDetails)
        //self.navigateToProductDetailScreen(productDetails: productDetails)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left:0, bottom: 0, right: 0)
    }
    
    @IBAction func setWishlistActionMethod(sender: UIButton){
        //self.currentIndexPath = IndexPath.init(item: sender.tag, section: 0)
        var productDetails = self.viewModal?.arrSimilarProducts[sender.tag]
        if  UserDefaults.standard.isKeyPresentInUserDefaults(key: "loginUser") {
            if let loginDetails = UserDefaults.standard.retrieve(object: LoginResponse.self, fromKey: "loginUser") {
                guard let userId: String = loginDetails.data?.customer?.customerID else { return }
                guard let productId: String = productDetails?.productID?.description else { return }
                let parmDict:[String:Any] = ["user-id":userId, "product-id":productId.description]
                NetworkManager.shared.makeRequestToServer(for: SETWISHLIST,
                                                          method: .POST,
                                                          params: parmDict,
                                                          isActivityShow: false,
                                                          completionSuccess: { (wishlistData) in
                                                            if wishlistData != nil {
                                                                DispatchQueue.main.async {
                                                                    if sender.accessibilityLabel == "1" {
                                                                        //do something here
                                                                        sender.setBackgroundImage(UIImage(named: "wishlistDisable"), for: .normal)
                                                                        sender.accessibilityLabel = "0"
                                                                        self.contentView.makeToast("Product removed from wishlist", duration: 1.0, position: .center)
                                                                        productDetails?.wishlist = "no"
                                                                    } else {
                                                                        sender.setBackgroundImage(UIImage(named: "wishlist"), for: .normal)
                                                                        self.contentView.makeToast("Product added to wishlist", duration: 1.0, position: .center)
                                                                        sender.accessibilityLabel = "1"
                                                                        productDetails?.wishlist = "yes"
                                                                    }
                                                                    self.viewModal?.arrSimilarProducts[sender.tag] = productDetails ?? Product()
                                                                }
                                                                
                                                            } else {
                                                                DispatchQueue.main.async {
                                                                    self.contentView.makeToast("There might be error from server side", duration: 1.5, position: .bottom)
                                                                }
                                                            }
                }, completionFailure: { (errorObj) in
                    DispatchQueue.main.async {
                        self.contentView.makeToast("There might be error from server side", duration: 1.5, position: .bottom)
                    }
                })
            }
            
        }
        
    }
    
}
