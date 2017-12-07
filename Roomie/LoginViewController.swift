//
//  LoginViewController.swift
//  Roomie
//
//  Created by Vivek Tallavajhala  on 11/28/17.
//  Copyright © 2017 Monsters Inc. All rights reserved.
//

import UIKit
import Foundation
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet var emailField: UITextField!
    
    @IBOutlet var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /*!
     * @discussion Checks login info
     * @param Login button pressed
     * @return Error message if login is invalid and authorization elsewhere
     */
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
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                case .wrongPassword:
                    let alert = UIAlertController(title: "Wrong Password", message: "Please Type the correct password", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                default:
                    let alert = UIAlertController(title: "Invalid Email or Password", message: "Please Type a Valid Email/Password or Create an Account", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
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
    
    
    /*!
     * @discussion Allows user to reset password
     * @param Reset button pressed
     * @return Email with reset info
     */
    @IBAction func didTapForgotPassword(_ sender: UIButton) {
        
        let prompt = UIAlertController(title: "Roomie", message: "Recovery Email:", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let userInput = prompt.textFields![0].text
            if (userInput!.isEmpty)
            {
                return
            }
            Auth.auth().sendPasswordReset(withEmail: userInput!) {error in
                if error != nil {
                    if let errCode = AuthErrorCode(rawValue: error!._code){
                 
                        switch errCode{
                        case .userNotFound:
                            let alert = UIAlertController(title: "User Not Found", message: "Try Registering", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        default:
                            let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)

                        }
                    }
                }
                else
                {
                    DispatchQueue.main.async{
                        let alert = UIAlertController(title: "Sweet!", message: "You'll Recieve an email shortly to reset your password", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(okAction)
        present(prompt, animated: true, completion: nil)
    }
    
    /*!
     * @discussion Signs user into main menu
     * @param None
     * @return None
     */
    func signIn() {
        performSegue(withIdentifier: "LoginToHome", sender: nil)
    }
}
