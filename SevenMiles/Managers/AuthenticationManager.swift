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
    
    // Public
    
    public func signIn(with method: SignInMethod) {
        
    }
    
    public func signOut() {
        
    }
}
