//
//  StorageManager.swift
//  StorageManager
//
//  Created by SEAN BLAKE on 10/8/21.
//

import Foundation
import FirebaseStorage

/// Manager Object that deals with Firebase Storage
final class StorageManager {
    /// Shared singleton instance
    public static let shared = StorageManager()

    /// Storage bucket refernce
    private let storageBucket = Storage.storage().reference()

    /// Private constructor
    private init() {}

    // Public

    /// Upload a new video to Firebase
    /// - Parameters:
    ///   - url: Local file url to video
    ///   - fileName: Desired video file upload name
    ///   - completion: Async callback result closure
    public func uploadVideoURL(from url: URL, fileName: String, completion: @escaping (Bool) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }

        storageBucket.child("videos/\(username)/\(fileName)").putFile(from: url, metadata: nil) { _, error in
            completion(error == nil)
        }
    }

    /// Upload image
    /// - Parameters:
    ///   - image: Upload and new picture to Firebase
    ///   - completion: Async callback result
    public func uploadProfilePicture(with image: UIImage, completion: @escaping (Result <URL, Error>) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        /// Convert the image format
        guard let imageData = image.pngData() else {
            return
        }

        let path = "Profile_Pictures/\(username)/picture.png"
        storageBucket.child(path).putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                self.storageBucket.child(path).downloadURL { url, error in
                    guard let url = url else {
                        if let error = error {
                            completion(.failure(error))
                        }
                        return
                    }
                    completion(.success(url))
                }
            }
        }
    }

    /// Generates a new filename
    /// - Returns: Returns a unique generated filename
    public func generateVideoName() -> String {
        let uuidString = UUID().uuidString
        let number = Int.random(in: 0...1000)
        let unixTimestamp = Date().timeIntervalSinceNow

        return uuidString + "_\(number)_" + "\(unixTimestamp)" + ".mov"
    }

    /// Get downlod url of video post
    /// - Parameters:
    ///   - post: Post model to get URL for
    ///   - completion: Async callback
    func getDownloadURL(for post: PostModel, completion: @escaping (Result<URL, Error>) -> Void) {
        print("Video Child Path: \(post.videoChildPath)")
        storageBucket.child(post.videoChildPath).downloadURL { url, error in
            if let error = error {
                completion(.failure(error))
            } else if let url = url {
                completion(.success(url))
            }
        }
    }
}
