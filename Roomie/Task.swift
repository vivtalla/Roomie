//
//  Task.swift
//  Roomie
//
//  Created by Pumposh Bhat on 11/30/17.
//  Copyright © 2017 Monsters Inc. All rights reserved.
//

import Foundation
import Firebase

struct Task {
    
    let key: String
    let name: String
    let addedByUser: String
    let ref: DatabaseReference?
    var completed: Bool
    
    init(name: String, addedByUser: String, completed: Bool, key: String = "") {
        self.key = key
        self.name = name
        self.addedByUser = addedByUser
        self.completed = completed
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        addedByUser = snapshotValue["addedByUser"] as! String
        completed = snapshotValue["completed"] as! Bool
        ref = snapshot.ref
    }
    
    /*!
     * @discussion Allows task to be interpreted as any object with set values
     * @param Task object exists
     * @return Object of any specified type
     */
    func toAnyObject() -> Any {
        return [
            "name": name,
            "addedByUser": addedByUser,
            "completed": completed
        ]
    }
    
}
