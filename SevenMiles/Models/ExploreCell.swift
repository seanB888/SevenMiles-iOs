//
//  ExploreCell.swift
//  ExploreCell
//
//  Created by SEAN BLAKE on 10/13/21.
//

import Foundation
import UIKit

enum ExploreCell {
    case banner(viewModel: ExploreBannerViewModel)
    case post(viewModel: ExplorePostsViewModel)
    case hashtag(viewModel: ExploreHashtagViewModel)
    case user(viewModel: ExploreUserViewModel)
    
}
