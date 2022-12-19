//
//  User.swift
//  Scribbly
//
//  Created by Vin Bui on 12/18/22.
//
import UIKit

class User {
    
    // ------------ Fields ------------
    private var pfp: UIImage
    private var full_name: String
    private var user_name: String
    private var bio: String
    // TODO: add a field for memories (array of Post objects)
    
    // ------------ Getters/Setters ------------
    func getPFP() -> UIImage {
        return pfp
    }
    
    func getFullName() -> String {
        return full_name
    }

    
    // ------------ Initializer ------------
    init(pfp: UIImage, full_name: String, user_name: String, bio: String) {
        self.pfp = pfp
        self.full_name = full_name
        self.user_name = user_name
        self.bio = bio
    }
}
