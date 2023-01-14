//
//  DatabaseManager.swift
//  Scribbly
//
//  Created by Vin Bui on 1/3/23.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import CodableFirebase
import UIKit
import Contacts

final class DatabaseManager {
    static private let database = Database.database().reference()
}

// MARK: - Other Helpers

extension DatabaseManager {
    
    /// Add fcm token to database
    static func addToken(with token: String, userID: String, completion: @escaping (Bool) -> Void) {
        let ref = DatabaseManager.database.child("userid_tokens_map/\(userID)")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            let enumerator = snapshot.children
            var found = false
            while let snap = enumerator.nextObject() as? DataSnapshot, !found {
                guard let data = snap.value as? String else { return }
                if data == token {
                    found = true
                }
            }
            if !found {
                ref.childByAutoId().setValue(token, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        print("Unable to add the fcm token to the database.")
                        completion(false)
                        return
                    }
                    completion(true)
                })
            } else {
                print("Token already exists.")
                completion(false)
            }
        })
    }
    
    /// Get a list of Users in the main user's contacts page
    static func getContacts(completion: @escaping ([User]) -> Void) {
        let group = DispatchGroup()
        let store = CNContactStore()
        let keys = [CNContactPhoneNumbersKey]
        var numbers: [String] = []
        var accum: [User] = []
        
        do {
            try store.enumerateContacts(with: CNContactFetchRequest.init(keysToFetch: keys as [CNKeyDescriptor]), usingBlock: { contact, pointer in
                numbers.append(contentsOf: contact.phoneNumbers.map({ $0.value.stringValue }))
            })
        } catch { print("Unable to fetch the user's contacts.")}
        
        for num in numbers {
            group.enter()
            DatabaseManager.database.child("phone_id_map/\(num)").observeSingleEvent(of: .value, with: { snapshot in
                guard snapshot.exists() else { group.leave(); return }
                guard let data = snapshot.value as? String else { group.leave(); return }
                DatabaseManager.getOtherUserStartup(with: data, completion: { user, _ in
                    accum.append(user)
                    group.leave()
                })
            }) { error in print(error.localizedDescription) }
        }
        
        group.notify(queue: .main) {
            completion(accum)
        }
    }
}

// MARK: - Prompt Helpers
extension DatabaseManager {
    /// Get today's prompt
    static func getTodaysPrompt(with dateKey: String, completion: @escaping (String) -> Void) {
        DatabaseManager.database.child("prompts/\(dateKey)").observeSingleEvent(of: .value, with: { snapshot in
            guard let prompt = snapshot.value as? String else { print("Unable to get prompt"); return }
            completion(prompt)
        }) { error in print(error.localizedDescription) }
    }
}

// MARK: - User Management
extension DatabaseManager {
    
    /// Get a list of up to 20 users with the given username/name
    static func searchUsers(with name: String, completion: @escaping ([User]) -> Void) {
        if name == "" {
            completion([])
        } else {
            let ref = DatabaseManager.database.child("users")
            ref.queryOrdered(byChild: "userName").queryStarting(atValue: name).queryEnding(atValue: name+"\u{f8ff}").observeSingleEvent(of: .value, with: { snapshot in
                let group = DispatchGroup()
                
                let enumerator = snapshot.children
                var count = 0
                var result: [User] = []
                while let snap = enumerator.nextObject() as? DataSnapshot, count < 20 {
                    guard let data = snap.value else { return }
                    do {
                        let user = try FirebaseDecoder().decode(User.self, from: data)
                        result.append(user)
                        
                        group.enter()
                        DatabaseManager.getImage(with: user.pfp, completion: { img in
                            ImageMap.map[user.pfp] = img
                            group.leave()
                        })
                                      
                    } catch let error { print("searchUsers: \(error)")}
                    count += 1
                }
                group.notify(queue: .main) {
                    completion(result)
                }
                
            }) { error in print(error.localizedDescription) }
        }
    }
    
