//
//  Database.swift
//  Scribbly
//
//  Created by Vin Bui on 1/1/23.
//

import UIKit

// MARK: Database
class Database {
    // MARK: - Class Properties
    private static var users = [User]()
    
    // MARK: - Getters and Setters
    static func addUser(user: User) {
        Database.users.append(user)
    }
    
    // MARK: - Helpers
    static func containsUsername(username: String, user: User) -> Bool {
        for i in Database.users {
            if i !== user && i.getUserName() == username {
                return true
            }
        }
        return false
    }
    
    static func containsEmail(email: String, user: User) -> Bool {
        for i in Database.users {
            if i !== user && i.getEmail() == email {
                return true
            }
        }
        return false
    }
}
