//
//  StorageManager.swift
//  Scribbly
//
//  Created by Vin Bui on 1/3/23.
//

import Foundation
import FirebaseStorage
import UIKit

final class StorageManager {
    
    static private let cache = NSCache<NSString, UIImage>()
    static private let storage = Storage.storage().reference()
    
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    
    /// Upload an image to the firebase storage and returns completion with a URL string to download
    static func uploadImage(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        StorageManager.storage.child(fileName).putData(data, metadata: nil, completion: { metadata, error in
            guard error == nil else {
                // Failed
                print("Upload to firebase storage has failed.")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            StorageManager.storage.child(fileName).downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Failed to get download URL.")
                    completion(.failure(StorageErrors.failedToGetDownloadURL))
                    return
                }
                
                let urlString = url.absoluteString
                print("Download URL returned:  \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadURL
    }
}

extension StorageManager {
    /// Get a UIImage from a given URL
    static func downloadImage(with downloadURL: String, completion: @escaping (UIImage?) -> Void) {
        if let image = StorageManager.cache.object(forKey: downloadURL as NSString) {
            completion(image)
        } else {
            StorageManager.downloadImageFromURL(with: downloadURL, completion: completion)
        }
    }
    
    /// Download an image and store in cache
    static func downloadImageFromURL(with downloadURL: String, completion: @escaping (UIImage?) -> Void) {
        let storageRef = StorageManager.storage.storage.reference(forURL: "gs://scribbly-dfd4c.appspot.com/\(downloadURL)")
        // TODO: CHANGE THIS BACK TO 1 * 1024 * 1024 when a resizing is found
        storageRef.getData(maxSize: 5 * 1024 * 1024, completion: { data, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                let image = UIImage(data: data!)
                StorageManager.cache.setObject(image!, forKey: downloadURL as NSString)
                completion(image)
            }
        })
    }
}