    /// Get a list of Post objects to be presented in the feed
    static func getFeedData(with friends: [User], completion: @escaping ([Post]) -> Void) {
        let group = DispatchGroup()
        
        var posts: [Post] = []
        for friend in friends {
            group.enter()
            DatabaseManager.getOtherUserStartup(with: friend.id, completion: { _, todaysPost in
                if let todaysPost = todaysPost {
                    posts.append(todaysPost)
                }
                group.leave()
            })
        }
        
        group.notify(queue: .main) {
            completion(posts)
        }
    }
    // MARK: - Blocked
    
    /// Remove a user from this user's blocked list
    static func removeBlock(with blockID: String, userID: String, completion: @escaping (Bool) -> Void) {
        let ref = DatabaseManager.database.child("users/\(userID)/blocked")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            let enumerator = snapshot.children
            var found = false
            while let snap = enumerator.nextObject() as? DataSnapshot, !found {
                guard let data = snap.value as? String else { return }
                if data == blockID {
                    found = true
                    DatabaseManager.database.child("users/\(userID)/blocked/\(snap.key)").removeValue()
                    completion(true)
                }
            }
            if !found {
                print("Unable to remove the user from the blocked list.")
                completion(false)
            }
        }) { error in print(error.localizedDescription) }
    }
    
    /// Add a user to this user's blocked list
    static func addBlock(with block: User, userID: String, completion: @escaping (Bool, String) -> Void) {
        let ref = DatabaseManager.database.child("users/\(userID)/blocked").childByAutoId()
        ref.setValue(block.id, withCompletionBlock: { error, _ in
            guard error == nil else {
                print("Failed to add the user to the blocked list/")
                completion(false , "")
                return
            }
            completion(true, ref.key!)
        })
    }
    
    /// Get a list of User objects of the given user's blocked list
    static func getBlocked(with userID: String, completion: @escaping ([User]) -> Void) {
        DatabaseManager.database.child("users/\(userID)/blocked").observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.exists() else {
                print("getBlocked: The user does not have any users blocked.")
                completion([])
                return
            }

            guard let data = snapshot.value as? [String : String] else { return }
            let arr = data.values.map({$0}) // Contains user IDs
            var result: [User] = []
            let group = DispatchGroup()

            for userID in arr {
                group.enter()
                DatabaseManager.getOtherUserStartup(with: userID, completion: { user, _ in
                    result.append(user)
                    group.leave()
                })
            }
            group.notify(queue: .main) {
                completion(result)
            }

        }) { error in print(error.localizedDescription) }
    }
    
    // MARK: - Friends
    
    /// Remove a user from this user's friends list
    static func removeFriend(with friendID: String, userID: String, completion: @escaping (Bool) -> Void) {
        let ref = DatabaseManager.database.child("users/\(userID)/friends")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            let enumerator = snapshot.children
            var found = false
            while let snap = enumerator.nextObject() as? DataSnapshot, !found {
                guard let data = snap.value as? String else { return }
                if data == friendID {
                    found = true
                    DatabaseManager.database.child("users/\(userID)/friends/\(snap.key)").removeValue()
                    completion(true)
                }
            }
            if !found {
                print("Unable to remove the user from the friends list.")
                completion(false)
            }
        }) { error in print(error.localizedDescription) }
    }
    
    /// Add a user to this user's friends list
    static func addFriend(with friend: User, userID: String, completion: @escaping (Bool, String) -> Void) {
        let ref = DatabaseManager.database.child("users/\(userID)/friends").childByAutoId()
        ref.setValue(friend.id, withCompletionBlock: { error, _ in
            guard error == nil else {
                print("Failed to add a friend to the database.")
                completion(false , "")
                return
            }
            completion(true, ref.key!)
            UserMap.map[friend.id] = friend
        })
    }
    
    /// Get a list of User objects of the given user's friends
    static func getFriends(with user: User, completion: @escaping ([User]) -> Void) {
        DatabaseManager.database.child("users/\(user.id)/friends").observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.exists() else {
                print("getFriends: The user does not have any friends.")
                completion([])
                user.friends = nil
                return
            }
            
            guard let data = snapshot.value as? [String : String] else { return }
            user.friends = data
            let arr = data.values.map({$0}) // Contains user IDs
            var result: [User] = []
            let group = DispatchGroup()
            
            for userID in arr {
                group.enter()
                DatabaseManager.getOtherUserStartup(with: userID, completion: { user, _ in
                    result.append(user)
                    group.leave()
                })
            }
            group.notify(queue: .main) {
                completion(result)
            }
            
        }) { error in print(error.localizedDescription) }
    }
    
    // MARK: - Requests
    
    /// Remove a user from this user's request list
    static func removeRequest(with requestID: String, userID: String, completion: @escaping (Bool) -> Void) {
        let ref = DatabaseManager.database.child("users/\(userID)/requests")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            let enumerator = snapshot.children
            var found = false
            while let snap = enumerator.nextObject() as? DataSnapshot, !found {
                guard let data = snap.value as? String else { return }
                if data == requestID {
                    found = true
                    DatabaseManager.database.child("users/\(userID)/requests/\(snap.key)").removeValue()
                    completion(true)
                }
            }
            if !found {
                print("Unable to remove the user from the request list.")
                completion(false)
            }
        }) { error in print(error.localizedDescription) }
    }
    
    /// Add a user to this user's request list
    static func addRequest(with requestUser: User, userID: String, completion: @escaping (Bool, String) -> Void) {
        let ref = DatabaseManager.database.child("users/\(userID)/requests").childByAutoId()
        ref.setValue(requestUser.id, withCompletionBlock: { error, _ in
            guard error == nil else {
                print("Failed to add the user to the requests list.")
                completion(false, "")
                return
            }
            completion(true, ref.key!)
            UserMap.map[requestUser.id] = requestUser
        })
    }
        
    /// Get a list of User objects of the given user's incoming requests
    static func getRequests(with userID: String, completion: @escaping ([User]) -> Void) {
        DatabaseManager.database.child("users/\(userID)/requests").observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.exists() else {
                print("getRequests: The user does not have any incoming requests.")
                completion([])
                return
            }

            guard let data = snapshot.value as? [String : String] else { return }
            let arr = data.values.map({$0}) // Contains user IDs
            var result: [User] = []
            let group = DispatchGroup()

            for userID in arr {
                group.enter()
                DatabaseManager.getOtherUserStartup(with: userID, completion: { user, _ in
                    result.append(user)
                    group.leave()
                })
            }
            group.notify(queue: .main) {
                completion(result)
            }

        }) { error in print(error.localizedDescription) }
    }
    
    // MARK: - Image
    
    /// Get a UIImage of a given image path. Stores Image to path
    static func getImage(with filePath: String, completion: @escaping (UIImage?) -> Void) {
        StorageManager.downloadImage(with: filePath, completion: { img in
            guard let img = img else { print("Error"); return }
            ImageMap.map[filePath] = img    // Add to cache
            completion(img)
        })
    }
    
    // MARK: - User
    
    /// Change the profile picture of the user to the default
    static func setDefaultPFP(with user: User, completion: @escaping (Bool) -> Void) {
        DatabaseManager.database.child("users/\(user.id)/pfp").setValue("images/pfp/scribbly_default_pfp.png", withCompletionBlock: { error, _ in
            guard error == nil else {
                print("Unable to change the profile picture back to default.")
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    /// Change the username of the given user
    static func changeUsername(with user: User, text: String, completion: @escaping (Bool) -> Void) {
        // First, check if the username exists
        DatabaseManager.usernameExists(with: text, completion: { exists in
            if exists {
                print("Username already exists.")
                completion(false)
                return
            } else {
                // Does not exist so change it
                let group = DispatchGroup()
                
                group.enter()
                DatabaseManager.database.child("username_id_map/\(user.userName)").removeValue(completionBlock: { error, _ in
                    guard error == nil else {
                        print("Unable to remove the old username.")
                        completion(false)
                        return
                    }
                    group.leave()
                })
                
                group.enter()
                let ref = DatabaseManager.database.child("users/\(user.id)/userName")
                ref.setValue(text, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        print("Unable to change the username.")
                        completion(false)
                        return
                    }
                    user.userName = text
                    group.leave()
                })
                
                group.enter()
                DatabaseManager.database.child("username_id_map/\(text)").setValue(user.id, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        print("Unable to add the new username to the database.")
                        completion(false)
                        return
                    }
                    group.leave()
                })
                
                group.notify(queue: .main) {
                    completion(true)
                }
            }
        })
    }
    
    /// Change the bio of the given user
    static func changeBio(with user: User, text: String, completion: @escaping (Bool) -> Void) {
        let ref = DatabaseManager.database.child("users/\(user.id)/bio")
        ref.setValue(text, withCompletionBlock: { error, _ in
            guard error == nil else {
                print("Unable to change the bio.")
                completion(false)
                return
            }
            user.bio = text
            completion(true)
        })
    }
    
    /// Change the last name of the given user
    static func changeLastName(with user: User, text: String, completion: @escaping (Bool) -> Void) {
        let ref = DatabaseManager.database.child("users/\(user.id)/lastName")
        ref.setValue(text, withCompletionBlock: { error, _ in
            guard error == nil else {
                print("Unable to change the last name.")
                completion(false)
                return
            }
            user.lastName = text
            completion(true)
        })
    }
    
    /// Change the first name of the given user
    static func changeFirstName(with user: User, text: String, completion: @escaping (Bool) -> Void) {
        let ref = DatabaseManager.database.child("users/\(user.id)/firstName")
        ref.setValue(text, withCompletionBlock: { error, _ in
            guard error == nil else {
                print("Unable to change the first name.")
                completion(false)
                return
            }
            user.firstName = text
            completion(true)
        })
    }
    
    /// Load the given user's old posts into cache
    static func loadOldPosts(with userID: String, completion: @escaping (Bool) -> Void) {
        let group = DispatchGroup()
        
        let ref = DatabaseManager.database.child("users/\(userID)/posts")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.exists() else {
                completion(true)
                return
            }
            
            let enumerator = snapshot.children
            while let snap = enumerator.nextObject() as? DataSnapshot {
                guard let data = snap.value as? String else { return }
                group.enter()
                DatabaseManager.getPost(with: data, completion: { _ in
                    group.leave()
                })
            }
            
            group.notify(queue: .main) {
                completion(true)
            }
            
        }) { error in print(error.localizedDescription) }
    }
    
    /// Get a User object and their Post for today. Stores user, profile picture, and today's post to cache.
    static func getOtherUserStartup(with userID: String, completion: @escaping (User, Post?) -> Void) {
        DatabaseManager.database.child("users/\(userID)").observeSingleEvent(of: .value, with: { snapshot in
            guard let data = snapshot.value else { return }
            do {
                let user = try FirebaseDecoder().decode(User.self, from: data)
                UserMap.map[user.id] = user // add to cache
                
                DatabaseManager.getImage(with: user.pfp, completion: { img in
                    ImageMap.map[user.pfp] = img  // add to cache
                    
                    // Only load today's post
                    if user.todaysPost != "" {
                        DatabaseManager.getPost(with: user.todaysPost, completion: { post in
                            completion(user, post)
                        })
                    } else {
                        completion(user, nil)
                    }
                })
                
            } catch let error { print("getOtherUserStartup: \(error)") }
        }) { error in print(error.localizedDescription) }
    }
    
    /// Get a User object for the currently logged-in user and a list of post objects to be displayed in the feed.
    static func getStartup(completion: @escaping (User?, [Post]) -> Void) {
        let group = DispatchGroup()
        
        guard let authUser = Auth.auth().currentUser else { return }
        
        DatabaseManager.database.child("users/\(authUser.uid)").observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.exists() else {
                // User does not exist yet, then return: nil, []
                print("User has not been created yet.")
                completion(nil, [])
                return
            }
            
            guard let data = snapshot.value else { return }
            do {
                let user = try FirebaseDecoder().decode(User.self, from: data)
                UserMap.map[user.id] = user     // Add to cache
                
                // Add PFP
                group.enter()
                StorageManager.downloadImage(with: user.pfp, completion: { img in
                    guard let img = img else { print("Error"); return }
                    ImageMap.map[user.pfp] = img    // Add to cache
                    group.leave()
                })
                
                // Add user's post for today in cache
                if user.todaysPost != "" {
                    group.enter()
                    DatabaseManager.getPost(with: user.todaysPost, completion: { _ in
                        group.leave()
                    })
                }
                
                // Add mainUser's friends and their posts to cache
                var accum: [Post] = []
                if let friends = user.friends {
                    for friend in friends.values.map({$0}) {
                        group.enter()
                        DatabaseManager.getOtherUserStartup(with: friend, completion: { _, post in
                            if let post = post {
                                accum.append(post)
                            }
                            group.leave()
                        })
                    }
                }
                
                group.notify(queue: .main) {
                    completion(user, accum)
                }
                
            } catch let error { print("getMainUserStartup: \(error)") }
            
        }) { error in print(error.localizedDescription) }
    }
}

