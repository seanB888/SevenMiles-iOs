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
        database.child("users").observeSingleEvent(of: .value) { [weak self] snapshot in
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
            self?.database.child("users").setValue(usersDictionary, withCompletionBlock: { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            })
        }
    }
    
    public func getAllUsers(completion: ([String]) -> Void) {
        
    }
}
