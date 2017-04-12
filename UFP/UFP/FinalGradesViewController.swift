//
//  FinalGrades.swift
//  UFP
//
//  Created by Rafael Almeida on 28/03/17.
//  Copyright © 2017 Rafael Almeida. All rights reserved.
//

import UIKit
import SwiftyJSON

class FinalGradesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var gradeLabel: UILabel!
}

class FinalGradesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var gradesTable: UITableView!
    @IBOutlet weak var cellLabel: UILabel!
    
    let apiController = APIController()
    let tableCellIdentifier = "tableCell"
    
    var headers = [String]()
    var finalGrades = [String: [FinalGrades]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradesTable.delegate = self
        gradesTable.dataSource = self
        
        apiController.getUserFinalGrades(APICredentials.sharedInstance.apiToken!, completionHandler: { (json, error) in
            self.activityIndicator.stopAnimating()
            if(json["status"] == "Ok") {
                for (keyLevel, data) in json["message"] {
                    for (keyCourse, _) in data {
                        self.headers.append(keyLevel + " - " + keyCourse)
                        
                        var grades = [FinalGrades]()
                        
                        for (_, value) in json["message"][keyLevel][keyCourse] {
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
        return self.finalGrades[headers[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath as IndexPath) as! FinalGradesTableViewCell
        
        if let finalGradeDetails = self.finalGrades[headers[indexPath.section]]?[indexPath.row] {
            cell.subjectLabel.text = finalGradeDetails.name
            cell.gradeLabel.text = finalGradeDetails.grade
        }
        
        return cell
    }
    
}
