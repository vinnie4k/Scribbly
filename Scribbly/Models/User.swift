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
    private var posts: [Post]
    
    // ------------ Getters/Setters ------------
    func getPFP() -> UIImage {
        return pfp
    }
    
    func getUserName() -> String {
        return user_name
    }
    
    func getPosts() -> [Post] {
        return posts
    }
    
    func getLatestPost() -> Post {
        // TODO: maybe only return if it matches today's date?
        return posts[posts.count - 1]
    }
    
    func addPost(post: Post) {
        posts.append(post)
    }

    
    // ------------ Initializer ------------
    init(pfp: UIImage, full_name: String, user_name: String, bio: String) {
        self.pfp = pfp
        self.full_name = full_name
        self.user_name = user_name
        self.bio = bio
        self.posts = []
    }
}
