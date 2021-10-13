//
//  ExploreHashtagViewModel.swift
//  ExploreHashtagViewModel
//
//  Created by SEAN BLAKE on 10/13/21.
//

import Foundation
import UIKit

// MARK: - The Explore ViewModels
// Hashtag
struct ExploreHashtagViewModel {
    let text: String
    let icon: UIImage?
    let count: Int /// For the number of Posts associated to the Hashtag
    let handler: (() -> Void)
}
