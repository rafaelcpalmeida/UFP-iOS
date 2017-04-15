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
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    let tableCellIdentifier = "tableCell"
    var partialGrades: PartialGrades?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradesTable.delegate = self
        gradesTable.dataSource = self
        
        if let grades = partialGrades {
            self.navigationBar.topItem?.title = "\(grades.name) - Notas Parciais"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (partialGrades?.grades.count)!
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath as IndexPath)
        
        if let grades = partialGrades {
            let gradeDetails = Array(grades.grades)[indexPath.row]
            
            cell.textLabel?.text = gradeDetails.key
            cell.detailTextLabel?.text = gradeDetails.value
        }
        
        return cell
    }
    
    @IBAction func returnToPreviousView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
