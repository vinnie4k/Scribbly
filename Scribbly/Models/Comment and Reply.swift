//
//  Comment and Reply.swift
//  Scribbly
//
//  Created by Vin Bui on 12/21/22.
//

// TODO: ALREADY REFACTORED

import Foundation

// MARK: Comment Model Class
class Comment {
    // MARK: - Properties
    private var post: Post
    private var user: User
    private var text: String
    private var replies: [Reply]
    
    // MARK: - Getters and Setters
    func removeReply(reply: Reply) {
        if let index = replies.firstIndex(where: {$0 === reply}) {
            replies.remove(at: index)
        }
    }
    
    func addReply(text: String, prev: Reply?, replyUser: User) {
        if let prev = prev {
            let bold = "@" + prev.getReplyUser().getUserName()
            let attrs = [NSAttributedString.Key.font : Constants.getFont(size: 16, weight: .bold)]
            let bold_text = NSMutableAttributedString(string: bold, attributes: attrs)
            
            let normal_attrs = [NSAttributedString.Key.font : Constants.getFont(size: 16, weight: .regular)]
            let normal_text = NSMutableAttributedString(string: " " + text, attributes: normal_attrs)
            bold_text.append(normal_text)
            
            let rep = Reply(text: bold_text, prev: prev, replyUser: replyUser)
            replies.append(rep)
        } else {
            let bold = "@" + user.getUserName()
            let bold_attrs = [NSAttributedString.Key.font : Constants.getFont(size: 16, weight: .bold)]
            let bold_text = NSMutableAttributedString(string: bold, attributes: bold_attrs)

            let normal_attrs = [NSAttributedString.Key.font : Constants.getFont(size: 16, weight: .regular)]
            let normal_text = NSMutableAttributedString(string: " " + text, attributes: normal_attrs)

            bold_text.append(normal_text)

            let rep = Reply(text: bold_text, prev: nil, replyUser: replyUser)
            replies.append(rep)
        }
    }
    
    func getUser() -> User {
        return user
    }
    
    func getText() -> String {
        return text
    }
    
    func getReplies() -> [Reply] {
        return replies
    }
    
    // MARK: - init
    init(post: Post, text: String, user: User) {
        self.post = post
        self.text = text
        self.replies = []
        self.user = user
    }
}

// MARK: Reply Model Class
class Reply {
    // MARK: - Properties
    private var text: NSMutableAttributedString
    private var prev: Reply?
    private var replyUser: User
    
    // MARK: - Getters and Setters
    func getReplyUser() -> User {
        return replyUser
    }
    
    func getText() -> NSMutableAttributedString {
        return text
    }
    
    // MARK: - init
    init(text: NSMutableAttributedString, prev: Reply?, replyUser: User) {
        self.text = text
        self.prev = prev
        self.replyUser = replyUser
    }
}
