//
//  FilterViewController.swift
//  Beer Connect
//
//  Created by Apple on 30/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit
import RangeSeekSlider

class FilterViewController: BaseViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
   // @IBOutlet weak private var rangeSlider:
   
    @IBOutlet weak var rangeSlider: RangeSeekSlider!
    @IBOutlet weak var btnClear : UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var tableViewFilter: UITableView!
    @IBOutlet weak var lblPrice: UILabel!
    
    var callback: ((_ filterData: [String:Any]) -> Void)?
    var clearCallback: ((_ filterData: [String:Any]) -> Void)?
    var filterData:[Any] = [];
    var arySelectedFilter:[Int] = []
    var arySelectedFilterName:[String] = []
    var minPrice = ""
    var maxPrice = ""
    var isClearBtnTapped: Bool = false
    var subCategories: [Subcategory] = []
    
    var viewModel: FilterViewModel?
    var userId: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NetworkManager.shared.checkInternetConnectivity()
        initializeViewModel()
        manageNavigationUI()
        if filterData.count == 0 {
              getAllSubCategoryFromServer()
        }
    }
    
    func getLoginDetails() -> String {
        if UserDefaults.standard.isKeyPresentInUserDefaults(key: "loginUser") {
            if let loginDetails = UserDefaults.standard.retrieve(object: LoginResponse.self,
                                                                 fromKey: "loginUser") {
               if let customerID: String = loginDetails.data?.customer?.customerID {
                    self.userId = customerID
                }
            }
            return self.userId
        } else { return self.userId }
    }
    
    func manageNavigationUI() {
        self.isClearBtnTapped = false
        self.appDelegate.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        self.title = NSLocalizedString("FILTER_TITLE", comment: "")
        self.navigationItem.backBarButtonItem?.title = ""
        self.setNavigationLeftBarButton(viewController: self, isImage: true, imageName: "back", target: self, selector:  #selector(backMethodAction(_:)))
        
        if #available(iOS 11, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationItem.largeTitleDisplayMode = .always
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorConstants.APPBLUECOLOR,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34.0, weight: .bold)]
        }
       // var minValue = "10.0"
      //  var maxValue = "200.0"

        self.rangeSlider.numberFormatter.positivePrefix = "$"

        if minPrice != "" {
            if let miniValue = Double(minPrice) { rangeSlider.selectedMinValue =  CGFloat(miniValue) }
       
        } else { rangeSlider.selectedMinValue =  CGFloat(10.0) }
        
        if maxPrice != "" {
            if let maxValue = Double(maxPrice) { rangeSlider.selectedMaxValue =  CGFloat(maxValue) }
          //  maxValue = maxPrice
       } else {
            rangeSlider.selectedMaxValue =  CGFloat(200.0)
       }
        
        btnClear.layer.cornerRadius = 20.0
        btnSubmit.layer.cornerRadius = 20.0
        btnSubmit.backgroundColor = ColorConstants.COLORACTIVITYINDICATOR
        btnClear.backgroundColor =  ColorConstants.APPLITEGRAY
        
      //  print("Min is : \(String(format: "Angle: %.1f", rangeSlider.lowerValue))")
      //  print("Max is : \(String(format: "Angle: %.1f", rangeSlider.upperValue))")
        
        lblPrice.text = "\(String(format: "$%.1f", rangeSlider.selectedMinValue)) - \(String(format: "$%.1f", rangeSlider.selectedMaxValue))"
    }
    
    func initializeViewModel() { self.viewModel = FilterViewModel(delegate: self) }
    
    func getAllSubCategoryFromServer() {
        self.viewModel?.getFilterCatProductFromServer()
    }
    
    @objc func backMethodAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func rangeSliderValuesChanged(_ rangeSlider: RangeSeekSlider) {
        let lowerValue = Int(rangeSlider.selectedMinValue)
        let UpperValue = Int(rangeSlider.selectedMaxValue)
        
        let strPriceRange = "\(String(format: "$%d", lowerValue)) - \(String(format: "$%d", UpperValue))"
        lblPrice.text = strPriceRange
    }
    
    @IBAction func clearFilter(_sender : UIButton) {
        
        var deletedIndex: [Int] = []
        for i in (0 ..< self.filterData.count-1) {
            deletedIndex.append(i+1)
         }
        
        if deletedIndex.count != 0 {
             self.filterData.removeAfterIndex(at: deletedIndex)
        }
        self.arySelectedFilter.removeAll()
        self.arySelectedFilterName.removeAll()
        self.tableViewFilter.reloadData()
        
        rangeSlider.selectedMinValue =  CGFloat(10.0)
        rangeSlider.selectedMaxValue =  CGFloat(200.0)
              
        lblPrice.text = "$10 - $200"
        self.isClearBtnTapped = true
        
        let someDict:[String:Any] =  ["startPrice":(rangeSlider.selectedMinValue as NSNumber).stringValue, "endPrice":(rangeSlider.selectedMaxValue as NSNumber).stringValue, "subCategories": subCategories, "mainArray":filterData,"filteredId": arySelectedFilter, "filteredName": arySelectedFilterName, "isFilterClear": self.isClearBtnTapped]
        self.clearCallback!(someDict)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSubmit(_sender : UIButton) {
        
        var catId = ""
        
        if self.arySelectedFilter.count != 0 {
            catId = String(self.arySelectedFilter.last ?? 0)
        }
        var catName = ""
        if self.arySelectedFilterName.count != 0 {
                  catName = String(self.arySelectedFilterName.last ?? "")
              }
        let someDict:[String:Any] = ["catId":catId, "startPrice":(rangeSlider.selectedMinValue as NSNumber).stringValue, "endPrice":(rangeSlider.selectedMaxValue as NSNumber).stringValue, "catName":catName, "subCategories": subCategories, "mainArray":filterData,"filteredId": arySelectedFilter, "filteredName": arySelectedFilterName, "isFilterClear": self.isClearBtnTapped]
        self.callback!(someDict)
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: TABLEVIEW DELEGATE & DATASOURCE METHODS
extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 5, width: headerView.frame.width-30, height: headerView.frame.height-10)
        label.font = UIFont(name: "SFProText-Bold", size:14.0)
        label.textColor = ColorConstants.APPBLUECOLOR
            if let dictDetail = self.filterData[section] as? FilterResponse {
                label.text = dictDetail.cat_name ?? ""
            }
        headerView.addSubview(label)
        
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.filterData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.section)
        let filterListCell = tableView.dequeueReusableCell(withIdentifier:
            TABLEVIEWCELLID.FILTERVIEWCELL,
                                                           for: indexPath) as? FilterTableViewCell
        filterListCell?.selectionStyle = .none
        for subView in filterListCell?.contentView.subviews ?? [] {
            subView.removeFromSuperview()
        }
            if let dictDetail = self.filterData[indexPath.section] as? FilterResponse {
                loadCategoryData(category: dictDetail.subcategories ?? [], cell: filterListCell ?? FilterTableViewCell.init(), indexPath: indexPath)
            }
        return filterListCell ?? UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var cellHeight = 0.0
