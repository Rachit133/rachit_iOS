//
//  PDFViewController.swift
//  Beer Connect
//
//  Created by Apple on 26/04/20.
//  Copyright © 2020 Synsoft. All rights reserved.
//

import UIKit
import PDFKit


@available(iOS 11.0, *)
class PDFViewController: BaseViewController {

    @IBOutlet var pdfView: PDFView!
    @IBOutlet var lblInvoiceNo: UILabel!
    @IBOutlet var btnClose: UIButton!
    var fileLocation: URL?
    var orderNo: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.lblInvoiceNo.text = "Invoice No. : "+self.orderNo!
        
        if let pdfDocument = PDFDocument(url: fileLocation!) {
            pdfView.displayMode = .singlePageContinuous
            pdfView.autoScales = true
            pdfView.autoresizesSubviews = true
            pdfView.backgroundColor = .white
            pdfView.displayDirection = .vertical
            pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleLeftMargin]
            pdfView.displaysPageBreaks = true
            pdfView.document = pdfDocument
        }
    }
 
    @IBAction func closeCurrentVCMethodAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePdfDocAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Invoice No. : "+self.orderNo!, message: "Do you want to save Invoice No.\(self.orderNo!) in your device ? ", preferredStyle: .alert)

        // Create the actions
        let okAction = UIAlertAction(title: "OK",
                                     style: UIAlertAction.Style.default) {
            UIAlertAction in
            let activityViewController = UIActivityViewController(activityItems: ["Invoice No. : "+self.orderNo!, self.fileLocation ?? ""], applicationActivities: nil)   // and present it
                UIApplication.shared.keyWindow?.rootViewController?.present(activityViewController,
                                                                            animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }

        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        // Present the controller
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
}
