//
//  ExploreManager.swift
//  ExploreManager
//
//  Created by SEAN BLAKE on 10/16/21.
//

import Foundation
import UIKit

final class ExploreManager {
    static let shared = ExploreManager()
    
    // to loadup json and parse it
    public func getExploreBanners() -> [ExploreBannerViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        
        return exploreData.banners.compactMap {
            ExploreBannerViewModel(
                image: UIImage($0.image),
                title: $0.title) {
                    // code to come
                }
        }
    }
    
    // function used to parse the JSON
    private func parseExploreData() -> ExploreResponse? {
        guard let path = Bundle.main.path(forResource: "explore", ofType: "json") else {
            return
        }
        // data created from the contents of the URL
        do {
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(
                ExploreResponse.self,
                from: data
            )
        }
        catch {
            print(error)
            return nil
        }
    }
}

struct ExploreResponse: Codable {
    let banners: [Banner]
    let trendingPosts: [Post]
    let creators: [Creator]
    let recentPosts: [Post]
    let hashtags: [Hashtag]
    let popular: [Post]
    let recommended: [Post]
}

struct Banner: Codable {
    let id: String
    let image: String
    let title: String
    let action: String
}

struct Post: Codable {
    let id: String
    let image: String
    let Caption: String
}

struct Hashtag: Codable {
    let image: String
    let tag: String
    let count: String
}

struct Creator: Codable {
    let id: String
    let image: String
    let username: String
    let followers_count: Int
}