//        if indexPath.row == 0 {
             if let cateData = self.filterData[indexPath.section] as? FilterResponse {
                let subCatLength = cateData.subcategories?.count ?? 0
                if subCatLength != 0 {
                      var x = CGFloat(24.0)
                      var y = CGFloat(10.0)
                      
                    for i in (0..<subCatLength) {
                          var str = ""
                        if let cate = cateData.subcategories?[i] {
                                    str = cate.name ?? ""
                                }
                          let strSize =  (str as NSString).size(withAttributes: nil)
                          if((x + strSize.width + 90.0) > (self.view.frame.size.width -
                              30.0))
                          {
                              x = 24.0
                              y = y+60
                          }
                          x = x + strSize.width + 80
                      }
                      cellHeight = Double(Int(y+60))
                  }
              }
      //  }
        
        return CGFloat(cellHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Tap Subcategory & pass term Id
        //self.callApplyFilterApi(termId: "1234")
    }
    
  @objc func callApplyFilterApi(_ sender: UIButton) {
        
            let selectedIndex = Int(sender.accessibilityLabel ?? "0")!
            if let cateData = self.filterData[sender.tag] as? FilterResponse {
                if let cate = cateData.subcategories?[selectedIndex] {
                    self.viewModel?.subCatRequest.catId = String(cate.termID ?? 0)
                    self.viewModel?.subCatRequest.userId = self.getLoginDetails() //23711 , 23907
                    var deletedIndex: [Int] = []
                    for i in (sender.tag ..< self.filterData.count-1) {
                        deletedIndex.append(i+1)
                     }
                    
                    if deletedIndex.count != 0 {
                         self.filterData.removeAfterIndex(at: deletedIndex)
                    }
                    
                    if self.arySelectedFilter.count > sender.tag &&
                        self.arySelectedFilter.count != 0{
                        var selectedDeletedIndex: [Int] = []
                        for j in (sender.tag ... self.arySelectedFilter.count-1) {
                           selectedDeletedIndex.append(j)
                        }
                       
                        if selectedDeletedIndex.count != 0 {
                            self.arySelectedFilter.removeAfterIndex(at: selectedDeletedIndex)
                            self.arySelectedFilterName.removeAfterIndex(at: selectedDeletedIndex)
                        }
                    }
                    
                    DispatchQueue.global(qos: .background).async {
                        print("This is run on the background queue")
                        self.viewModel?.getProductsFromServerByCategory()
                        self.arySelectedFilter.append(cate.termID ?? 0)
                        self.arySelectedFilterName.append(cate.name ?? "")
                    }
 
                   

            }
            // sender.backgroundColor = ColorConstants.REDCOLOR
    }
        
//        self.viewModel?.subCatRequest.catId = ""
//        self.viewModel?.subCatRequest.userId = self.getLoginDetails()
//        self.viewModel?.getFilterCatProductFromServer()
    }
    
    
    func loadCategoryData(category: Array<Any>, cell: FilterTableViewCell,
                          indexPath: IndexPath) {
        if category.count != 0
        {
            
            var x = CGFloat(24.0)
            var y = CGFloat(10.0)
            
            for i in (0..<category.count) {
                
                var str = ""
                var id  = 0
                 if let cate = category[i] as? Subcategory {
                      str = cate.name ?? ""
                      id = cate.termID ?? 0
                  }
              
                let strSize =  (str as NSString).size(withAttributes: nil)
                
                let catBtn = UIButton()
                
                if((x + strSize.width + 90.0) > (self.view.frame.size.width -
                    30.0))
                {
                    x = 24.0
                    y = y+60
                }
                
                catBtn.frame = CGRect(x:x, y:y, width:strSize.width + 60, height:40)
                catBtn.setTitle(str, for: .normal)
                catBtn.layer.cornerRadius  = 20.0
                catBtn.clipsToBounds = true
                catBtn.titleLabel?.font = UIFont(name: "SFProText-Medium", size:14.0)!
                catBtn.titleLabel?.textAlignment = .center
                catBtn.tag = indexPath.section
                catBtn.accessibilityLabel = String(i)
                catBtn.addTarget(self, action: #selector(callApplyFilterApi(_:)), for: .touchUpInside)
                
                
                if(arySelectedFilter.contains(id))
                {
                    catBtn.backgroundColor = ColorConstants.COLORACTIVITYINDICATOR
                    catBtn.setTitleColor(.white, for: .normal)
                }
                else
                {
                    catBtn.backgroundColor =  ColorConstants.APPLITEGRAY
                    catBtn.setTitleColor(ColorConstants.APPBLUECOLOR, for: .normal)
                }
                
                x = x + strSize.width + 80
                
                cell.contentView.addSubview(catBtn)
            }
        }
    }
}

