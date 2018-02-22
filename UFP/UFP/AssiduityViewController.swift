//
//  AssiduityController.swift
//  UFP
//
//  Created by Rafael Almeida on 27/03/17.
//  Copyright © 2017 Rafael Almeida. All rights reserved.
//

import UIKit
import SwiftyJSON

class AssiduityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var assiduityTable: UITableView!
    
    let apiController = APIController()
    let tableCellIdentifier = "tableCell"
    
    var subjects = [Subject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assiduityTable.delegate = self
        assiduityTable.dataSource = self
        
        apiController.getUserAssiduityDetails(APICredentials.sharedInstance.apiToken!, completionHandler: { (json, error) in
            self.activityIndicator.stopAnimating()
            if(json["status"] == "Ok") {
                for (_, data) in json["message"] {
                    for (subject, values) in data {
                        var assiduity = [String: String]()
                        for (_, value) in values {
                            assiduity[value["tipo"].stringValue] = value["assiduidade"].stringValue
                        }
                        self.subjects.append(Subject(name: subject, assiduity: assiduity))
                    }
                }
            } else {
            }
            
            self.assiduityTable.reloadData()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath as IndexPath)
        
        let data = subjects[indexPath.row]        
        
        let combination = NSMutableAttributedString()
        
        for (type, value) in data.assiduity {
            if let assiduityNumber = Int(value) {
                var color: UIColor
                
                switch assiduityNumber {
                case 0..<40:
                    color = UIColor.red
                case 41..<70:
                    color = UIColor.orange
                default:
                    color = UIColor(red: 0, green: 0.5373, blue: 0.0706, alpha: 1.0)
                }
                
                let subjectType = NSAttributedString(string: type + " - ", attributes: [NSAttributedStringKey.foregroundColor : UIColor.black])
                let subjectAssiduity = NSAttributedString(string: value, attributes: [NSAttributedStringKey.foregroundColor : color])
                
                combination.append(subjectType)
                combination.append(subjectAssiduity)
                combination.append(NSAttributedString(string: "% "))
            }
        }
        
        cell.textLabel?.text = data.name
        cell.detailTextLabel?.attributedText = combination
        
        
        return cell
    }
    
}
