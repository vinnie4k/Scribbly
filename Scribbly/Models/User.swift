//
//  User.swift
//  Scribbly
//
//  Created by Vin Bui on 12/18/22.
//

// TODO: ALREADY REFACTORED

import UIKit

// MARK: User Model Class
class User {
    // MARK: - Properties
    private let accountStart: Date
    private var friends: [User]
    private var requests: [User]
    private var blocked: [User]
    
    private var pfp: UIImage
    private var firstName: String
    private var lastName: String
    private var fullName: String
    private var userName: String
    private var bio: String
    private var email: String
    private var posts: [Post]
    private var bookmarkedPosts: [Post]
    
    // MARK: - Helper Functions
    func removeBookmarksFromUser(user: User) {
        bookmarkedPosts = bookmarkedPosts.filter{ $0.getUser() !== user }
    }
    
    func getBookmarksFromUser(user: User) -> [Post] {
        var result: [Post] = []
        for post in bookmarkedPosts {
            if post.getUser() === user {
                result.insert(post, at: 0)
            }
        }
        return result
    }
    
    func isBlocked(user: User) -> Bool {
        for i in blocked {
            if i === user {
                return true
            }
        }
        return false
    }
    
    func hasRequested(user: User) -> Bool {
        for i in user.getRequests() {
            if i === self {
                return true
            }
        }
        return false
    }
    
    func isFriendsWith(user: User) -> Bool {
        for i in friends {
            if i === user {
                return true
            }
        }
        return false
    }
    
    func unsendRequest(user: User) {
        user.removeRequest(user: self)
    }
    
    func acceptRequest(user: User) {
        var found = false
        for i in 0..<requests.count {
            if !found && requests[i] === user {
                friends.append(user)
                requests.remove(at: i)
                user.addFriend(friend: self)
                found = true
            }
        }
    }
    
    func sendRequest(user: User) {
        user.addRequest(user: self)
    }
    
    func defaultPFP() {
        pfp = UIImage(systemName: "person.circle.fill")!.withTintColor(UIColor.gray, renderingMode: .alwaysOriginal)
    }
    
    func updateFeed() -> [Post] {
        var result = [Post]()
        for i in friends {
            result.append(i.getTodaysPost())
        }
        return result
    }
    
    func getPostFromDate(selected_date: Date) -> Post? {
        for i in posts {
            if (Calendar.current.isDate(i.getTime(), inSameDayAs: selected_date)) {
                return i
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
        for i in bookmarkedPosts {
            if i === post {
                return true
            }
        }
        return false
    }
    
    // MARK: - Getters and Setters
    func unblockUser(user: User) {
        var found = false
        for i in 0..<blocked.count {
            if !found && blocked[i] === user {
                blocked.remove(at: i)
                found = true
            }
        }
    }
    
    func blockUser(user: User) {
        blocked.insert(user, at: 0)
        removeBookmarksFromUser(user: user)
        if isFriendsWith(user: user) {
            removeFriend(user: user)
        }
        if hasRequested(user: user) {
            unsendRequest(user: user)
        }
    }
    
    func removeRequest(user: User) {
        var found = false
        for i in 0..<requests.count {
            if !found && requests[i] === user {
                requests.remove(at: i)
                found = true
            }
        }
    }
    
    func removeFriend(user: User) {
        var found = false
        for i in 0..<friends.count {
            if !found && friends[i] === user {
                friends.remove(at: i)
                user.removeFriend(user: self)
                found = true
            }
        }
    }
    
    func addRequest(user: User) {
        requests.append(user)
    }
    
    func getRequests() -> [User] {
        return requests
    }
    
    func setBio(text: String) {
        bio = text
    }
    
    func setEmail(text: String) {
        email = text
    }
    
    func setUserName(name: String) {
        userName = name
    }
    
    func updateFullName() {
        fullName = firstName + " " + lastName
    }
    
    func setFirstName(name: String) {
        firstName = name
    }
    
    func setLastName(name: String) {
        lastName = name
    }
    
    func setPFP(image: UIImage) {
        pfp = image
    }
    
    func getEmail() -> String {
        return email
    }
    
    func getLastName() -> String {
        return lastName
    }
    
    func getFirstName() -> String {
        return firstName
    }
    
    func addFriend(friend: User) {
        friends.append(friend)
    }
    
    func getFriends() -> [User] {
        return friends
    }
    
    func getBio() -> String {
        return bio
    }
    
    func getFullName() -> String {
        return fullName
    }
    
    func getBookmarks() -> [Post] {
        return bookmarkedPosts
    }
    
    func removeBookmarkPost(post: Post) {
        if let index = bookmarkedPosts.firstIndex(where: {$0 === post}) {
            bookmarkedPosts.remove(at: index)
        }
    }
    
    func addBookmarkPost(post: Post) {
        bookmarkedPosts.append(post)
    }
    
    func getPFP() -> UIImage {
        return pfp
    }
    
    func getUserName() -> String {
        return userName
    }
    
    func getPosts() -> [Post] {
        return posts
    }
    
    func getTodaysPost() -> Post {
        // TODO: maybe only return if it matches today's date?
        return posts[posts.count - 1]
    }
    
    func addPost(post: Post) {
        posts.append(post)
    }
    
    // MARK: - init
    init(pfp: UIImage, firstName: String, lastName: String, userName: String, bio: String, email: String, accountStart: Date) {
        self.pfp = pfp
        self.firstName = firstName
        self.lastName = lastName
        self.fullName = firstName + " " + lastName
        self.userName = userName
        self.bio = bio
        self.email = email
        self.posts = []
        self.bookmarkedPosts = []
        self.accountStart = accountStart
        self.friends = []
        self.requests = []
        self.blocked = []
    }
}
