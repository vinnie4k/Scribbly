//
//  User.swift
//  Scribbly
//
//  Created by Vin Bui on 12/18/22.
//

// TODO: ALREADY REFACTORED

import UIKit

// MARK: User Model Class
class User: Codable, Equatable, Identifiable {
    // MARK: - Properties
    var id: String
    var userName: String
    var firstName: String
    var lastName: String
    var pfp: String         // URL
    var accountStart: String // format: d MMM yyyy HH:mm:ss Z (ex: 5 Jan 2023 03:24:00 -0600)
    
    var bio: String
    var friends: [String : String]?
    var requests: [String : String]?
    var blocked: [String : String]?
    var posts: [String : String]?
    var bookmarkedPosts: [String : String]?
    
    var todaysPost: String          // Post ID
    
    // MARK: - Equatable
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    // MARK: - Helper Functions
    func removeBookmarksFromUser(user: User) {
        let posts = getBookmarksFromUser(user: user)
        for post in posts {
            removeBookmarkPost(post: post)
            post.removeBookmarkUser(user: self)
        }
    }
    
    func getBookmarksFromUser(user: User) -> [Post] {
        if bookmarkedPosts == nil { return [] }
        var result: [Post] = []
        for postID in bookmarkedPosts!.values.map({$0}) {
            let post = PostMap.map[postID]
            if post?.user == user.id {
                result.append(post!)
            }
        }
        
        let format = DateFormatter()
        format.dateFormat = "d MMMM yyyy HH:mm:ss"
        format.timeZone = TimeZone(identifier: "America/New_York")
        
        return result.sorted(by: {
            format.date(from: $0.time)!.compare(format.date(from: $1.time)!) == .orderedDescending
        })
    }
    
    func isBlocked(user: User) -> Bool {
        if let blocked = blocked {
            for userID in blocked.values.map({$0}) {
                if userID == user.id {
                    return true
                }
            }
        }
        return false
    }
    
    func hasRequested(user: User) -> Bool {
        if let requests = requests {
            for userID in requests.values.map({$0}) {
                if userID == user.id {
                    return true
                }
            }
        }
        return false
    }
    
    func isFriendsWith(user: User) -> Bool {
        if let friends = friends {
            for userID in friends.values.map({$0}) {
                if userID == user.id {
                    return true
                }
            }
        }
        return false
    }
    
    func updateFeed() -> [Post] {
        var result = [Post]()
        if let friends = friends {
            for userID in friends.values.map({$0}) {
                let user = UserMap.map[userID]!
                result.append(user.getTodaysPost()!)
            }
        }
        return result
    }
    
    func getPostFromDate(selected_date: Date) -> Post? {
        guard let posts = posts else { return nil }
        //        let arr = Array(posts.values.map({$0}))
        
        let arr = posts.values.map({$0})
        for postID in arr {
            if let post = PostMap.map[postID] {
                if (Calendar.current.isDate(post.getTime(), inSameDayAs: selected_date)) {
                    return post
                }
            }
        }
        return nil
    }
    
    /**
     Returns a list of the months from the start date to today's date in reverse order
     For example, if today is December 2022 and the start date is October 2022, monthsFromStart()
     returns ["December 2022", "November 2022", "October 2022"]
     */
    func monthsFromStart() -> [String] {
        let format = DateFormatter()
        format.dateFormat = "d MMMM yyyy HH:mm:ss"
        let accountStart = format.date(from: accountStart)!
        
        let calendar = Calendar(identifier: .gregorian)
        let firstOfMonth = CalendarHelper().firstOfMonth(date: accountStart)
        
        let components = calendar.dateComponents(Set([.month]), from: firstOfMonth, to: Date())
        
        var allDates: [String] = []
        let dateRangeFormatter = DateFormatter()
        dateRangeFormatter.dateFormat = "MMMM yyyy"
        
        for i in 0 ... components.month! {
            guard let date = calendar.date(byAdding: .month, value: i, to: firstOfMonth) else {
                continue
            }
            
            let formattedDate = dateRangeFormatter.string(from: date)
            allDates += [formattedDate]
        }
        allDates.reverse()
        return allDates
    }
    
    func isBookmarked(post: Post) -> Bool {
        if let bookmarkedPosts = bookmarkedPosts {
            for postID in bookmarkedPosts.values.map({$0}) {
                if postID == post.id {
                    return true
                }
            }
        }
        return false
    }
    
    // MARK: - Getters and Setters
    func unblockUser(user: User) {
        DatabaseManager.removeBlock(with: user.id, userID: self.id, completion: { [weak self] success in
            guard let `self` = self else { return }
            if success {
                if let keys = self.blocked?.allKeys(forValue: user.id) {
                    self.blocked?.removeValue(forKey: keys[0])
                }
            }
        })
    }
    
    func blockUser(user: User) {
        if blocked == nil {
            blocked = [:]
        }
        
        DatabaseManager.addBlock(with: user, userID: self.id, completion: { [weak self] success, key in
            guard let `self` = self else { return }
            if success {
                self.blocked![key] = user.id
            }
        })
        
        user.removeFriend(user: self)
        self.removeFriend(user: user)
        user.removeRequest(user: self)
        self.removeRequest(user: user)
        
        removeBookmarksFromUser(user: user)
    }
    
