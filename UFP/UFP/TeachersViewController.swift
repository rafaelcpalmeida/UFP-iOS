//
//  TeachersViewController.swift
//  UFP
//
//  Created by Rafael Almeida on 1/06/17.
//  Copyright © 2017 Rafael Almeida. All rights reserved.
//

import UIKit
import SwiftyJSON

class TeachersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var teachersTable: UITableView!
    
    let apiController = APIController()
    let tableCellIdentifier = "tableCell"
    let searchController = UISearchController(searchResultsController: nil)
    
    var teachers = [Teacher]()
    var filteredTeachers = [Teacher]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teachersTable.delegate = self
        teachersTable.dataSource = self
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = UISearchBarStyle.minimal
        
        teachersTable.tableHeaderView = searchController.searchBar
        
        apiController.getTeachers(completionHandler: { (json, error) in
            self.activityIndicator.stopAnimating()
            
            if(json["status"] == "Ok") {
                for (_, data) in json["message"] {
                    self.teachers.append(Teacher(name: data["nome"].stringValue, identifier: data["sigla"].stringValue))
                }
            } else {
            }
            
            self.teachersTable.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredTeachers.count
        }
        return teachers.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath as IndexPath)
        let teacher: Teacher
        
        if searchController.isActive && searchController.searchBar.text != "" {
            teacher = self.filteredTeachers[indexPath.row]
        } else {
            teacher = self.teachers[indexPath.row]
        }
        
        cell.textLabel?.text = teacher.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showTeacherDetails", sender: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*if let indexPath = teachersTable.indexPathForSelectedRow {
            let detailVC = segue.destination as! DetailedPartialGradesViewController
            //detailVC.partialGrades = self.partialGrades[headers[indexPath.section]]?[indexPath.row]
        }*/
    }
    
    func filterContentForSearchText(searchText: String) {
        filteredTeachers = teachers.filter({( teacher : Teacher) -> Bool in
            return teacher.name.lowercased().contains(searchText.lowercased())
        })
        
        self.teachersTable.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
