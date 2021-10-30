//
//  Notifications.swift
//  Notifications
//
//  Created by SEAN BLAKE on 10/30/21.
//

import Foundation
 
struct Noification {
    let text: String
    let date: Date()
    
    static func mockData() -> [Notification]{
        return Array(0...100).compactMap({
            Notification(text: "Wha Gwaan World!! \($0)", date: Date)
        })
    }
}
