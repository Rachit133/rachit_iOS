//
//  ProductDetailTopCell.swift
//  Beer Connect
//
//  Created by Apple on 04/04/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit
import ImageSlideshow
import SDWebImage

class ProductDetailImageCell: UITableViewCell {

    @IBOutlet weak var imgProductTitle: UIImageView!
    @IBOutlet weak var saleBadgeView: UIView!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var slideshow: ImageSlideshow!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func loadProductImages(productData: ProductData) {
        var sdWebImageSource:[InputSource] = []
        if let productImageUrl = productData.productImage {
            if !productImageUrl.isEmpty {
                if let mainUrl = URL(string: productImageUrl) {
                   let imgSource = SDWebImageSource.init(url: mainUrl)
                    sdWebImageSource.append(imgSource)
                }
            }
        }
        
        if let prouctGallery = productData.productGallery {
            for imgUrl in prouctGallery {
                if let galleryUlr = imgUrl as? String {
                    if !galleryUlr.isEmpty {
                        if let mainUrl = URL(string: galleryUlr) {
                        let imgSource = SDWebImageSource.init(url: mainUrl)
                        sdWebImageSource.append(imgSource)
                      }
                    }
                }
            }
        }
        // let sdWebImageSource = [SDWebImageSource(urlString: url)!]
        
        slideshow.slideshowInterval = 5.0
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill

        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.black
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        slideshow.pageIndicator = pageControl

        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        slideshow.activityIndicator = DefaultActivityIndicator()
       // slideshow.delegate = self

        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        slideshow.setImageInputs(sdWebImageSource)
        
        if sdWebImageSource.count == 0 {
            self.slideshow.isHidden = true
            self.imgProductTitle.isHidden = false
        } else {
            self.slideshow.isHidden = false
            self.imgProductTitle.isHidden = true
        }
    }

}
