//
//  TeacherDetailsViewController.swift
//  UFP
//
//  Created by Rafael Almeida on 01/06/17.
//  Copyright © 2017 Rafael Almeida. All rights reserved.
//

import Foundation

class TeacherDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var gradesTable: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    let tableCellIdentifier = "tableCell"
    var partialGrades: PartialGrades?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* To be completed */
        gradesTable.delegate = self
        gradesTable.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
