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
    
    private var pfp: UIImage
    private var fullName: String
    private var userName: String
    private var bio: String
    private var posts: [Post]
    private var bookmarkedPosts: [Post]
    
    // MARK: - Helper Functions
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
        let components = calendar.dateComponents(Set([.month]), from: accountStart, to: Date())

        var allDates: [String] = []
        let dateRangeFormatter = DateFormatter()
        dateRangeFormatter.dateFormat = "MMMM yyyy"

        for i in 0 ... components.month! {
            guard let date = calendar.date(byAdding: .month, value: i, to: accountStart) else {
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
    init(pfp: UIImage, fullName: String, userName: String, bio: String, accountStart: Date) {
        self.pfp = pfp
        self.fullName = fullName
        self.userName = userName
        self.bio = bio
        self.posts = []
        self.bookmarkedPosts = []
        self.accountStart = accountStart
        self.friends = []
    }
}
