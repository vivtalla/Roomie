//
//  SignUpViewController.swift
//  Roomie
//
//  Created by Vivek Tallavajhala  on 11/28/17.
//  Copyright © 2017 Monsters Inc. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet var emailField: UITextField!
    
    @IBOutlet var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func didTypeCreateAccount(_ sender: UIButton)
    {
        let email = emailField.text
        let password = passwordField.text
        //let validLogin = isValidEmail(stringValue: email!)
        
        Auth.auth().createUser(withEmail: email!, password: password!)
        {(user, error) in
            if error != nil {
                if let errCode = AuthErrorCode(rawValue: error!._code){
                    
                    switch errCode{
                    case .invalidEmail:
                        let alert = UIAlertController(title: "Invalid Email", message: "Please Type a Valid Email", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    case .emailAlreadyInUse:
                        let alert = UIAlertController(title: "Password Already in Use", message: "Please Type a Valid Email", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    default:
                        let alert = UIAlertController(title: "Other", message: "Please Type a Valid Email and Password", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
            else
            {
                let alert = UIAlertController(title: "User Succesfully Created", message: "Go back to Login Page to sign in", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        /*
        if validLogin
        {
            Auth.auth().createUser(withEmail: email!, password: password!)
            {(user, error) in
            
                
            if error == nil
                {
                    let alert = UIAlertController(title: "User Succesfully Created", message: "Go back to Login Page to sign in", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        else
        {
            let alert = UIAlertController(title: "Error", message: "Please Enter a Valid Email", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }*/
        }
    
    func isValidEmail(stringValue: String) ->Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: stringValue)
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
