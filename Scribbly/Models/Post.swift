//
//  Post.swift
//  Scribbly
//
//  Created by Vin Bui on 12/18/22.
//

import UIKit

class Post {
    // ------------ Fields ------------
    private var user: User
    private var drawing: UIImage
    private var caption: String
    private var time: Date
    private var comments: [Comment]
    private var liked_users: [User]
    private var bookmarked_users: [User]
    
    // ------------ Getters/Setters ------------
    func getCommentReplyCount() -> Int {
        var count: Int = 0
        for comment in comments {
            count += comment.getReplies().count
            count += 1
        }
        return count
    }
    
    func getBookmarkCount() -> Int {
        return bookmarked_users.count
    }
    
    func getLikeCount() -> Int {
        return liked_users.count
    }
    
    func removeBookmarkUser(user: User) {
        if let index = bookmarked_users.firstIndex(where: {$0 === user}) {
            bookmarked_users.remove(at: index)
        }
    }
    
    func addBookmarkUser(user: User) {
        bookmarked_users.append(user)
    }
    
    func containsLikedUser(user: User) -> Bool {
        for i in liked_users {
            if i === user {
                return true
            }
        }
        return false
    }
    
    func removedLikedUsers(user: User) {
        if let index = liked_users.firstIndex(where: {$0 === user}) {
            liked_users.remove(at: index)
        }
    }
    
    func addLikedUsers(user: User) {
        liked_users.append(user)
    }
    
    func removeComment(comment: Comment) {
        if let index = comments.firstIndex(where: {$0 === comment}) {
            comments.remove(at: index)
        }
    }
    
    func addComment(comment_user: User, text: String) {
        let cmt = Comment(post: self, text: text, user: comment_user)
        comments.append(cmt)
    }
    
    func getComments() -> [Comment] {
        return comments
    }
    
    func getUser() -> User {
        return user
    }
    
    func getDrawing() -> UIImage {
        return drawing
    }
    
    func getCaption() -> String {
        return caption
    }
    
    init(user: User, drawing: UIImage, caption: String, time: Date) {
        self.user = user
        self.drawing = drawing
        self.caption = caption
        self.time = time
        self.comments = []
        self.liked_users = []
        self.bookmarked_users = []
    }
}
