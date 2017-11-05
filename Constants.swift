//
//  Constants.swift
//  Roomie
//
//  Created by Vivek Tallavajhala  on 11/4/17.
//  Copyright © 2017 Monsters Inc. All rights reserved.
//

import Foundation

import Firebase

struct Constants
{
    struct refs
    {
        static let databaseRoot = Database.database().reference() //gets root of database
        static let databaseChats = databaseRoot.child("chats") //extends root with a child node called "chats"
    }
}
