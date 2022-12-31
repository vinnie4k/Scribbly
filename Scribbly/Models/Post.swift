//
//  Post.swift
//  Scribbly
//
//  Created by Vin Bui on 12/18/22.
//

// TODO: ALREADY REFACTORED

import UIKit

// MARK: Post Model Class
class Post {
    // MARK: - Properties
    private var user: User
    private var drawing: UIImage
    private var caption: String
    private var time: Date
    private var comments: [Comment]
    private var likedUsers: [User]
    private var bookmarkedUsers: [User]
    private var hidden: Bool
    
    // MARK: - Getters and Setters
    func setHidden(bool: Bool) {
        hidden = bool
    }
    
    func isHidden() -> Bool {
        return hidden
    }
    
    func getTime() -> Date {
        return time
    }
    
    func getCommentReplyCount() -> Int {
        var count: Int = 0
        for comment in comments {
            count += comment.getReplies().count
            count += 1
        }
        return count
    }
    
    func getBookmarkCount() -> Int {
        return bookmarkedUsers.count
    }
    
    func getLikeCount() -> Int {
        return likedUsers.count
    }
    
    func removeBookmarkUser(user: User) {
        if let index = bookmarkedUsers.firstIndex(where: {$0 === user}) {
            bookmarkedUsers.remove(at: index)
        }
    }
    
    func addBookmarkUser(user: User) {
        bookmarkedUsers.append(user)
    }
    
    func containsLikedUser(user: User) -> Bool {
        for i in likedUsers {
            if i === user {
                return true
            }
        }
        return false
    }
    
    func removedLikedUsers(user: User) {
        if let index = likedUsers.firstIndex(where: {$0 === user}) {
            likedUsers.remove(at: index)
        }
    }
    
    func addLikedUsers(user: User) {
        likedUsers.append(user)
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
    
    // MARK: - init
    init(user: User, drawing: UIImage, caption: String, time: Date) {
        self.user = user
        self.drawing = drawing
        self.caption = caption
        self.time = time
        self.comments = []
        self.likedUsers = []
        self.bookmarkedUsers = []
        self.hidden = false
    }
}
