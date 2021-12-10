//
//  PostComments.swift
//  PostComments
//
//  Created by SEAN BLAKE on 10/11/21.
//

import Foundation

struct PostComment {
    let text: String
    let user: User
    let date: Date

    static func mockComments() -> [PostComment] {
        let user = User(username: "Nas",
                        profilePictureURL: nil,
                        indentifier: UUID().uuidString)

        var comments = [PostComment]()

        let text = [
            "Where was this shot?",
            "Makin moves this weekend",
            "This is hot 🔥🔥🔥🔥🔥",
            "Love this style",
            "Thats some slick ass shit 😂😂😂😂😂😂",
            "I was this years old when I saw this",
            "WTF, and I aint talkin Wednesday, Thursday or Friday"
        ]

        for comment in text {
            comments.append(
                PostComment(
                    text: comment,
                    user: user,
                    date: Date()
                )
            )
        }
        return comments
    }
}
