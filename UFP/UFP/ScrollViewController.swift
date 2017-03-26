//
//  ScrollViewController.swift
//  UFP
//
//  Created by Rafael Almeida on 26/03/17.
//  Copyright © 2017 Rafael Almeida. All rights reserved.
//

import Foundation

class ScrollViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: self.view.frame.width * 3, height: 1)
        
        let first = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "schedule")
        let second = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "atm")
        let third = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "schedule")
        
        self.addChildViewController(first)
        self.scrollView.addSubview(first.view)
        first.willMove(toParentViewController: self)
        
        self.addChildViewController(second)
        self.scrollView.addSubview(second.view)
        second.willMove(toParentViewController: self)
        
        self.addChildViewController(third)
        self.scrollView.addSubview(third.view)
        third.willMove(toParentViewController: self)
        
        first.view.frame.origin = CGPoint.zero
        second.view.frame.origin = CGPoint(x: self.view.frame.width, y: 0)
        third.view.frame.origin = CGPoint(x: self.view.frame.width * 2, y: 0)
        
        scrollView?.showsHorizontalScrollIndicator = false
    }
    
}
