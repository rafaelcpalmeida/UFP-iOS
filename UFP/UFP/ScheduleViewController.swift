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
    let deviceTimeZone = TimeZone.init(identifier: TimeZone.current.description.replacingOccurrences(of: " (current)", with: ""))
    let deviceCalendar = Calendar.current
    
    fileprivate weak var calendar: FSCalendar!
    
    var events = [Event]()
    var jsonData = [String: JSON]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var noClasses = false
        
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
                        self.events.append(Event(name: dayClass["unidade"].stringValue, room: dayClass["sala"].stringValue, date: self.dateFormatter.string(from: todayDate), startTime: dayClass["inicio"].stringValue, endTime: dayClass["termo"].stringValue))
                    }
                }
                
                self.calendar.scrollDirection = FSCalendarScrollDirection.vertical
                
                DispatchQueue.main.async(execute: {
                    self.scheduleTable.reloadData()
                    self.calendar.reloadData()
                })
                
                self.viewCalendar.isHidden = false
                self.scheduleTable.isHidden = false
            } else {
                noClasses = true
            }
        })
        
        apiController.getUserExams(APICredentials.sharedInstance.apiToken!, completionHandler: { (json, error) in
            if(json["status"] == "Ok") {
                for (_, data) in json["message"] {
                    for (date, info) in data {
                        self.jsonData[date] = info
                    }
                }
                
                let todayDate = Date()
                
                if let json = self.jsonData[self.dateFormatter.string(from: todayDate)] {
                    for (_, dayExam) in json {
                        var room: String = ""
                        
                        /* must find a most inteligent way to do this!!! */
                        for (value) in dayExam["room"].arrayValue {
                            room.append("\(value) & ")
                        }
                        
                        self.events.append(Event(name: dayExam["subject"].stringValue + " - " + dayExam["typology"].stringValue, room: String(room.characters.dropLast(3)), date: self.dateFormatter.string(from: todayDate), startTime: dayExam["time"].stringValue, endTime: ""))
                    }
                }
                
                self.calendar.scrollDirection = FSCalendarScrollDirection.vertical
                
                DispatchQueue.main.async(execute: {
                    self.scheduleTable.reloadData()
                    self.calendar.reloadData()
                })
                
                
                self.viewCalendar.isHidden = false
                self.scheduleTable.isHidden = false
            } else {
                if (noClasses) {
                    self.noScheduleInfo.isHidden = false
                }
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
        return events.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath as IndexPath)
        
        let data = events[indexPath.row]
        
        if (deviceTimeZone?.description) != nil {
            if (deviceTimeZone!.description.replacingOccurrences(of: " (current)", with: "") != "Europe/Lisbon") {
                if let classStart = self.dateFormatterWithHours.date(from: "\(data.date) \(data.startTime)") {
                    _ = Int(deviceTimeZone!.secondsFromGMT(for: classStart))
                    
                    cell.textLabel?.text = data.name
                    
                    let startingTime = String(format: "%02d:%02d", deviceCalendar.component(.hour, from: classStart), deviceCalendar.component(.minute, from: classStart))
                    
                    if let classEnd = self.dateFormatterWithHours.date(from: "\(data.date) \(data.endTime)") {
                        _ = Int(deviceTimeZone!.secondsFromGMT(for: classEnd))
                        
                        let endingTime = String(format: "%02d:%02d", deviceCalendar.component(.hour, from: classEnd), deviceCalendar.component(.minute, from: classEnd))
                        
                        cell.detailTextLabel?.text = String(format: NSLocalizedString("Room %@ - from %@ to %@ (GMT %@ to %@)", comment: ""), data.room, startingTime, endingTime, data.startTime, data.endTime)
                    }
                    
                    if (data.endTime == "") {
                        cell.detailTextLabel?.text = String(format: NSLocalizedString("Room %@ - from %@ (GMT %@)", comment: ""), data.room, startingTime, data.startTime)
                    }
                }
            } else {
                cell.textLabel?.text = data.name
                
                if (data.endTime != "") {
                    cell.detailTextLabel?.text = String(format: NSLocalizedString("Room %@ - from %@ to %@", comment: ""), data.room, data.startTime, data.endTime)
                } else {
                    cell.detailTextLabel?.text = String(format: NSLocalizedString("Room %@ - from %@", comment: ""), data.room, data.startTime)
                }
            }
        }
        
        return cell
    }
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    fileprivate lazy var dateFormatterWithHours: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.init(abbreviation: "GMT")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
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
        
        self.events.removeAll()
        
        if let json = self.jsonData[self.dateFormatter.string(from: date)] {
            for (_, event) in json {
                /* To whom find this code: please forgive me for this nonsense */
                if (!event["termo"].exists()) {
                    var room: String = ""
                    
                    /* must find a most inteligent way to do this!!! */
                    for (value) in event["room"].arrayValue {
                        room.append("\(value) & ")
                    }
                    
                    self.events.append(Event(name: event["subject"].stringValue + " - " + event["typology"].stringValue, room: String(room.characters.dropLast(3)), date: self.dateFormatter.string(from: date), startTime: event["time"].stringValue, endTime: ""))
                } else {
                    self.events.append(Event(name: event["unidade"].stringValue, room: event["sala"].stringValue, date: self.dateFormatter.string(from: date), startTime: event["inicio"].stringValue, endTime: event["termo"].stringValue))
                }
            }
        }
        
        DispatchQueue.main.async(execute: {
            self.scheduleTable.reloadData()
        })
    }
}
