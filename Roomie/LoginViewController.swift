//
//  LoginViewController.swift
//  Roomie
//
//  Created by Vivek Tallavajhala  on 11/28/17.
//  Copyright © 2017 Monsters Inc. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    
    @IBOutlet var emailField: UITextField!
    
    @IBOutlet var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func didPressLogin(_ sender: UIButton) {
        let email = emailField.text
        let password = passwordField.text
        
        Auth.auth().signIn(withEmail: email!, password: password!)
        {(user, error) in
        if error != nil {
            if let errCode = AuthErrorCode(rawValue: error!._code){
            
                switch errCode{
                case .userNotFound:
                    let alert = UIAlertController(title: "User Not Found", message: "Please create an account if you are a new user", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                case .wrongPassword:
                    let alert = UIAlertController(title: "Wrong Password", message: "Please Type the correct password", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                default:
                    let alert = UIAlertController(title: "Invalid Email or Password", message: "Please Type a Valid Email/Password or Create an Account", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                
                }
            
            
            }
            
            
            }
        else
        {
            self.signIn()
        }
        
        }
    }
    
    
    func signIn() {
        performSegue(withIdentifier: "LoginToHome", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
