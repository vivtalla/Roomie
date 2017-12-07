//
//  SignUpViewController.swift
//  Roomie
//
//  Created by Vivek Tallavajhala  on 11/28/17.
//  Copyright © 2017 Monsters Inc. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet var emailField: UITextField!
    
    @IBOutlet var passwordField: UITextField!
    
    @IBOutlet var verifyPasswordField: UITextField!
    
    /*!
     * @discussion Checks sign up info
     * @param Sign up button pressed
     * @return Error message if sign in is invalid and authorization elsewhere
     */
    @IBAction func didTypeCreateAccount(_ sender: UIButton)
    {
        let email = emailField.text
        let password = passwordField.text
        let verify = verifyPasswordField.text

        if verify != password {
            let alert = UIAlertController(title: "Error", message: "Passwords do not match", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        Auth.auth().createUser(withEmail: email!, password: password!)
        {(user, error) in
            if error != nil {
                if let errCode = AuthErrorCode(rawValue: error!._code){

                    switch errCode{
                    case .invalidEmail:
                        let alert = UIAlertController(title: "Error", message: "Please Type a Valid Email", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    case .emailAlreadyInUse:
                        let alert = UIAlertController(title: "Error", message: "Email already in use", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    default:
                        let alert = UIAlertController(title: "Error", message: "Note: Password Requires a Minimum of Six Characters", preferredStyle: UIAlertControllerStyle.alert)
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
    }

    /*!
     * @discussion Checks email input for valid email address
     * @param String to check email validity
     * @return Boolean variable to authorize use of email
     */
    func isValidEmail(stringValue: String) ->Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: stringValue)
    }
}

