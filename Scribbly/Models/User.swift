//
//  User.swift
//  Scribbly
//
//  Created by Vin Bui on 12/18/22.
//
import UIKit

class User {
    
    // ------------ Fields ------------
    private let account_start: Date
    
    private var pfp: UIImage
    private var full_name: String
    private var user_name: String
    private var bio: String
    private var posts: [Post]
    private var bookmarked_posts: [Post]
    
    // ------------ Helpers ------------
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
        let components = calendar.dateComponents(Set([.month]), from: account_start, to: Date())

        var allDates: [String] = []
        let dateRangeFormatter = DateFormatter()
        dateRangeFormatter.dateFormat = "MMMM yyyy"

        for i in 0 ... components.month! {
            guard let date = calendar.date(byAdding: .month, value: i, to: account_start) else {
            continue
            }

            let formattedDate = dateRangeFormatter.string(from: date)
            allDates += [formattedDate]
        }
        allDates.reverse()
        return allDates
    }
    
    func isBookmarked(post: Post) -> Bool {
        for i in bookmarked_posts {
            if i === post {
                return true
            }
        }
        return false
    }
    
    // ------------ Getters/Setters ------------    
    func getBio() -> String {
        return bio
    }
    
    func getFullName() -> String {
        return full_name
    }
    
    func removeBookmarkPost(post: Post) {
        if let index = bookmarked_posts.firstIndex(where: {$0 === post}) {
            bookmarked_posts.remove(at: index)
        }
    }
    
    func addBookmarkPost(post: Post) {
        bookmarked_posts.append(post)
    }
    
    func getPFP() -> UIImage {
        return pfp
    }
    
    func getUserName() -> String {
        return user_name
    }
    
    func getPosts() -> [Post] {
        return posts
    }
    
    func getLatestPost() -> Post {
        // TODO: maybe only return if it matches today's date?
        return posts[posts.count - 1]
    }
    
    func addPost(post: Post) {
        posts.append(post)
    }
    
    // ------------ Initializer ------------
    init(pfp: UIImage, full_name: String, user_name: String, bio: String, account_start: Date) {
        self.pfp = pfp
        self.full_name = full_name
        self.user_name = user_name
        self.bio = bio
        self.posts = []
        self.bookmarked_posts = []
        self.account_start = account_start
    }
}