    func removeRequest(user: User) {
        DatabaseManager.removeRequest(with: user.id, userID: self.id, completion: { [weak self] success in
            guard let `self` = self else { return }
            if success {
                if let keys = self.requests?.allKeys(forValue: user.id) {
                    self.requests?.removeValue(forKey: keys[0])
                }
            }
        })
    }
    
    func removeFriend(user: User) {
        DatabaseManager.removeFriend(with: user.id, userID: self.id, completion: { [weak self] success in
            guard let `self` = self else { return }
            if success {
                if let keys = self.friends?.allKeys(forValue: user.id) {
                    self.friends?.removeValue(forKey: keys[0])
                }
            }
        })
    }
    
    func addRequest(user: User) {
        if requests == nil {
            requests = [:]
        }
        
        DatabaseManager.addRequest(with: user, userID: self.id, completion: { [weak self] success, key in
            guard let `self` = self else { return }
            if success {
                self.requests![key] = user.id
            }
        })
    }
    
    func getRequests() -> [User] {
        if requests == nil { return [] }
        
        var accum: [User] = []
        for userID in requests!.values.map({$0}) {
            accum.append(UserMap.map[userID]!)
        }
        return accum
    }
    
    func setPFP(image: String) {
        pfp = image
    }
    
    func getLastName() -> String {
        return lastName
    }
    
    func getFirstName() -> String {
        return firstName
    }
    
    func addFriend(friend: User) {
        if friends == nil {
            friends = [:]
        }
        DatabaseManager.addFriend(with: friend, userID: self.id, completion: { [weak self] success, key in
            guard let `self` = self else { return }
            if success {
                self.friends![key] = friend.id
            }
        })
    }
    
    func getFriends() -> [User] {
        if friends == nil { return [] }
        
        var accum: [User] = []
        for userID in friends!.values.map({$0}) {
            accum.append(UserMap.map[userID]!)
        }
        return accum
    }
    
    func getBio() -> String {
        return bio
    }
    
    func getFullName() -> String {
        return firstName + " " + lastName
    }
    
    func getBlocked() -> [User] {
        if blocked == nil { return [] }
        var accum: [User] = []
        for userID in blocked!.values.map({$0}) {
            accum.append(UserMap.map[userID]!)
        }
        return accum
    }

    func getBookmarks() -> [Post] {
        if bookmarkedPosts == nil { return [] }
        var accum: [Post] = []
        for postID in bookmarkedPosts!.values.map({$0}) {
            accum.append(PostMap.map[postID]!)
        }
        
        let format = DateFormatter()
        format.dateFormat = "d MMMM yyyy HH:mm:ss"
        format.timeZone = TimeZone(identifier: "America/New_York")
        
        return accum.sorted(by: {
            format.date(from: $0.time)!.compare(format.date(from: $1.time)!) == .orderedDescending
        })

    }

    func removeBookmarkPost(post: Post) {
        DatabaseManager.removeBookmarkedPost(with: post.id, userID: self.id, completion: { [weak self] success in
            guard let `self` = self else { return }
            if success {
                if let keys = self.bookmarkedPosts?.allKeys(forValue: post.id) {
                    self.bookmarkedPosts?.removeValue(forKey: keys[0])
                }
            }
        })
    }

    func addBookmarkPost(post: Post) {
        if bookmarkedPosts == nil {
            bookmarkedPosts = [:]
        }
        
        DatabaseManager.addBookmarkedPost(with: post.id, userID: self.id, completion: { [weak self] success, key in
            guard let `self` = self else { return }
            if success {
                self.bookmarkedPosts![key] = post.id
            }
        })
    }

    func getPFP() -> UIImage {
        return ImageMap.map[pfp]!
    }

    func getUserName() -> String {
        return userName
    }

    func getPosts() -> [Post] {
        if posts == nil { return [] }
        var accum: [Post] = []
        
        let posts = posts?.values.map({$0})
        
        for postID in posts! {
            accum.append(PostMap.map[postID]!)
        }
        return accum
    }

    func getTodaysPost() -> Post? {
        return PostMap.map[todaysPost]
    }

    func addPost(key: String, post: Post) {
        if posts == nil {
            posts = [:]
        }
        posts![key] = post.id
    }

    // MARK: - init and addToCache
    init(id: String, userName: String, firstName: String, lastName: String, pfp: String, accountStart: String, bio: String, friends: [String:String]?, requests: [String:String]?, blocked: [String:String]?, posts: [String:String]?, bookmarkedPosts: [String:String]?, todaysPost: String) {
        self.id = id
        self.userName = userName
        self.firstName = firstName
        self.lastName = lastName
        self.pfp = pfp
        self.accountStart = accountStart
        self.bio = bio
        self.friends = friends
        self.requests = requests
        self.blocked = blocked
        self.posts = posts
        self.bookmarkedPosts = bookmarkedPosts
        self.todaysPost = todaysPost
    }

}
