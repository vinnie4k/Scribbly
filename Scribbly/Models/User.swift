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
    private var bookmarked_posts: [Post]
    
    // ------------ Getters/Setters ------------
    func getBio() -> String {
        return bio
    }
    
    func getFullName() -> String {
        return full_name
    }
    
    func isBookmarked(post: Post) -> Bool {
        for i in bookmarked_posts {
            if i === post {
                return true
            }
        }
        return false
    }
    
    func removeBookmarkPost(post: Post) {
        if let index = bookmarked_posts.firstIndex(where: {$0 === post}) {
            bookmarked_posts.remove(at: index)
        }
    }
    
    func addBookmarkPost(post: Post) {
        bookmarked_posts.append(post)
    }
    
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
        self.bookmarked_posts = []
    }
}
