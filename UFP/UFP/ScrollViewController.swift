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
        
        scrollView.contentSize = CGSize(width: self.view.frame.width * 4, height: 1)
        
        let schedule = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "schedule")
        let atm = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "atm")
        let assiduity = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "assiduity")
        let finalGrades = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "finalGrades")
        
        self.addChildViewController(schedule)
        self.scrollView.addSubview(schedule.view)
        schedule.willMove(toParentViewController: self)
        
        self.addChildViewController(atm)
        self.scrollView.addSubview(atm.view)
        atm.willMove(toParentViewController: self)
        
        self.addChildViewController(assiduity)
        self.scrollView.addSubview(assiduity.view)
        assiduity.willMove(toParentViewController: self)
        
        self.addChildViewController(finalGrades)
        self.scrollView.addSubview(finalGrades.view)
        finalGrades.willMove(toParentViewController: self)
        
        schedule.view.frame.origin = CGPoint.zero
        atm.view.frame.origin = CGPoint(x: self.view.frame.width, y: 0)
        assiduity.view.frame.origin = CGPoint(x: self.view.frame.width * 2, y: 0)
        finalGrades.view.frame.origin = CGPoint(x: self.view.frame.width * 3, y: 0)
        
        scrollView?.showsHorizontalScrollIndicator = false
    }
    
}
