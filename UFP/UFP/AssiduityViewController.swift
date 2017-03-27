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
        
        apiController.getUserAssiduityDetails(token: APICredentials.sharedInstance.apiToken!, completionHandler: { (json, error) in
            self.activityIndicator.stopAnimating()
            if(json["status"] == "Ok") {
                for (_, data) in json["message"] {
                    self.subjects.append(Subject(name: data["unidade"].stringValue, assiduity: data["assiduidade"].stringValue, type: data["tipo"].stringValue))
                }
            } else {
            }
            
            self.assiduityTable.reloadData()
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath as IndexPath)
        
        let data = subjects[indexPath.row]
        
        if let assiduity = Int(data.assiduity) {
            var color: UIColor
            
            switch assiduity {
            case 0..<40:
                color = UIColor.red
            case 41..<70:
                color = UIColor.orange
            default:
                color = UIColor(red: 0, green: 0.5373, blue: 0.0706, alpha: 1.0)
            }
            
            let subjectAssiduity = NSAttributedString(string: data.assiduity, attributes: [NSForegroundColorAttributeName : color])
            let subjectType = NSAttributedString(string: data.type + " - ", attributes: [NSForegroundColorAttributeName : UIColor.black])
            let combination = NSMutableAttributedString()
            
            combination.append(subjectType)
            combination.append(subjectAssiduity)
            combination.append(NSAttributedString(string: "%"))
            
            cell.textLabel?.text = data.name
            cell.detailTextLabel?.attributedText = combination
        }
        
        
        return cell
    }
    
}
