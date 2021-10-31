//
//  Notifications.swift
//  Notifications
//
//  Created by SEAN BLAKE on 10/30/21.
//

import Foundation
 
struct Notification {
    let text: String
    let date: Date
    
    static func mockData() -> [Notification] {
        return Array(0...100).compactMap({
            Notification(text: "A wha a gwaan: \($0)", date: Date())
        })
    }
}
