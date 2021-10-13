//
//  ExplorePostsViewModel.swift
//  ExplorePostsViewModel
//
//  Created by SEAN BLAKE on 10/13/21.
//

import Foundation
import UIKit

// MARK: - The Explore ViewModels
// Posts
struct ExplorePostsViewModel {
    let thumbnailImage: UIImage?
    let caption: String
    let handler: (() -> Void)
}
