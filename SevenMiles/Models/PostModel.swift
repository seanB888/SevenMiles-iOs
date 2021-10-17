//
//  PostModel.swift
//  PostModel
//
//  Created by SEAN BLAKE on 10/10/21.
//

import Foundation
import UIKit

struct PostModel {
    let identifier: String
    
    // Mockup user
    let user = User(
        username: "Sean",
        profilePictureURL: nil,
        indentifier: UUID().uuidString
    )
    
    // an emutable property
    var isLikedByCurrentUser = false
    
    // Used for debugging purposes
    static func mockModels() -> [PostModel] {
        var posts = [PostModel]()
        for _ in 0...100 {
            let post = PostModel(identifier: UUID().uuidString)
            posts.append(post)
        }
        return posts
    }
}
