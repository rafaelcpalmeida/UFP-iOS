//
//  PartialGradesViewController.swift
//  UFP
//
//  Created by Rafael Almeida on 30/03/17.
//  Copyright © 2017 Rafael Almeida. All rights reserved.
//

import UIKit
import SwiftyJSON

class DetailedPartialGradesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var gradesTable: UITableView!
    
    let apiController = APIController()
    let tableCellIdentifier = "tableCell"
    
    var headers = [String]()
    var finalGrades = [String: [FinalGrades]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradesTable.delegate = self
        gradesTable.dataSource = self
        
        apiController.getUserFinalGrades(APICredentials.sharedInstance.apiToken!, completionHandler: { (json, error) in
            if(json["status"] == "Ok") {
                for (keyLevel, data) in json["message"] {
                    for (keyCourse, _) in data {
                        self.headers.append(keyLevel + " - " + keyCourse)
                        
                        var grades = [FinalGrades]()
                        
                        for (_, value) in json["message"][keyLevel][keyCourse] {
                            //self.grades.append([keyLevel + " - " + keyCourse: FinalGrades(name: value["unidade"].stringValue, grade: value["nota"].stringValue)])
                            grades.append(FinalGrades(name: value["unidade"].stringValue, grade: value["nota"].stringValue))
                        }
                        
                        self.finalGrades[keyLevel + " - " + keyCourse] = grades
                    }
                }
            } else {
            }
            
            self.gradesTable.reloadData()
        })
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.finalGrades[headers[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath as IndexPath)
        
        if let finalGradeDetails = self.finalGrades[headers[indexPath.section]]?[indexPath.row] {
            cell.textLabel?.text = finalGradeDetails.name
        }
        
        return cell
    }
    
    @IBAction func returnToPreviousView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
