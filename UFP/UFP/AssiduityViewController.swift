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
    
    var jsonData = [String: JSON]()
    var subjects = [Subject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assiduityTable.delegate = self
        assiduityTable.dataSource = self
        
        self.subjects.append(Subject(name: "Sistemas Operativos", assiduity: 89))
        
        self.subjects.append(Subject(name: "Sistemas Operativos", assiduity: 89))
        
        self.subjects.append(Subject(name: "Sistemas Operativos", assiduity: 89))
        self.subjects.append(Subject(name: "Sistemas Operativos", assiduity: 89))
        
        self.subjects.append(Subject(name: "Sistemas Operativos", assiduity: 89))
        
        self.subjects.append(Subject(name: "Sistemas Operativos", assiduity: 89))
        
        self.subjects.append(Subject(name: "Sistemas Operativos", assiduity: 89))
        
        self.subjects.append(Subject(name: "Sistemas Operativos", assiduity: 89))
        
        self.subjects.append(Subject(name: "Sistemas Operativos", assiduity: 89))
        
        self.activityIndicator.stopAnimating()
        
        self.assiduityTable.reloadData()
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
        
        cell.textLabel?.text = data.name
        cell.detailTextLabel?.text = "\(data.assiduity)%"
        
        return cell
    }
    
}
