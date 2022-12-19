//
//  Post.swift
//  Scribbly
//
//  Created by Vin Bui on 12/18/22.
//

import UIKit

class Post {
    
    // ------------ Fields ------------
    private var user: User
    private var drawing: UIImage
    private var caption: String
    private var likes: Int
    private var time: Date
    // TODO: add a field for an array of Comment objects
    
    // ------------ Getters/Setters ------------
    func getUser() -> User {
        return user
    }
    
    func getDrawing() -> UIImage {
        return drawing
    }
    
    func getCaption() -> String {
        return caption
    }
    
    init(user: User, drawing: UIImage, caption: String, likes: Int, time: Date) {
        self.user = user
        self.drawing = drawing
        self.caption = caption
        self.likes = likes
        self.time = time
    }
}
