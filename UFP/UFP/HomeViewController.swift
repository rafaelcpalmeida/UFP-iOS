//
//  HomeViewController.swift
//  UFP
//
//  Created by Rafael Almeida on 16/03/17.
//  Copyright © 2017 Rafael Almeida. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var homeLabel: UILabel!
    
    public var schedule: String = ""
    let apiController = APIController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.homeLabel.text = APICredentials.sharedInstance.userNumber!
        
        //print(APICredentials.sharedInstance.userNumber!)
        //print(APICredentials.sharedInstance.apiToken!)
        
        print (self.schedule)
        
        apiController.getUserSchedule(token: APICredentials.sharedInstance.apiToken!, completionHandler: { (json, error) in
            if(json["status"] == "Ok") {
                print(json["message"])
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 

}
