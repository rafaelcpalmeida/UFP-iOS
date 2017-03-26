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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
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
            self.activityIndicator.stopAnimating()
            if(json["status"] == "Ok") {
                self.paymentInfoToolbar.isHidden = false
                self.paymentInfoView.isHidden = false
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
    
    @IBAction func sharePaymentDetails(_ sender: Any) {
        if let entity = self.atmEntityLabel.text, let reference = self.atmReferenceLabel.text, let value = self.atmValueLabel.text, let duration = self.atmPaymentDates.text {
            let textToShare = [ "Universidade Fernando Pessoa - Dados para pagamento por Multibanco\n\n\nEntidade: \(entity)\nReferência: \(reference)\nValor: \(value)\n\n\(duration)" ]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            
            activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
            
            self.present(activityViewController, animated: true, completion: nil)
        }
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
