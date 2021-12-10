//
//  DatabaseManager.swift
//  DatabaseManager
//
//  Created by SEAN BLAKE on 10/8/21.
//

import Foundation
import FirebaseDatabase

/// Manager to interact with database
final class DatabaseManager {
    /// Singleton instance of the manager
    public static let shared = DatabaseManager()
    
    /// Database Reference
    private let database = Database.database().reference()
    
    /// Private construct
    private init() {}
    
    // Public
    /// instert a new user
    /// - Parameters:
    ///   - email: Users email
    ///   - username: Unique username
    ///   - firstname: Users first name
    ///   - lastName: Users last name
    ///   - phoneNumber: Users phone number
    ///   - completion: Async callback of results
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
    
    /// Get a username for a given email
    /// - Parameters:
    ///   - email: Email to query
    ///   - completion: Async result callback
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
    
    /// Insert new posts
    /// - Parameters:
    ///   - fileName: File name to insert
    ///   - caption: Caption to insert
    ///   - completion: Async result callback
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
    
    
    /// Reterve current users notifications
    /// - Parameter completion: Result callback of models
    public func getNotifications(completion: @escaping ([Notification]) -> Void) {
        completion(Notification.mockData())
    }
    
    /// Mark a notification as hidden
    /// - Parameters:
    ///   - notificationID: Notification Identifiere
    ///   - completion: Async result callback
    public func markNotificationAsHidden(notificationID: String, completion: @escaping (Bool) -> Void) {
        completion(true)
    }
    
    /// <#Description#>
    /// - Parameters:
    ///   - username: <#username description#>
    ///   - completion: <#completion description#>
    public func follow(username: String, completion: @escaping (Bool) -> Void) {
        completion(true)
    }
    
    /// Get post for a given user
    /// - Parameters:
    ///   - user: User to get post for
    ///   - completion: Async result callback
    public func getPosts(for user: User, completion: @escaping ([PostModel]) -> Void) {
        /// Reference
        let path = "user/\(user.username.lowercased())/posts"
        database.child(path).observeSingleEvent(of: .value) { snapshot in
            guard let posts = snapshot.value as? [[String: String]] else {
                completion([])
                return
            }
            
            let models: [PostModel] = posts.compactMap({
                var model = PostModel(identifier: UUID().uuidString,
                          user: user)
                model.fileName = $0["name"] ?? ""
                model.caption = $0["name"] ?? ""
                return model
            })
            completion(models)
        }
    }
    
    /// Get relationship status for current and target user
    /// - Parameters:
    ///   - user: Target user to check Following status for
    ///   - type: Type to be checked
    ///   - completion: Async result callback
    public func getRelationships(
        for user: User,
        type: UserListViewController.ListType,
        completion: @escaping ([String]) -> Void
    ) {
        let path = "user/\(user.username.lowercased())/\(type.rawValue)"
        print("Path to followwes/following: \(path)")
        
        database.child(path).observeSingleEvent(of: .value) { snapshot in
            guard let usernameCollection = snapshot.value as? [String] else {
                completion([])
                return
            }
            completion(usernameCollection)
        }
    }
    
    /// Check if a relationship is valid
    /// - Parameters:
    ///   - user: Target user to check
    ///   - type: Type to check
    ///   - completion: Result callback
    public func isValidRelationship(
        for user: User,
        type: UserListViewController.ListType,
        completion: @escaping (Bool) -> Void
    ) {
        guard let currentUserUsername = UserDefaults.standard.string(forKey: "username")?.lowercased() else {
            return
        }
        
        let path = "user/\(user.username.lowercased())/\(type.rawValue)"
        
        database.child(path).observeSingleEvent(of: .value) { snapshot in
            guard let usernameCollection = snapshot.value as? [String] else {
                completion(false)
                return
            }
            
            completion(usernameCollection.contains(currentUserUsername))
        }
    }
    /// Update follow status for user
    /// - Parameters:
    ///   - user: Target user
    ///   - follow: Follow or unfollow status
    ///   - completion: Result callback
    public func updateRelationship(
        for user: User,
        follow: Bool,
        completion: @escaping (Bool) -> Void
    ) {
        guard let currentUserUsername = UserDefaults.standard.string(forKey: "username")?.lowercased() else {
            return
        }
        
        if follow {
            // follow
            // insert in the current user's following
            let path = "user/\(currentUserUsername)/following"
            database.child(path).observeSingleEvent(of: .value) { (snapshot) in
                let usernameToInsert = user.username.lowercased()
                if var current = snapshot.value as? [String] {
                    current.append(usernameToInsert)
                    self.database.child(path).setValue(current) { error, _ in
                        completion(error == nil)
                    }
                }
                
                else {
                    self.database.child(path).setValue([usernameToInsert]) { error, _ in
                        completion(error == nil )
                    }
                }
            }
            // insert in the target user's followers
            let path2 = "user/\(user.username.lowercased())/followers"
            database.child(path2).observeSingleEvent(of: .value) { (snapshot) in
                let usernameToInsert = currentUserUsername.lowercased()
                if var current = snapshot.value as? [String] {
                    current.append(usernameToInsert)
                    self.database.child(path2).setValue(current) { error, _ in
                        completion(error == nil)
                    }
                }
                
                else {
                    self.database.child(path).setValue([usernameToInsert]) { error, _ in
                        completion(error == nil )
                    }
                }
            }
        }
        else {
            // unfollow
            // remove from current user following
            let path = "user/\(currentUserUsername)/following"
            database.child(path).observeSingleEvent(of: .value) { (snapshot) in
                let usernameToRemove = user.username.lowercased()
                if var current = snapshot.value as? [String] {
                    current.removeAll(where: {$0 == usernameToRemove })
                    self.database.child(path).setValue(current) { error, _ in
                        completion(error == nil)
                    }
                }
            }
            // Remove in the target user's followers
            let path2 = "user/\(user.username.lowercased())/followers"
            database.child(path2).observeSingleEvent(of: .value) { (snapshot) in
                let usernameToRemove = currentUserUsername.lowercased()
                if var current = snapshot.value as? [String] {
                    current.removeAll(where: { $0 == usernameToRemove })
                    self.database.child(path2).setValue(current) { error, _ in
                        completion(error == nil)
                    }
                }
            }
        }
    }
}
