//
//  UIViewController.swift
//  UFP
//
//  Created by Rafael Almeida on 08/05/17.
//  Copyright © 2015 Shrikar Archak. All rights reserved.
//  http://shrikar.com/ios-swift-tutorial-uipageviewcontroller-as-user-onboarding-tool/
//

import Foundation

class ViewController: UIViewController {
    
    var pageViewController : PageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
        
        self.pageViewController.view.frame = CGRect(x: 0, y: 57, width: self.view.frame.width, height: self.view.frame.height - 57)
        
        self.view.addSubview(pageViewController.view)
        
        self.pageViewController.didMove(toParentViewController: self)
    }
    
    @IBAction func goToHome(_ sender: Any) {
        pageViewController.getToHome()
    }
    
}
