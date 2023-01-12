//
//  Post.swift
//  Scribbly
//
//  Created by Vin Bui on 12/18/22.
//

// TODO: ALREADY REFACTORED

import UIKit

// MARK: Post Model Class
class Post: Codable, Equatable, Identifiable {
    // MARK: - Properties
    var id: String
    var user: String           // User ID
    var drawing: String
    var caption: String
    var time: String
    
    var comments: [String:Comment]?          // Array of comment IDs
    var likedUsers: [String:String]?          // Array of user IDs
    var bookmarkedUsers: [String:String]?     // Array of user IDs
    var hidden: Bool
    
    // MARK: - Equatable
    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.id == rhs.id
    }
    
    // MARK: - Getters and Setters
    func setHidden(bool: Bool) {
        DatabaseManager.hidePost(with: self.id, hide: bool, completion: { [weak self] success in
            guard let `self` = self else { return }
            self.hidden = bool
        })
    }

    func isHidden() -> Bool {
        return hidden
    }

    func getTime() -> Date {
        let format = DateFormatter()
        format.dateFormat = "d MMMM yyyy HH:mm:ss"
        return format.date(from: time)!
    }

    func getCommentReplyCount() -> Int {
        if comments == nil { return 0 }
        var count: Int = 0
        for comment in comments!.values.map({$0}) {
            count += comment.getReplies().count
            count += 1
        }
        return count
    }

    func getBookmarkCount() -> Int {
        if bookmarkedUsers == nil { return 0 }
        return bookmarkedUsers!.count
    }

    func getLikeCount() -> Int {
        if likedUsers == nil { return 0 }
        return likedUsers!.count
    }

    func removeBookmarkUser(user: User) {
        DatabaseManager.removeBookmarkedUser(with: user.id, postID: self.id, completion: { [weak self] success in
            guard let `self` = self else { return }
            if success {
                if let keys = self.bookmarkedUsers?.allKeys(forValue: user.id) {
                    self.bookmarkedUsers?.removeValue(forKey: keys[0])
                }
            }
        })
    }

    func addBookmarkUser(user: User) {
        if bookmarkedUsers == nil {
            bookmarkedUsers = [:]
        }
        
        DatabaseManager.addBookmarkedUser(with: user.id, postID: self.id, completion: { [weak self] success, key in
            guard let `self` = self else { return }
            if success {
                self.bookmarkedUsers![key] = user.id
            }
        })
    }

    func containsLikedUser(user: User) -> Bool {
        if likedUsers == nil { return false }
        for userID in likedUsers!.values.map({$0}) {
            if userID == user.id {
                return true
            }
        }
        return false
    }

    func removedLikedUsers(user: User) {
        DatabaseManager.unlikePost(with: user.id, postID: self.id, completion: { [weak self] success in
            guard let `self` = self else { return }
            if success {
                if let keys = self.likedUsers?.allKeys(forValue: user.id) {
                    self.likedUsers?.removeValue(forKey: keys[0])
                }
            }
        })
    }

    func addLikedUsers(user: User) {
        if likedUsers == nil {
            likedUsers = [:]
        }
        
        DatabaseManager.likePost(with: user.id, postID: self.id, completion: { [weak self] success, key in
            guard let `self` = self else { return }
            if success {
                self.likedUsers![key] = user.id
            }
        })
    }

    func removeComment(key: String) {
        self.comments?.removeValue(forKey: key)
    }
    
    func addComment(key: String, comment: Comment) {
        if comments == nil {
            comments = [:]
        }
        comments![key] = comment
    }

    func getComments() -> [Comment] {
        if comments == nil {
            return []
        }
        
        let format = DateFormatter()
        format.dateFormat = "d MMMM yyyy HH:mm:ss"
        
        return comments!.values.sorted(by: {
            format.date(from: $0.time)!.compare(format.date(from: $1.time)!) == .orderedDescending
        })
    }

    func getUser() -> User {
        return UserMap.map[user]!
    }

    func getDrawing() -> UIImage {
        return ImageMap.map[drawing]!
    }

    func getCaption() -> String {
        return caption
    }

    // MARK: - init
    init(id: String, user: String, drawing: String, caption: String, time: String, comments: [String:Comment]?, likedUsers: [String:String]?, bookmarkedUsers: [String:String]?, hidden: Bool) {
        self.id = id
        self.user = user
        self.drawing = drawing
        self.caption = caption
        self.time = time
        self.comments = comments
        self.likedUsers = likedUsers
        self.bookmarkedUsers = bookmarkedUsers
        self.hidden = hidden
    }
}
