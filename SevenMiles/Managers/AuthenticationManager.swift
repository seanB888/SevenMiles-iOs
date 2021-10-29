//
//  AuthenticationManager.swift
//  AuthenticationManager
//
//  Created by SEAN BLAKE on 10/8/21.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    public static let shared = AuthManager()
    
    private init() {}
    
    enum SignInMethod {
        case email
        case facebook
        case google
//        case apple
//        case phone
    }
    
    enum AuthError: Error {
        case signInFailed
    }
    
    //MARK:  - Public
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
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
