//
//  ATMViewController.swift
//  UFP
//
//  Created by Rafael Almeida on 26/03/17.
//  Copyright © 2017 Rafael Almeida. All rights reserved.
//

import UIKit
import SwiftyJSON

class ATMViewController: UIViewController {
    
    @IBOutlet weak var noPaymentInfo: UILabel!
    @IBOutlet weak var paymentInfoView: UIView!
    @IBOutlet weak var paymentInfoToolbar: UIToolbar!
    @IBOutlet weak var atmEntityLabel: UILabel!
    @IBOutlet weak var atmReferenceLabel: UILabel!
    @IBOutlet weak var atmValueLabel: UILabel!
    @IBOutlet weak var atmPaymentDates: UILabel!
    
    let apiController = APIController()
    
    var jsonData = [String: JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiController.getUserPaymentDetails(token: APICredentials.sharedInstance.apiToken!, completionHandler: { (json, error) in
            if(json["status"] == "Ok") {
                let atmDetails = json["message"]
                self.atmEntityLabel.text = atmDetails["Entidade"].stringValue
                self.atmReferenceLabel.text = atmDetails["Referencia"].stringValue
                self.atmValueLabel.text = atmDetails["Total"].stringValue + "€"
                self.atmPaymentDates.text = "Pagável entre \(self.dateFormatter.string(from: self.dateFormatterFromString.date(from: atmDetails["Inicio"].stringValue)!)) e \(self.dateFormatter.string(from: self.dateFormatterFromString.date(from: atmDetails["Termo"].stringValue)!))"
            } else {
                self.paymentInfoToolbar.isHidden = true
                self.paymentInfoView.isHidden = true
                self.noPaymentInfo.isHidden = false
            }
        })
        
    }
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
    
    fileprivate lazy var dateFormatterFromString: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
}
