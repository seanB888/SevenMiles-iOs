//
//  ExploreBannerViewModel.swift
//  ExploreBannerViewModel
//
//  Created by SEAN BLAKE on 10/13/21.
//

import Foundation
import UIKit

// MARK: - The Explore ViewModels
// Banner
struct ExploreBannerViewModel {
    let image: UIImage?
    let title: String
    let handler: (() -> Void)
}
