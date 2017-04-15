//
//  PartialGradesViewController.swift
//  UFP
//
//  Created by Rafael Almeida on 30/03/17.
//  Copyright © 2017 Rafael Almeida. All rights reserved.
//

import UIKit
import SwiftyJSON

class PartialGradesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var gradesTable: UITableView!
    
    let apiController = APIController()
    let tableCellIdentifier = "tableCell"
    
    var headers = [String]()
    var partialGrades = [String: [PartialGrades]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradesTable.delegate = self
        gradesTable.dataSource = self
        
        apiController.getUserPartialGrades(APICredentials.sharedInstance.apiToken!, completionHandler: { (json, error) in
            self.activityIndicator.stopAnimating()
            
            if(json["status"] == "Ok") {
                for (keyLevel, data) in json["message"] {
                    self.headers.append(keyLevel)
                    
                    var grades = [PartialGrades]()
                    var gradesAux = [String: String]()
                    
                    for (keyCourse, _) in data {
                        for (_, value) in json["message"][keyLevel][keyCourse] {
                            gradesAux[value["elemento"].stringValue] = value["nota"].stringValue
                        }
                        
                        grades.append(PartialGrades(name: keyCourse, grades: gradesAux))
                    }
                    
                    self.partialGrades[keyLevel] = grades
                }
            } else {
            }
            
            self.gradesTable.reloadData()
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        view.backgroundColor = #colorLiteral(red: 0.3411764706, green: 0.6235294118, blue: 0.168627451, alpha: 1)
        
        let label = UILabel()
        
        label.text = headers[section]
        
        label.frame = CGRect(x: 5, y: 7, width: tableView.frame.width, height: 35)
        
        label.textColor = UIColor.white
        
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.partialGrades[headers[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath as IndexPath)
        
        if let finalGradeDetails = self.partialGrades[headers[indexPath.section]]?[indexPath.row] {
            cell.textLabel?.text = finalGradeDetails.name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showGrades", sender: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = gradesTable.indexPathForSelectedRow {
            let detailVC = segue.destination as! DetailedPartialGradesViewController
            detailVC.partialGrades = self.partialGrades[headers[indexPath.section]]?[indexPath.row]
        }
    }
    
}
