//
//  RegistrationViewController.swift
//  Beer Connect
//
//  Created by Synsoft on 27/01/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit
import WebKit

class RegistrationViewController: BaseViewController {
    
    // MARK: - ALL IBOUTLET CONNNECTIONS & VARIABLE
    @IBOutlet weak var webView: WKWebView!
    var signUpUrl: String = ""
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      if !Connectivity.isConnectedToInternet {
              DispatchQueue.main.async {
                    NetworkManager.shared.hideProgressActivity()
                    BaseViewController.showAlert(title: NSLocalizedString("Alert", comment: ""),
                                            message: "Please check your Internet connection and try again.",
                                      buttonTitle: NSLocalizedString("OK", comment: ""))
                       return
              }

      }
      
      initComponents()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        manageNavigationUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
}

extension RegistrationViewController {
    
    func initComponents() {
        manageWebView()
    }
    
    func manageWebView() {
        let url = URL.init(string: self.signUpUrl)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url!))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    func manageNavigationUI() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.setNavigationLeftBarButton(viewController: self, isImage: true, imageName: "back", target: self, selector:  #selector(backMethodAction(_:)))
        self.title = "Registration"
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            if #available(iOS 13.0, *) {
                self.navigationController?.navigationBar.showsLargeContentViewer = true
            } else {
                // Fallback on earlier versions
            }
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorConstants.APPBLUECOLOR,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 34.0, weight: .bold)]
        }
    }
    
    @objc func backMethodAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - VIEW INITIALIZATION & SETUP REGISTRATION PROPERTIES
extension RegistrationViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        NetworkManager.shared.hideProgressActivity()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        NetworkManager.shared.showProgressActivity()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        NetworkManager.shared.hideProgressActivity()
        
    }
    
}
