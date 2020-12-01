//
//  SortViewController.swift
//  Beer Connect
//
//  Created by Synsoft on 13/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit

class SortViewController: BaseViewController {
   
   @IBOutlet weak var lblHeaderTitle: UILabel!
   @IBOutlet weak var sortTableView: UITableView!
   
   var arrSortVal: [String] = ["Order By Date","Price Low To High","Price High To Low"]
   var orderByDetails = OrderBy.init()
   weak var delegate: SortProtocol?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view.
      initComponents()
      self.sortTableView.sizeToFit()
   }
    
    @IBAction func dismissView(sender: Any) {
        self.dismissCurrentVC()
    }
   
}

extension SortViewController {
   func initComponents() {
      self.manageScreenUI()
   }
   func manageScreenUI() {
      view?.backgroundColor = UIColor(red: 19.0 / 255.0, green: 27.0 / 255.0, blue: 52.0 / 255.0, alpha: 0.5)
   }
}


extension SortViewController: UITableViewDelegate, UITableViewDataSource {
   
   func tableView(_ tableView: UITableView,
                  numberOfRowsInSection section: Int) -> Int {
      return self.arrSortVal.count
   }
   
   func tableView(_ tableView: UITableView,
                  cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let sortCell = tableView.dequeueReusableCell(withIdentifier:
         TABLEVIEWCELLID.SORTVIEWCELLID,
                                                   for: indexPath) as? SortViewCell
      sortCell?.lblTitle.text = self.arrSortVal[indexPath.row]
      return sortCell ?? UITableViewCell.init()
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      DispatchQueue.main.async {
         self.dismissCurrentVC()
         switch indexPath.row {
                 case 0:
                 if self.delegate != nil {
                    self.delegate?.getSortVal(sortVal: "date")
                 }
                 
                 case 1:
                 if self.delegate != nil {
                    self.delegate?.getSortVal(sortVal: "pricelow")
                 }
                 
                 case 2:
                 if self.delegate != nil {
                    self.delegate?.getSortVal(sortVal: "pricehigh")
                 }
                
                 default:
                 if self.delegate != nil {
                    self.delegate?.getSortVal(sortVal: "date")
                 }
                 break
              }
      }
   }
   
   func dismissCurrentVC() {
      self.dismiss(animated: true, completion: nil)
   }
}