extension FilterViewController: FilterProtocol {
    func onReceivedFilterSuccess() {
        print("Recieved Filter Category")
        DispatchQueue.main.async {
            self.filterData.append(self.viewModel?.filterResponse)
            self.tableViewFilter.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func onReceivedFilterSubCatSuccess() {
        //debugPrint("Recieved Filter Category",self.viewModel?.filterResponse?.subcategories?.count)
        DispatchQueue.main.async {
                        if self.viewModel?.filterResponse?.subcategories?.count != 0 && self.viewModel?.filterResponse?.subcategories != nil {
                            self.filterData.append(self.viewModel?.filterResponse)
                            self.subCategories = self.viewModel?.filterResponse?.subcategories ?? []
                        } else {
                            self.subCategories = []
                         }
                    self.tableViewFilter.reloadData()
                  self.dismiss(animated: true, completion: nil)

               }
    }
    
    func onFailure(errorMsg: String) {
        DispatchQueue.main.async {
            BaseViewController.showBasicAlert(message: errorMsg)
        }
    }
}

extension Array {

    mutating func removeAfterIndex(at indexs: [Int]) {
        guard !isEmpty else { return }
        let newIndexs = Set(indexs).sorted(by: >)
        newIndexs.forEach {
            guard $0 < count, $0 >= 0 else { return }
            remove(at: $0)
        }
    }

}
