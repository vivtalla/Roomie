//
//  User.swift
//  Roomie
//
//  Created by Pumposh Bhat on 11/30/17.
//  Copyright © 2017 Monsters Inc. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    
    init(authData: Firebase.User) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
    
}

