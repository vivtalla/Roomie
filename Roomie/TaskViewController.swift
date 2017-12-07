//
//  TaskViewController.swift
//  Roomie
//
//  Created by Pumposh Bhat on 11/30/17.
//  Copyright © 2017 Monsters Inc. All rights reserved.
//

import UIKit
import Firebase

class TaskViewController: UITableViewController {
    
    let listToUsers = "ListToUsers"
    let ref = Database.database().reference(withPath: "tasks")
    let usersRef = Database.database().reference(withPath: "online")
    
    var items: [Task] = []
    var user: User!
    var userCountBarButtonItem: UIBarButtonItem!
    
    /*!
     * @discussion Loads task view info
     * @param None
     * @return None
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        ref.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
            var newItems: [Task] = []
            
            for item in snapshot.children {
                let task = Task(snapshot: item as! DataSnapshot)
                newItems.append(task)
            }
            
            self.items = newItems
            self.tableView.reloadData()
        })
        
        tableView.allowsMultipleSelectionDuringEditing = false
        
        userCountBarButtonItem = UIBarButtonItem(title: "1",
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(userCountButtonDidTouch))
        
        Auth.auth().addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = User(authData: user)
            
            let currentUserRef = self.usersRef.child(self.user.uid)
            currentUserRef.setValue(self.user.email)
            currentUserRef.onDisconnectRemoveValue()
        }
        
        usersRef.observe(.value, with: { snapshot in
            if snapshot.exists() {
                self.userCountBarButtonItem?.title = snapshot.childrenCount.description
            } else {
                self.userCountBarButtonItem?.title = "0"
            }
        })
    }
    
    /*!
     * @discussion Sets the table output view
     * @param Table view to be altered, number of tasks
     * @return Int of number of items
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    /*!
     * @discussion Sets table output view
     * @param Table view, index for cell
     * @return UITableViewCell object to be added to list
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let taskItem = items[indexPath.row]
        
        cell.textLabel?.text = taskItem.name
        cell.detailTextLabel?.text = taskItem.addedByUser
        
        toggleCellCheckbox(cell, isCompleted: taskItem.completed)
        
        return cell
    }
    
    /*!
     * @discussion Sets table output view
     * @param Table view, index for cell to be edited
     * @return Bool if row is editable
     */
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /*!
     * @discussion Sets table output view
     * @param Table view, editing style, and index of object
     * @return None
     */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let taskItem = items[indexPath.row]
            taskItem.ref?.removeValue()
        }
    }
    
    /*!
     * @discussion Sets table output view for the selected item
     * @param Table view, index for selected object
     * @return None
     */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        let taskItem = items[indexPath.row]
        let toggledCompletion = !taskItem.completed
        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
        taskItem.ref?.updateChildValues([
            "completed": toggledCompletion
            ])
    }
    
    /*!
     * @discussion Toggles checkbox for each cell for whether it is completed
     * @param Table view, boolean for completion
     * @return None
     */
    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
        if !isCompleted {
            cell.accessoryType = .none
            cell.textLabel?.textColor = UIColor.black
            cell.detailTextLabel?.textColor = UIColor.black
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor.gray
            cell.detailTextLabel?.textColor = UIColor.gray
        }
    }
    
    /*!
     * @discussion Allows user to add object to list
     * @param Any object
     * @return None
     */
    @IBAction func addButtonTouch(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Task",
                                      message: "Add an Item",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { _ in
                                        guard let textField = alert.textFields?.first,
                                            let text = textField.text else { return }
                                        let task = Task(name: text, addedByUser: self.user.email, completed: false)
                                        let taskRef = self.ref.child(text.lowercased())
                                        taskRef.setValue(task.toAnyObject())
                                        
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func userCountButtonDidTouch() {
        performSegue(withIdentifier: listToUsers, sender: nil)
    }
    
}
