//
//  PostModel.swift
//  PostModel
//
//  Created by SEAN BLAKE on 10/10/21.
//

import Foundation

struct PostModel {
    let identifier: String
    
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
