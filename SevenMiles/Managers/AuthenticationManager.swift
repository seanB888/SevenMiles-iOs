//
//  AuthenticationManager.swift
//  AuthenticationManager
//
//  Created by SEAN BLAKE on 10/8/21.
//

import Foundation
import FirebaseAuth

/// Manager reponsibile for signing in, up, and out
final class AuthManager {
    /// Singleton instance of the manager
    public static let shared = AuthManager()
    
    /// Private constructor
    private init() {}
    
    /// Repersents method to sign in
    enum SignInMethod {
        /// Eamil method
        case email
        /// Facebook account method
        case facebook
        /// Google account method
        case google
        /// Apple account method
//        case apple
        /// User phone number method
//        case phone
    }
    
    /// Errors that can occur in Auth flows
    enum AuthError: Error {
        case signInFailed
    }
    
    //MARK:  - Public
    /// Repersents if user is signed in
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    /// Attempt to Sign in
    /// - Parameters:
    ///   - email: User email
    ///   - password: User password
    ///   - completion: Async result callback
    public func signIn(with email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard result != nil, error == nil else {
                if let error = error {
                    completion(.failure(error))
                }
                else {
                    completion(.failure(AuthError.signInFailed))
                }
                return
            }
            // query database for the username
            DatabaseManager.shared.getUsername(for: email) { username in
                if let username = username {
                    UserDefaults.standard.setValue(username, forKey: "username")
                    print("This is the username: \(username)")
                }
            }
            
            // Successful sign in
            completion(.success(email))
        }
    }
    
    /// Attempt to sign up
    /// - Parameters:
    ///   - username: Desired username
    ///   - emailAddress: User email address
    ///   - password: User password
    ///   - firstName: User first name
    ///   - lastName: User last name
    ///   - phoneNumnber: User phone number
    ///   - completion: Async result callback
    public func signUp(
        with username: String,
        emailAddress: String,
        password: String,
        firstName: String,
        lastName: String,
        phoneNumnber: String,
        completion: @escaping (Bool) -> Void
    ) {
        // Make sure username is avaiable
        
        Auth.auth().createUser(withEmail: emailAddress, password: password) { result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            
            DatabaseManager.shared.insertUser(with: emailAddress, username: username, firstname: firstName, lastName: lastName, phoneNumber: phoneNumnber, completion: completion)
        }
    }
    
    /// Attempt to sign out
    /// - Parameter completion: Async callback of sign out result 
    public func signOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        }
        catch {
            print(error)
            completion(false)
        }
    }
}
