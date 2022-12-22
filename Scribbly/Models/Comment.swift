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
    func addReply(text: String, prev: Reply?, reply_user: User) {
        if let prev = prev {
            let bold = "@" + prev.getReplyUser().getUserName()
            let attrs = [NSAttributedString.Key.font : Constants.comment_cell_reply_username_font]
            let bold_text = NSMutableAttributedString(string: bold, attributes: attrs)
            
            let normal_attrs = [NSAttributedString.Key.font : Constants.comment_cell_text_font]
            let normal_text = NSMutableAttributedString(string: " " + text, attributes: normal_attrs)
            bold_text.append(normal_text)
            
            let rep = Reply(text: bold_text, prev: prev, reply_user: reply_user)
            replies.append(rep)
        } else {
            let bold = "@" + user.getUserName()
            let bold_attrs = [NSAttributedString.Key.font : Constants.comment_cell_reply_username_font]
            let bold_text = NSMutableAttributedString(string: bold, attributes: bold_attrs)

            let normal_attrs = [NSAttributedString.Key.font : Constants.comment_cell_text_font]
            let normal_text = NSMutableAttributedString(string: " " + text, attributes: normal_attrs)

            bold_text.append(normal_text)

            let rep = Reply(text: bold_text, prev: nil, reply_user: reply_user)
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
    
    // ------------ Other functions ------------
    init(post: Post, text: String, user: User) {
        self.post = post
        self.text = text
        self.replies = []
        self.user = user
    }
}

class Reply {
    
    // ------------ Fields ------------
    private var text: NSMutableAttributedString
    private var prev: Reply?
    private var reply_user: User
    
    // ------------ Getters/Setters ------------
    func getReplyUser() -> User {
        return reply_user
    }
    
    func getText() -> NSMutableAttributedString {
        return text
    }
    
    // ------------ Other functions ------------
    init(text: NSMutableAttributedString, prev: Reply?, reply_user: User) {
        self.text = text
        self.prev = prev
        self.reply_user = reply_user
    }
}
