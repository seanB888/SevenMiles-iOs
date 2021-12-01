//
//  DatabaseManager.swift
//  DatabaseManager
//
//  Created by SEAN BLAKE on 10/8/21.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    public static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    private init() {}
    
    // Public
    public func insertUser(with email: String, username: String, firstname: String, lastName: String, phoneNumber: String, completion: @escaping (Bool) -> Void) {
        /*
         - get current user
         - insert new user
         - create a root user
         */
        // Get current User
        database.child("user").observeSingleEvent(of: .value) { [weak self] snapshot in
            guard var usersDictionary = snapshot.value as? [String: Any] else {
                // create users root node
                self?.database.child("user").setValue(
                    [
                        username: [
                            "email": email
                        ]
                    ]) { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    }
                return
            }
            usersDictionary[username] = ["email": email]
            // save new users object
            self?.database.child("user").setValue(usersDictionary, withCompletionBlock: { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            })
        }
    }
    
    public func getUsername(for email: String, completion: @escaping (String?) -> Void) {
        database.child("user").observeSingleEvent(of: .value) { snapshot in
            guard let users = snapshot.value as? [String: [String: Any]] else {
                completion(nil)
                return
            }
            
            for (username, value) in users {
                if value["email"] as? String == email {
                    completion(username)
                    break
                }
            }
        }
    }
    
    public func insertPost(fileName: String, caption: String, completion: @escaping (Bool) -> Void) {
        /// Get the current users username
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        
        /// Get that node
        database.child("user").child(username).observeSingleEvent(of: .value) { [weak self] snapshot in
            guard var value = snapshot.value as? [String: Any] else {
                completion(false)
                return
            }
            
            let newEntry = [
                "name": fileName,
                "caption": caption
            ]
            
            if var posts = value["posts"] as? [[String: Any]] {
                posts.append(newEntry)
                value["posts"] = posts
                self?.database.child("user").child(username).setValue(value) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            }
            else {
                value["posts"] = [newEntry]
                self?.database.child("user").child(username).setValue(value) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    completion(true)
                }
            }
        }
    }
    
    /// FOR FETCHING NOTIFICATIONS
    public func getNotifications (completion: @escaping ([Notification]) -> Void) {
        completion(Notification.mockData())
    }
    
    public func markNotificationAsHidden(notificationID: String, completion: @escaping (Bool) -> Void) {
        completion(true)
    }
    
    public func follow(username: String, completion: @escaping (Bool) -> Void) {
        completion(true)
    }
    
    public func getAllUsers(completion: ([String]) -> Void) {
        
    }
    
    public func getPosts(for user: User, completion: @escaping ([PostModel]) -> Void) {
        
        /// Reference
        let path = "user/\(user.username.lowercased())/posts"
        database.child(path).observeSingleEvent(of: .value) { (snapshot) in
            guard let posts = snapshot.value as? [[String: String]] else {
                completion([])
                return
            }
            
            let models: [PostModel] = posts.compactMap({
                var model = PostModel(identifier: UUID().uuidString,
                          user: user)
                model.fileName = $0["name"] ?? ""
                model.captionName = $0["name"] ?? ""
                return model
            })
            completion(models)
        }
    }
}
