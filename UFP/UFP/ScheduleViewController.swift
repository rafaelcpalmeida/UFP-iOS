//
//  HomeViewController.swift
//  UFP
//
//  Created by Rafael Almeida on 16/03/17.
//  Copyright © 2017 Rafael Almeida. All rights reserved.
//

import UIKit
import SwiftyJSON

class ScheduleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewCalendar: FSCalendar!
    @IBOutlet weak var scheduleTable: UITableView!
    @IBOutlet weak var noScheduleInfo: UILabel!
    
    let apiController = APIController()
    let tableCellIdentifier = "tableCell"
    
    fileprivate weak var calendar: FSCalendar!
    
    var classes = [Class]()
    var jsonData = [String: JSON]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scheduleTable.delegate = self
        scheduleTable.dataSource = self
        
        apiController.getUserSchedule(APICredentials.sharedInstance.apiToken!, completionHandler: { (json, error) in
            self.activityIndicator.stopAnimating()
            
            if(json["status"] == "Ok") {
                for (key, data) in json["message"] {
                    self.jsonData[key] = data
                }
                
                let todayDate = Date()
                
                if let json = self.jsonData[self.dateFormatter.string(from: todayDate)] {
                    for (_, dayClass) in json {
                        self.classes.append(Class(name: dayClass["unidade"].stringValue, room: dayClass["sala"].stringValue, startTime: dayClass["inicio"].stringValue, endTime: dayClass["termo"].stringValue))
                    }
                }
                
                DispatchQueue.main.async(execute: {
                    self.scheduleTable.reloadData()
                    self.calendar.reloadData()
                })
                
                self.viewCalendar.isHidden = false
                self.scheduleTable.isHidden = false
            } else {
                self.noScheduleInfo.isHidden = false
            }
        })
        
        self.calendar = viewCalendar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath as IndexPath)
        
        let data = classes[indexPath.row]
        
        cell.textLabel?.text = data.name
        cell.detailTextLabel?.text = "Sala \(data.room) - \(data.startTime) às \(data.endTime)"
        
        return cell
    }
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if let json = self.jsonData[self.dateFormatter.string(from: date)] {
            return json.count
        }
        return 0
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {        
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        
        self.classes.removeAll()
        
        if let json = self.jsonData[self.dateFormatter.string(from: date)] {
            for (_, dayClass) in json {
                self.classes.append(Class(name: dayClass["unidade"].stringValue, room: dayClass["sala"].stringValue, startTime: dayClass["inicio"].stringValue, endTime: dayClass["termo"].stringValue))
            }
        }
        
        DispatchQueue.main.async(execute: {
            self.scheduleTable.reloadData()
        })
    }
}
