//
//  ExploreUserViewModel.swift
//  ExploreUserViewModel
//
//  Created by SEAN BLAKE on 10/13/21.
//

import Foundation
import UIKit

// MARK: - The Explore ViewModels
// User
struct ExploreUserViewModel {
    let profilePicture: UIImage?
    let username: String
    let followerCount: Int /// To show how many people are following them
    let handler: (() -> Void)
}
