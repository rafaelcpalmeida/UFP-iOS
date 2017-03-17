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
    public var str: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.homeLabel.text = str
        
        print(APICredentials.sharedInstance.apiToken!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
