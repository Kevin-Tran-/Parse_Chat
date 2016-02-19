//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Kevin Tran on 2/18/16.
//  Copyright © 2016 Kevin Tran. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var messages: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        loadMessage()
        
        //reload message from Parse
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "onTimer", userInfo: nil, repeats: true)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSend(sender: UIButton) {
        let user = PFUser.currentUser()
        let message = PFObject(className: "Message")
        message["text"] = messageField.text
        message["user"] = user
        message.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                print("\(message["text"])")
            } else {
                // There was a problem, check error.description
                print("Message save failed with error: \(error)")
            }
        }
        messageField.text = ""
        loadMessage()
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messages != nil {
            return messages!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell", forIndexPath: indexPath) as! MessageCell
        let cellMessage = messages![indexPath.row]
        cell.messageLabel.text = cellMessage["text"] as? String
        if let user = cellMessage["user"] as? PFUser{
            cell.usernameLabel.text = user["username"] as? String
        } else {
            cell.usernameLabel.text = "anonymous"
        }
        print(indexPath.row)
        
        return cell
    }

    func onTimer() {
        // Add code to be run periodically
        loadMessage()
    }
    
    func loadMessage() {
        let query = PFQuery(className:"Message")
        query.orderByDescending("createdAt")
        query.whereKeyExists("text")
        query.includeKey("user")
        query.findObjectsInBackgroundWithBlock {
            (messages: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(messages!.count) messages.")
                // Do something with the found objects
                self.messages = messages
                self.tableView.reloadData()
                
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
