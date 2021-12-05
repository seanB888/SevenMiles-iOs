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
    let user: User
    var fileName: String = ""
    var captionName: String = ""
    
    // an emutable property
    var isLikedByCurrentUser = false
    
    // Used for debugging purposes
    static func mockModels() -> [PostModel] {
        var posts = [PostModel]()
        for _ in 0...100 {
            let post = PostModel(
                identifier: UUID().uuidString,
                user: User(
                    username: "Sean",
                    profilePictureURL: nil,
                    indentifier: UUID().uuidString
                )
            )
            posts.append(post)
        }
        return posts
    }
    
    var videoChildPath: String {
        print(user.username.lowercased())
        return "videos/\(user.username)/\(fileName)"
    }
}
