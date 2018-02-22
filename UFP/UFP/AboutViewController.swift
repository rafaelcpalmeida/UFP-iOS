//
//  AboutViewController.swift
//  UFP
//
//  Created by Rafael Almeida on 09/05/17.
//  Copyright © 2017 Rafael Almeida. All rights reserved.
//

import Foundation

class AboutViewController: UIViewController {
    
    @IBOutlet weak var ufpLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var heartLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.authorLabel.text = NSLocalizedString("2017 © Rafael Almeida and contributors", comment: "")
        self.heartLabel.text = NSLocalizedString("Made with ❤️", comment: "")
        self.ufpLabel.text = NSLocalizedString("University Fernando Pessoa", comment: "")
        
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
            if let dic = NSDictionary(contentsOfFile: path) as? [String: Any] {
                versionLabel.text = String(format: NSLocalizedString("Version %@ (%@)", comment: ""), (dic["CFBundleShortVersionString"] as! CVarArg), (dic["CFBundleVersion"] as! CVarArg))
            }
        }
        
        let authorTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openGitHub))
        authorLabel.isUserInteractionEnabled = true
        authorLabel.addGestureRecognizer(authorTap)
        
        let hearthTap = UITapGestureRecognizer(target: self, action: #selector(openLinkedIn))
        heartLabel.isUserInteractionEnabled = true
        heartLabel.addGestureRecognizer(hearthTap)
    }
    
    @IBAction func returnToBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func openLinkedIn() {
        UIApplication.shared.openURL(URL(string: "https://www.linkedin.com/in/rafaelcpalmeida/")!)
    }
    
    @objc func openGitHub() {
        UIApplication.shared.openURL(URL(string: "https://github.com/rafaelcpalmeida/UFP-iOS")!)
    }
    
}
