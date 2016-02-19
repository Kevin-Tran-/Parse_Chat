//
//  ViewController.swift
//  ParseChat
//
//  Created by Kevin Tran on 2/17/16.
//  Copyright © 2016 Kevin Tran. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    //var loginUser = PFUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(sender: UIButton) {

        PFUser.logInWithUsernameInBackground(loginField.text!, password: passwordField.text!) { (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                print("Login successful with user: \(user)")
//                self.loginUser = user!
                self.performSegueWithIdentifier("chatModal", sender: self)
            } else {
                print("Failed with error \(error)")
                let alertController = UIAlertController(title: "Error", message: "\(error!)", preferredStyle: .Alert)
                // create an OK action
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    // handle response here.
                }
                // add the OK action to the alert controller
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true) {
                    // optional code for what happens after the alert controller has finished presenting
                }
            }
        }
    }
    
    @IBAction func onSignUp(sender: UIButton) {
        let user = PFUser()
        print(loginField.text!)
        user.username = loginField.text!
        user.password = passwordField.text!
        
        user.signUpInBackgroundWithBlock { (succeded: Bool, error: NSError?) -> Void in
            if error == nil {
                print("Signup successful")
            } else {
                print("Failed with error \(error)")
                let alertController = UIAlertController(title: "Error", message: "\(error!)", preferredStyle: .Alert)
                // create an OK action
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                    // handle response here.
                }
                // add the OK action to the alert controller
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true) {
                    // optional code for what happens after the alert controller has finished presenting
                }
                
                
                
            }
        }
    }
    

}