// MARK: - Post Management
extension DatabaseManager {
    // MARK: - Hiding
    
    /// Hide/unhide a post
    static func hidePost(with postID: String, hide: Bool, completion: @escaping (Bool) -> Void) {
        let ref = DatabaseManager.database.child("posts/\(postID)/hidden")
        ref.setValue(hide, withCompletionBlock: { error, _ in
            guard error == nil else {
                print("Unable to hide/unhide the post.")
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    // MARK: - Replies
    
    /// Remove a reply from a comment or another reply
    static func removeReply(with reply: Reply, comment: Comment, key: String, completion: @escaping (Bool, String) -> Void) {
        let ref = DatabaseManager.database.child("posts/\(comment.post)/comments/\(key)/replies")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            let enumerator = snapshot.children
            var found = false
            while let snap = enumerator.nextObject() as? DataSnapshot, !found {
                guard let data = snap.value else { return }
                
                do {
                    let rep = try FirebaseDecoder().decode(Reply.self, from: data)
                    if rep.id == reply.id {
                        found = true
                        DatabaseManager.database.child("posts/\(comment.post)/comments/\(key)/replies/\(snap.key)").removeValue()
                        completion(true, snap.key)
                    }
                } catch let error { print("removeReply: \(error)")}
            }
            if !found {
                print("Unable to remove the reply.")
                completion(false, "")
            }
        }) { error in print(error.localizedDescription) }
    }
    
    /// Add a reply to a comment.
    static func addReply(with reply: Reply, comment: Comment, key: String, completion: @escaping (Bool, String) -> Void) {
        let ref = DatabaseManager.database.child("posts/\(comment.post)/comments/\(key)/replies").childByAutoId()
        ref.setValue([
            "id" : reply.id,
            "prevReply" : reply.prevReply,
            "user" : reply.user,
            "text" : reply.text,
            "time" : reply.time
        ], withCompletionBlock: { error, _ in
            guard error == nil else {
                print("Failed to reply to the comment.")
                completion(false, "")
                return
            }
            completion(true, ref.key!)
        })
    }
    
    // MARK: - Comments
    
    /// Get a list of Comment objects of the given post
    static func getComments(with postID: String, completion: @escaping ([String:Comment]) -> Void) {
        DatabaseManager.database.child("posts/\(postID)/comments").observeSingleEvent(of: .value, with: { snapshot in
            var dict: [String:Comment] = [:]
            let enumerator = snapshot.children
            let group = DispatchGroup()
            while let snap = enumerator.nextObject() as? DataSnapshot {
                guard let data = snap.value else { return }
                do {
                    let cmt = try FirebaseDecoder().decode(Comment.self, from: data)
                    dict[snap.key] = cmt
                    
                    // Add the comment users
                    group.enter()
                    DatabaseManager.getOtherUserStartup(with: cmt.user, completion: { _, _ in
                        group.leave()
                    })
                    
                    // Add the reply users
                    if let replies = cmt.replies?.values.map({$0}) {
                        for i in replies {
                            group.enter()
                            DatabaseManager.getOtherUserStartup(with: i.user, completion: { _, _ in
                                group.leave()
                            })
                        }
                    }
                    
                } catch let error { print("getComments: \(error)") }
            }
            group.notify(queue: .main) {
                completion(dict)
            }
            
        }) { error in print(error.localizedDescription) }
    }
    
    /// Remove a comment from a post.
    static func removeComment(with comment: Comment, completion: @escaping (Bool, String) -> Void) {
        let ref = DatabaseManager.database.child("posts/\(comment.post)/comments")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            let enumerator = snapshot.children
            var found = false
            while let snap = enumerator.nextObject() as? DataSnapshot, !found {
                guard let data = snap.value else { return }
                
                do {
                    let cmt = try FirebaseDecoder().decode(Comment.self, from: data)
                    if cmt.id == comment.id {
                        found = true
                        DatabaseManager.database.child("posts/\(comment.post)/comments/\(snap.key)").removeValue()
                        completion(true, snap.key)
                    }
                } catch let error { print("removeComment: \(error)")}
            }
            if !found {
                print("Unable to remove the comment.")
                completion(false, "")
            }
        }) { error in print(error.localizedDescription) }
    }
    
