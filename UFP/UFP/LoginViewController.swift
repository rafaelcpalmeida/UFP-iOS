//
//  ViewController.swift
//  UFP
//
//  Created by Rafael Almeida on 13/03/17.
//  Copyright © 2017 Rafael Almeida. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var touch: UIImageView!
    @IBOutlet weak var userNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var bgActivity: UIActivityIndicatorView!
    
    let apiController = APIController()
    let context = LAContext()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (!hasBiometricAuth() || KeychainService.loadUserNumber() == "" || KeychainService.loadUserPassword() == "") {
            self.touch.isHidden = true
        }
        
        if(KeychainService.loadUserNumber() != "") {
            self.userNumber.text = KeychainService.loadUserNumber() as String?
        }
        
        let tapOutside: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tapOutside)
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(loginWithTouchID(tapGestureRecognizer:)))
        touch.isUserInteractionEnabled = true
        touch.addGestureRecognizer(tapGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //KeychainService.saveUserNumber(token: "")
        //KeychainService.saveUserPassword(token: "")
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
                
                if (context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)) {
                    self.touch.isHidden = false
                }
                
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func loginWithTouchID (tapGestureRecognizer: UITapGestureRecognizer) {
        context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Coloque o dedo para entrar") { (isSucessful, hasError) in
            if isSucessful {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.userNumber.isHidden = true
                    self.password.isHidden = true
                    self.loginButton.isHidden = true
                    self.touch.isHidden = true
                    self.bgActivity.startAnimating()
                }
                
                let userNumber = KeychainService.loadUserNumber(), userPassword = KeychainService.loadUserPassword()
                self.apiController.attemptLogin(userNumber: userNumber! as String, userPassword: userPassword! as String) { (json, error) in
                    self.bgActivity.stopAnimating()
                    if(error == nil) {
                        if(json["status"] == "Ok") {
                            APICredentials.sharedInstance.apiToken = json["message"].string
                            APICredentials.sharedInstance.userNumber = KeychainService.loadUserNumber() as String?
                            self.performSegue(withIdentifier: "loginSegue", sender: nil)
                        } else {
                            self.userNumber.isHidden = false
                            self.password.isHidden = false
                            self.loginButton.isHidden = false
                            self.touch.isHidden = false
                            let alert = UIAlertController(title: "Erro!", message: "Por favor verifique as suas credenciais de acesso.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    } else {
                        let alert = UIAlertController(title: "Erro!", message: "Ocorreu um erro, por favor tente novamente.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.userNumber.isHidden = false
                        self.password.isHidden = false
                        self.loginButton.isHidden = false
                        self.touch.isHidden = false
                    }
                }
            } else {
                let alert = UIAlertController(title: "Erro!", message: "Por favor verifique as suas credenciais de acesso.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func attemptLogin(_ sender: Any) {
        if (!(userNumber.text?.isEmpty)! && !(password.text?.isEmpty)!) {
            bgActivity.startAnimating()
            self.view.endEditing(true)
            
            self.userNumber.isHidden = true
            self.password.isHidden = true
            self.loginButton.isHidden = true
            self.touch.isHidden = true
            
            apiController.attemptLogin(userNumber: self.userNumber.text!, userPassword: self.password.text!) { (json, error) in
                self.bgActivity.stopAnimating()
                if(error == nil) {
                    if(json["status"] == "Ok") {
                        APICredentials.sharedInstance.apiToken = json["message"].string
                        APICredentials.sharedInstance.userNumber = self.userNumber.text!
                        if(self.hasBiometricAuth()) {
                            let touchIDAlert = UIAlertController(title: "Autenticação com TouchID", message: "Pretende activar o TouchID para entrar na aplicação?", preferredStyle: UIAlertControllerStyle.alert)
                        
                            touchIDAlert.addAction(UIAlertAction(title: "Sim", style: .default, handler: { (action: UIAlertAction!) in
                                KeychainService.saveUserNumber(token: self.userNumber.text! as NSString)
                                KeychainService.saveUserPassword(token: self.password.text! as NSString)
                                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                            }))
                        
                            touchIDAlert.addAction(UIAlertAction(title: "Não", style: .cancel, handler: { (action: UIAlertAction!) in
                                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                            }))
                        
                            self.present(touchIDAlert, animated: true, completion: nil)
                        } else {
                            self.performSegue(withIdentifier: "loginSegue", sender: nil)
                        }
                    } else {
                        self.userNumber.isHidden = false
                        self.password.isHidden = false
                        self.loginButton.isHidden = false
                        self.touch.isHidden = false
                        let alert = UIAlertController(title: "Erro!", message: "Por favor verifique as suas credenciais de acesso.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*if segue.identifier == "loginSegue", let nextView = segue.destination as? HomeViewController {
        }*/
    }
    
    private func hasBiometricAuth() -> Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }

}
