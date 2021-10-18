//
//  ExploreManager.swift
//  ExploreManager
//
//  Created by SEAN BLAKE on 10/16/21.
//

import Foundation
import UIKit

protocol ExploreManagerDelegate: AnyObject {
    func pushViewController(_ vc: UIViewController)
}

final class ExploreManager {
    static let shared = ExploreManager()
    
    weak var delegate: ExploreManagerDelegate?
    
    enum BannerAction: String {
        case post
        case hashtag
        case user
    }
    
    // MARK: - BANNER
    // to loadup json and parse it
    public func getExploreBanners() -> [ExploreBannerViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        
        return exploreData.banners.compactMap({ model in
            return ExploreBannerViewModel(
                image: UIImage(named: model.image),
                title: model.title
            ) {
                // Code...
                model.action
            }
        })
    }
    
    // MARK: - USERS
    public func getExploreCreators() -> [ExploreUserViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        
        return exploreData.creators.compactMap ({
            ExploreUserViewModel(
                profilePicture: UIImage(named: $0.image),
                username: $0.username,
                followerCount: $0.followers_count
            ) {
                // Soon add some code...
            }
        })
    }
    
    // MARK: - HASHTAGS
    public func getExploreHashtags() -> [ExploreHashtagViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        
        return exploreData.hashtags.compactMap({
            ExploreHashtagViewModel(
                text: "#" + $0.tag,
                icon: UIImage(systemName: $0.image),
                count: $0.count
            ) {
                    // Soon add some code...
                }
        })
    }
    
    
    // MARK: - TRENDING POSTS
    public func getExploreTrendingPosts() -> [ExplorePostsViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        
        return exploreData.trendingPosts.compactMap({
            ExplorePostsViewModel(
                thumbnailImage: UIImage(named: $0.image),
                caption: $0.caption
            ) {
                // Soon add some code...
            }
        })
    }
    
    // MARK: - RECENT POSTS
    public func getExploreRecentPosts() -> [ExplorePostsViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        
        return exploreData.recentPosts.compactMap({
            ExplorePostsViewModel(
                thumbnailImage: UIImage(named: $0.image),
                caption: $0.caption
            ) {
                // Soon add some code...
            }
        })
    }
    
    // MARK: - POPULAR POSTS
    public func getExplorePopularPosts() -> [ExplorePostsViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        
        return exploreData.popular.compactMap({
            ExplorePostsViewModel(
                thumbnailImage: UIImage(named: $0.image),
                caption: $0.caption
            ) {
                // Soon add some code...
            }
        })
    }
    
    // MARK: - PRIVATE
    // function used to parse the JSON
    private func parseExploreData() -> ExploreResponse? {
        guard let path = Bundle.main.path(forResource: "explore", ofType: "json") else {
            return nil
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
    let caption: String
}

struct Hashtag: Codable {
    let image: String
    let tag: String
    let count: Int
}

struct Creator: Codable {
    let id: String
    let image: String
    let username: String
    let followers_count: Int
}

