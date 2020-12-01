//
//  CustomerListViewController.swift
//  Beer Connect
//
//  Created by Synsoft on 26/03/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit

class CustomerListViewController: BaseViewController {
    
    @IBOutlet weak var customerListTableView: UITableView!
    @IBOutlet weak var lblTopTitle: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var imgNoDataFound: UIImageView!

    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"

    var viewModal: CustomerListViewModal?
    weak var delegate: CustomerSelectedProtocol?
    var timer = Timer()
    var searchText: String = ""
    
    var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        initComponents()
    }
    
    func initComponents() {
        self.manageUI()
        self.initializeViewModel()
        self.getCustomerList()
    }
    
    func initializeViewModel() {
        self.imgNoDataFound.isHidden = true
        viewModal = CustomerListViewModal(delegate: self)
    }
    
    func manageUI() {
        self.view?.backgroundColor = UIColor(red: 19.0 / 255.0, green: 27.0 / 255.0, blue: 52.0 / 255.0, alpha: 0.5)
        self.txtSearch.placeholder = NSLocalizedString("SEARCH_PLACEHOLDER", comment: "")
        self.txtSearch.becomeFirstResponder()
    }
    
    func getCustomerList() {
        self.txtSearch.resignFirstResponder()
        self.viewModal?.customerListRequest.search = self.searchText
        self.viewModal?.getCustomerListFromServer()
    }
}

// MARK: - TableView Datasoruce & Delegate Methods
extension CustomerListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.viewModal?.arrCustomerList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "CELL")
        }
        cell?.selectionStyle = .none
        let customerDetails = self.viewModal?.arrCustomerList[indexPath.row]
        cell!.textLabel?.textColor = UIColor.steel
        if let customerName = customerDetails?.customerData?.displayName {
            let attrString: NSMutableAttributedString = NSMutableAttributedString(string: customerName)
            let range = (customerName as NSString).range(of: self.txtSearch.text ?? "", options: .caseInsensitive)
            attrString.addAttribute(NSAttributedString.Key.foregroundColor,
                                    value: UIColor.darkBlueGrey, range: range)
            cell!.textLabel?.attributedText = attrString
        }
        return cell ?? UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            var customerId: String = ""
            if self.viewModal?.arrCustomerList.count ?? 0 > 0 {
                let customerDetails = self.viewModal?.arrCustomerList[indexPath.row]
                UserDefaults.standard.set(false, forKey: "adminLogin")
                if let userId = customerDetails?.customerData?.iD {
                    if !(userId.isEmpty) && userId != "" {
                        customerId = userId
                        self.onCustomerSelectActionMethod(userId: customerId)
                    }
                }
            }
        }
    }
    
    func onCustomerSelectActionMethod(userId: String) {
        if self.delegate != nil {
            self.txtSearch.resignFirstResponder()
            self.delegate?.onCustomerSelected(customerId: userId)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension CustomerListViewController: CustomerListProtocol {
    func onRecievedCustomerListSuccess() {
        DispatchQueue.main.async {
            self.isLoading = false
            if self.viewModal?.arrCustomerList == nil ||
                self.viewModal?.arrCustomerList.count == 0 {
                self.imgNoDataFound.isHidden = false
                self.txtSearch.resignFirstResponder()
                self.clearSearchDetails()
                self.view.makeToast(NSLocalizedString("CUSTOMER_NOT_FOUND", comment: ""), duration: 2.0, position: .bottom)
            } else {
                self.imgNoDataFound.isHidden = true
                self.customerListTableView.isHidden = false
                self.customerListTableView.reloadData()
            }
        }
    }
    func onFailure(errorMsg: String) {
        DispatchQueue.main.async {
            self.clearSearchDetails()
            self.txtSearch.resignFirstResponder()
            self.isLoading = false
            self.imgNoDataFound.isHidden = false
            self.view.makeToast(errorMsg, duration: 2.0, position: .bottom)
            //self.dismiss(animated: true, completion: nil)
            //self.customerListTableView.reloadData()
            //let alertTitle = NSLocalizedString("ALERT_ERROR_TITLE", comment: "")
            //BaseViewController.showBasicAlert(message: errorMsg, title: alertTitle)
        }
    }
}

extension CustomerListViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        var txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                if textField.text?.count == 1 {
                    self.searchText = ""
                    self.getCustomerList()
                    textField.text = ""
                }
            }
        }
        txtAfterUpdate = txtAfterUpdate.trim()
        searchText = txtAfterUpdate
        stopPreventingFromContinuesTyping()
        return true
    }
    
    func stopPreventingFromContinuesTyping() {
        NSObject.cancelPreviousPerformRequests(withTarget: self,
                                                  selector: #selector(callCustomerList),
                                                  object: nil)
        self.perform(#selector(callCustomerList),
                         with: nil,
                         afterDelay: 0.5)
    }

    
    
     @objc func callCustomerList() {
        //if self.searchText.count == 0 {
         //   self.searchText = ""
         //   self.getCustomerList()
          if self.searchText.count > 2 {
            self.viewModal?.customerListRequest.currentPage = "1"
            self.viewModal?.customerListRequest.search = self.searchText
            self.viewModal?.getCustomerListFromServer()
        }
      }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
  
    func clearSearchDetails() {
        self.viewModal?.arrCustomerList.removeAll()
        self.customerListTableView.reloadData()
        self.customerListTableView.isHidden = true
    }
}
extension CustomerListViewController {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if !isLoading {
            if ((self.customerListTableView.contentOffset.y + customerListTableView.frame.size.height) >= customerListTableView.contentSize.height - 50) { loadMoredata() }
            }
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                      willDecelerate decelerate: Bool) {
        if(!decelerate) && (!isLoading) {
            if ((customerListTableView.contentOffset.y + customerListTableView.frame.size.height) >= customerListTableView.contentSize.height - 50) {
                loadMoredata()
            }
        }
    }
        
    func loadMoredata() {
        let totalCount = self.viewModal?.customerListResponse?.total ?? 0
        if totalCount > self.viewModal?.arrCustomerList.count ?? 0 {
        isLoading = true
        var pageNo = Int(self.viewModal?.customerListRequest.currentPage ?? "1")
        pageNo = (pageNo ?? 1) + 1
        self.viewModal?.customerListRequest.currentPage = String(pageNo ?? 1)
        self.getCustomerList()
        }
       }
}
