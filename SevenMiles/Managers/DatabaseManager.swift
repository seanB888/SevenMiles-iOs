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
    
    public func getAllUsers(completion: ([String]) -> Void) {
        
    }
}
