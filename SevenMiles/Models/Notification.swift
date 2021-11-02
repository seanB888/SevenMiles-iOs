//
//  Notifications.swift
//  Notifications
//
//  Created by SEAN BLAKE on 10/30/21.
//

import Foundation

enum NotificationType {
    case postLike(postName: String)
    case userFollow(username: String )
    case postComment(postName: String)
    
    var id: String {
        switch self {
            
        case .postLike:
            return "postLike"
        case .userFollow:
            return "userFolow"
        case .postComment:
            return "postComment"
        }
    }
}
 
struct Notification {
    let text: String
    let type: NotificationType
    let date: Date
    
    static func mockData() -> [Notification] {
        return Array(0...100).compactMap({
            Notification(
                text: "A wha a gwaan: \($0)",
                type: .userFollow(username: "KanyeWest"),
                date: Date()
            )
        })
    }
}
