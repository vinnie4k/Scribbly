//
//  Comment.swift
//  Scribbly
//
//  Created by Vin Bui on 12/21/22.
//

import Foundation

class Comment {
    
    // ------------ Fields ------------
    private var post: Post
    private var user: User
    private var text: String
    private var replies: [Reply]
    
    // ------------ Getters/Setters ------------
    func getUser() -> User {
        return user
    }
    
    func getText() -> String {
        return text
    }
    
    func getReplies() -> [Reply] {
        return replies
    }
    
    init(post: Post, text: String, user: User) {
        self.post = post
        self.text = text
        self.replies = []
        self.user = user
    }
}

class Reply {
    
    // ------------ Fields ------------
    private var text: String
    private var prev: Reply?
    private var user: User
    
    // ------------ Getters/Setters ------------
    
    init(text: String, prev: Reply, user: User) {
        self.text = text
        self.prev = prev
        self.user = user
    }
}
