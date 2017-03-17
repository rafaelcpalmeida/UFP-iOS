//
//  ViewController.swift
//  UFP
//
//  Created by Rafael Almeida on 13/03/17.
//  Copyright © 2017 Rafael Almeida. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var touch: UIImageView!
    @IBOutlet weak var userNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var bgActivity: UIActivityIndicatorView!
    
    let apiController = APIController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (checkInvalidiDeviceVersion(model: UIDevice.current.modelName)) {
            self.touch.isHidden = true
        }
        
        let tapOutside: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        view.addGestureRecognizer(tapOutside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.logo.isHidden = true
                self.touch.isHidden = true
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.logo.isHidden = false
                
                if (!checkInvalidiDeviceVersion(model: UIDevice.current.modelName)) {
                    self.touch.isHidden = false
                }
                
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    @IBAction func attemptLogin(_ sender: Any) {
        if (!(userNumber.text?.isEmpty)! && !(password.text?.isEmpty)!) {
            userNumber.isEnabled = false
            password.isEnabled = false
            loginButton.isEnabled = false
            
            bgActivity.startAnimating()
            
            apiController.attemptLogin(userNumber: self.userNumber.text!, userPassword: self.password.text!) { (json, error) in
                self.bgActivity.stopAnimating()
                if(error == nil) {
                    if(json["status"] == "Ok") {
                        APICredentials.sharedInstance.apiToken = json["message"].string
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    } else {
                        self.userNumber.isEnabled = true
                        self.password.isEnabled = true
                        self.loginButton.isEnabled = true
                        let alert = UIAlertController(title: "Erro!", message: "Por favor verifique as suas credenciais de acesso.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue" ,
            let nextView = segue.destination as? HomeViewController {
            nextView.str = "Olá " + self.userNumber.text!
        }
    }
    
    private func checkInvalidiDeviceVersion(model: String) -> Bool {
        return model.range(of:"(4s)|(4)|(5)|(iPod)", options:.regularExpression) != nil
    }

}
