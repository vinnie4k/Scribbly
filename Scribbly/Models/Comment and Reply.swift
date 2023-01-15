//
//  Comment and Reply.swift
//  Scribbly
//
//  Created by Vin Bui on 12/21/22.
//

// TODO: ALREADY REFACTORED

import Foundation

// MARK: Comment Model Class
class Comment: Codable, Equatable, Identifiable {
    // MARK: - Properties
    var id: String
    var post: String        // Post ID
    var user: String        // User ID
    var text: String
    var time: String    // Format: 6 January 2023 19:53:10
    var replies: [String:Reply]?  // Array of reply IDs
    
    // MARK: - Equatable
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        lhs.id == rhs.id
    }

    // MARK: - Getters and Setters
    func removeReply(key: String) {
        replies?.removeValue(forKey: key)
    }

    func addReply(key: String, reply: Reply) {
        if replies == nil {
            replies = [:]
        }
        self.replies![key] = reply
    }

    func getUser() -> User {
        return UserMap.map[user]!
    }

    func getText() -> String {
        return text
    }

    func getReplies() -> [Reply] {
        if replies == nil {
            return []
        }
        
        let format = DateFormatter()
        format.dateFormat = "d MMMM yyyy HH:mm:ss"
        format.timeZone = TimeZone(identifier: "America/New_York")
        
        return replies!.values.sorted(by: {
            format.date(from: $0.time)!.compare(format.date(from: $1.time)!) == .orderedAscending
        })
    }

    // MARK: - init
    init(id: String, post: String, user: String, text: String, time: String, replies: [String:Reply]?) {
        self.id = id
        self.post = post
        self.user = user
        self.text = text
        self.time = time
        self.replies = replies
    }
}

// MARK: Reply Model Class
class Reply: Codable, Equatable, Identifiable {
    // MARK: - Properties
    var id: String
    var prevReply: String   // empty if this is a reply to a comment, non-empty if reply to another reply
    var user: String      // id of the person replying
    var text: String
    var time: String
    
    // MARK: - Equatable
    static func == (lhs: Reply, rhs: Reply) -> Bool {
        lhs.id == rhs.id
    }

    // MARK: - Getters and Setters
    func getReplyUser() -> User {
        return UserMap.map[user]!
    }
    
    func getText() -> NSMutableAttributedString {
        let space = text.firstIndex(of: " ")
        let username = text[...space!]
        
        let afterSpace = text.index(space!, offsetBy: 1)
        let response = text[afterSpace...]
        
        let attrs = [NSAttributedString.Key.font : Constants.getFont(size: 16, weight: .bold)]
        let bold_text = NSMutableAttributedString(string: String(username), attributes: attrs)

        let normal_attrs = [NSAttributedString.Key.font : Constants.getFont(size: 16, weight: .regular)]
        let normal_text = NSMutableAttributedString(string: String(response), attributes: normal_attrs)
        
        bold_text.append(normal_text)
        return bold_text
    }

    // MARK: - init
    init(id: String, prevReply: String, user: String, text: String, time: String) {
        self.id = id
        self.prevReply = prevReply
        self.user = user
        self.text = text
        self.time = time
    }
}
