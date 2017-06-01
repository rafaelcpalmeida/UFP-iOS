//
//  TeacherDetailsViewController.swift
//  UFP
//
//  Created by Rafael Almeida on 01/06/17.
//  Copyright © 2017 Rafael Almeida. All rights reserved.
//

import Foundation
import SwiftyJSON

class TeacherDetailsViewController: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var attendanceField: UITextView!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    
    let apiController = APIController()
    var teacherInitials: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiController.getTeacherDetails(initials: teacherInitials) { (json, err) in
            
            if(json["status"] == "Ok") {
                self.nameLabel.text = json["message"]["name"].stringValue
                self.emailLabel.text = json["message"]["email"].stringValue
                
                self.attendanceField.text = ""
                for (key, value) in json["message"]["schedule"] {                    
                    self.attendanceField.text.append(key + "\n\n")
                    
                    for (date) in value {
                        self.attendanceField.text.append(date.1.stringValue + "\n")
                    }
                    
                    self.attendanceField.text.append("\n\n\n")
                }
                
                self.lastUpdateLabel.text = String(format: NSLocalizedString("Last updated at %@", comment: ""), json["message"]["last_update"].stringValue)
                
                self.nameLabel.isHidden = false
                self.emailLabel.isHidden = false
                self.attendanceField.isHidden = false
                if(json["message"]["last_update"].stringValue != "") {
                    self.lastUpdateLabel.isHidden = false
                }
            } else {
            }

        }
    }
    
    @IBAction func returnToPreviousView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