    /// Add a comment to a post.
    static func addComment(with comment: Comment, completion: @escaping (Bool, String) -> Void) {
        let ref = DatabaseManager.database.child("posts/\(comment.post)/comments").childByAutoId()
        ref.setValue([
            "id" : comment.id,
            "post" : comment.post,
            "user" : comment.user,
            "text" : comment.text,
            "time" : comment.time
        ], withCompletionBlock: { error, _ in
            guard error == nil else {
                print("Failed to comment on the post.")
                completion(false, "")
                return
            }
            completion(true, ref.key!)
        })
    }
    
    // MARK: - Bookmarks
    
    /// Remove a post from the given user's bookmarks
    static func removeBookmarkedPost(with postID: String, userID: String, completion: @escaping (Bool) -> Void) {
        let ref = DatabaseManager.database.child("users/\(userID)/bookmarkedPosts")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            let enumerator = snapshot.children
            var found = false
            while let snap = enumerator.nextObject() as? DataSnapshot, !found {
                guard let data = snap.value as? String else { return }
                if data == postID {
                    found = true
                    DatabaseManager.database.child("users/\(userID)/bookmarkedPosts/\(snap.key)").removeValue()
                    completion(true)
                }
            }
            if !found {
                print("Unable to remove the post from the user's bookmarks.")
                completion(false)
            }
        }) { error in print(error.localizedDescription) }
    }
    
    /// Remove a user from the given post's bookmarkedUsers and from the user's bookmarks
    static func removeBookmarkedUser(with userID: String, postID: String, completion: @escaping (Bool) -> Void) {        
        let postRef = DatabaseManager.database.child("posts/\(postID)/bookmarkedUsers")
        postRef.observeSingleEvent(of: .value, with: { snapshot in
            let enumerator = snapshot.children
            var found = false
            while let snap = enumerator.nextObject() as? DataSnapshot, !found {
                guard let data = snap.value as? String else { return }
                if data == userID {
                    found = true
                    DatabaseManager.database.child("posts/\(postID)/bookmarkedUsers/\(snap.key)").removeValue()
                    completion(true)
                }
            }
            if !found {
                print("Unable to remove the user from the post's bookmarked users.")
                completion(false)
            }
        }) { error in print(error.localizedDescription) }
    }
    
    /// Add a post to the given user's bookmarkedPosts
    static func addBookmarkedPost(with postID: String, userID: String, completion: @escaping (Bool, String) -> Void) {
        let ref = DatabaseManager.database.child("users/\(userID)/bookmarkedPosts").childByAutoId()
        ref.setValue(postID, withCompletionBlock: { error, _ in
            guard error == nil else {
                print("Failed to add the post to the user's bookmarks.")
                completion(false, "")
                return
            }
            completion(true, ref.key!)
        })
    }
    
    /// Add a user to the given post's bookmarkedUsers
    static func addBookmarkedUser(with userID: String, postID: String, completion: @escaping (Bool, String) -> Void) {
        let ref = DatabaseManager.database.child("posts/\(postID)/bookmarkedUsers").childByAutoId()
        ref.setValue(userID, withCompletionBlock: { error, _ in
            guard error == nil else {
                print("Failed to add the user the post's bookmarked users.")
                completion(false, "")
                return
            }
            completion(true, ref.key!)
        })
    }
    
    // MARK: - Likes
    
    /// Remove a user from the given post's likedUsers
    static func unlikePost(with userID: String, postID: String, completion: @escaping (Bool) -> Void) {
        let ref = DatabaseManager.database.child("posts/\(postID)/likedUsers")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            let enumerator = snapshot.children
            var found = false
            while let snap = enumerator.nextObject() as? DataSnapshot, !found {
                guard let data = snap.value as? String else { return }
                if data == userID {
                    found = true
                    DatabaseManager.database.child("posts/\(postID)/likedUsers/\(snap.key)").removeValue()
                    completion(true)
                }
            }
            if !found {
                print("Unable to dislike the post.")
                completion(false)
            }
        }) { error in print(error.localizedDescription) }
    }
    
    /// Add a user to the given post's likedUsers
    static func likePost(with userID: String, postID: String, completion: @escaping (Bool, String) -> Void) {
        let ref = DatabaseManager.database.child("posts/\(postID)/likedUsers").childByAutoId()
        ref.setValue(userID, withCompletionBlock: { error, _ in
            guard error == nil else {
                print("Failed to like the post.")
                completion(false, "")
                return
            }
            completion(true, ref.key!)
        })
    }
    
    // MARK: - Post
    
    /// Deletes the user's post
    static func deletePost(with post: Post, userID: String, completion: @escaping (Bool) -> Void) {
        let group = DispatchGroup()
        
        // Delete from todaysPost if it is from today
        let format = DateFormatter()
        format.dateFormat = "d MMMM yyyy HH:mm:ss"
        format.timeZone = TimeZone(abbreviation: "UTC")
        
        if Calendar.current.isDateInToday(format.date(from: post.time)!) {
            group.enter()
            DatabaseManager.database.child("users/\(userID)/todaysPost").setValue("", withCompletionBlock: { error, _ in
                guard error == nil else {
                    print("Unable to remove today's post")
                    completion(false)
                    return
                }
                group.leave()
            })
        }
        
        // Delete from users/posts
        group.enter()
        DatabaseManager.database.child("users/\(userID)/posts/").observeSingleEvent(of: .value, with: { snapshot in
            let enumerator = snapshot.children
            var found = false
            while let snap = enumerator.nextObject() as? DataSnapshot, !found {
                guard let data = snap.value as? String else { return }
                if data == post.id {
                    found = true
                    DatabaseManager.database.child("users/\(userID)/posts/\(snap.key)").removeValue()
                }
            }
            if !found {
                print("Unable to remove the post from the users/\(userID)/posts")
                completion(false)
            }
            group.leave()
        }) { error in print(error.localizedDescription) }
        
        // Delete from posts/
        group.enter()
        DatabaseManager.database.child("posts/\(post.id)").removeValue(completionBlock: { error, _ in
            guard error == nil else {
                print("Unable to remove the post from posts/")
                completion(false)
                return
            }
            group.leave()
        })
        
        // Delete from storage
        group.enter()
        StorageManager.removeImage(with: post.drawing, completion: { success in
            if !success {
                print("Unable to remove the image from storage.")
                completion(false)
                return
            }
            group.leave()
        })
        
        group.notify(queue: .main) {
            completion(true)
        }
    }
    
    /// Update the stats for the given Post
    static func updatePostStats(with post: Post, completion: @escaping (Bool) -> Void) {
        let group = DispatchGroup()
        let ref = DatabaseManager.database.child("posts/\(post.id)")
        
        // Update likes
        group.enter()
        ref.child("likedUsers").observeSingleEvent(of: .value, with: { snapshot in
            post.likedUsers = nil
            guard let data = snapshot.value as? [String:String] else { return }
            post.likedUsers = data
            group.leave()
        }) { error in print(error.localizedDescription); completion(false) }
        
        // Update bookmarks
        group.enter()
        ref.child("bookmarkedUsers").observeSingleEvent(of: .value, with: { snapshot in
            post.bookmarkedUsers = nil
            guard let data = snapshot.value as? [String:String] else { return }
            post.bookmarkedUsers = data
            group.leave()
        }) { error in print(error.localizedDescription); completion(false) }
        
        // Update comments
        group.enter()
        ref.child("comments").observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                var dict: [String:Comment] = [:]
                let enumerator = snapshot.children
                while let snap = enumerator.nextObject() as? DataSnapshot {
                    guard let data = snap.value else { return }
                    do {
                        let cmt = try FirebaseDecoder().decode(Comment.self, from: data)
                        dict[snap.key] = cmt
                    } catch let error { print("updatePost: \(error)"); completion(false) }
                }
                post.comments = dict
                group.leave()
            } else {
                post.comments = nil
                group.leave()
            }
        }) { error in print(error.localizedDescription); completion(false) }
                                                 
        // Finished
        group.notify(queue: .main) {
            completion(true)
        }
    }
    
    /// Get a Post object corresponding to the given id. Stores post, post drawing, comments, and replies in cache.
    static func getPost(with postID: String, completion: @escaping (Post) -> Void) {
        DatabaseManager.database.child("posts/\(postID)").observeSingleEvent(of: .value, with: { snapshot in
            guard let data = snapshot.value else { return }
            
            do {
                let post = try FirebaseDecoder().decode(Post.self, from: data)
                PostMap.map[post.id] = post     // Add to cache
                
                StorageManager.downloadImage(with: post.drawing, completion: { img in
                    ImageMap.map[post.drawing] = img
                    completion(post)
                })
                
            } catch let error { print("getPost: \(error)")}
        }) { error in print(error.localizedDescription) }
    }
    
    /// Add a post to the database. Stores post in cache.
    static func addPost(with post: Post, userID: String, completion: @escaping (Bool, String) -> Void) {
        DatabaseManager.database.child("posts/\(post.id)").setValue([
            "id" : post.id,
            "drawing" : post.drawing,
            "hidden" : post.hidden,
            "caption" : post.caption,
            "time" : post.time,
            "user" : userID
        ], withCompletionBlock: { error, _ in
            guard error == nil else {
                print("Failed to add a post to the database (posts path).")
                completion(false, "")
                return
            }
            let ref = DatabaseManager.database.child("users/\(userID)/posts").childByAutoId()
            ref.setValue(post.id, withCompletionBlock: { error, _ in
                guard error == nil else {
                    print("Failed to add a post to the database (users path).")
                    completion(false, "")
                    return
                }
                DatabaseManager.database.child("users/\(userID)/todaysPost").setValue(post.id, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        print("Failed to add to the user's todaysPost.")
                        completion(false, "")
                        return
                    }
                    completion(true, ref.key!)
                    PostMap.map[post.id] = post     // Add to cache
                })
            })
        })
    }
}

