//
//  FinalGrades.swift
//  UFP
//
//  Created by Rafael Almeida on 28/03/17.
//  Copyright © 2017 Rafael Almeida. All rights reserved.
//

import UIKit
import SwiftyJSON

class QueueTableViewCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var waitingLabel: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
}

class QueueViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var queueTable: UITableView!
    
    let apiController = APIController()
    let tableCellIdentifier = "tableCell"
    
    var queueStatus = [Queue]()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(QueueViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queueTable.delegate = self
        queueTable.dataSource = self
        
        self.queueTable.addSubview(self.refreshControl)
        
        fetchNewData()
    }
    
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.queueStatus.removeAll()
        
        fetchNewData(updated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.queueStatus.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath as IndexPath) as! QueueTableViewCell
        
        if self.queueStatus.indices.contains(indexPath.row) {
            cell.descriptionLabel.text = String(format: NSLocalizedString("Service %@ - %@", comment: ""), self.queueStatus[indexPath.row].service, self.queueStatus[indexPath.row].description)
            
            cell.numberLabel.text = String(format: NSLocalizedString("Number %@", comment: ""), self.queueStatus[indexPath.row].number)
            
            if (Int(self.queueStatus[indexPath.row].waiting) == 0) {
                cell.waitingLabel.isHidden = true
            } else {
                cell.waitingLabel.text = String(format: NSLocalizedString("%@ waiting", comment: ""), self.queueStatus[indexPath.row].waiting)
            }
            
            cell.lastUpdateLabel.text = String(format: NSLocalizedString("Last update - %@", comment: ""), self.queueStatus[indexPath.row].lastUpdate)
        }
        
        return cell
    }
    
    func fetchNewData(updated: Bool = false) {
        apiController.getQueueStatus(completionHandler: { (json, error) in
            self.activityIndicator.stopAnimating()
            if(json["status"] == "Ok") {
                for (keyLevel, data) in json["message"] {
                    self.queueStatus.append(Queue(service: keyLevel, number: data["number"].stringValue, description: data["desc"].stringValue, waiting: data["waiting"].stringValue, lastUpdate: data["last_update"].stringValue))
                }
            } else {
            }
            
            self.queueTable.reloadData()
            
            if updated {
                self.refreshControl.endRefreshing()
            }
        })
    }
    
}