// MARK: - Account Management
extension DatabaseManager {
    /// Add a new user to the database
    static func addUser(with user: User, completion: @escaping (Bool) -> Void) {
        let data = try! FirebaseEncoder().encode(user)
        // Add to path: /users/
        DatabaseManager.database.child("/users/\(user.id)").setValue(data, withCompletionBlock: { error, _ in
            guard error == nil else {
                print("Failed to write to users/")
                completion(false)
                return
            }
            // Add to path: /username_id_map
            DatabaseManager.database.child("username_id_map/\(user.userName)").setValue(user.id, withCompletionBlock: { error, _ in
                guard error == nil else {
                    print("Failed to write to username_id_map/")
                    completion(false)
                    return
                }
                AuthManager.currentPhoneNum(completion: { number in
                    // Add to path: /phone_id_map
                    if number != nil {
                        DatabaseManager.database.child("phone_id_map/\(number!)").setValue(user.id, withCompletionBlock: { error, _ in
                            guard error == nil else {
                                print("Failed to write to phone_id_map/")
                                completion(false)
                                return
                            }
                            UserMap.map[user.id] = user     // Add to cache
                            completion(true)
                        })
                    }
                })
            })
        })
    }
    
    /// Checks if there is already a user with that username
    static func usernameExists(with username: String, completion: @escaping (Bool) -> Void) {
        DatabaseManager.database.child("username_id_map/\(username)").observeSingleEvent(of: .value, with: { snapshot in
            guard (snapshot.value as? String) == nil else {
                print("Username already exists.")
                completion(true)
                return
            }
            completion(false)
            
        }) { error in print(error.localizedDescription) }
    }
    
    /// Checks if there is already a user with that email address
    static func emailExists(with email: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().fetchSignInMethods(forEmail: email, completion: { emails, error in
            if let error = error {
                print(error.localizedDescription)
            } else if emails != nil {
                print("Email already exists")
                completion(true)
            } else {
                completion(false)
            }
        })
    }
}
