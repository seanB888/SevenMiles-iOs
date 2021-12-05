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
    func didTapHashTag(_ hashtag: String)
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
            ) { [ weak self ] in
                guard let action = BannerAction(rawValue: model.action) else {
                    return
                }
                // Code for tapping on any banner in the Explore sections
                DispatchQueue.main.async {
                    let vc = UIViewController()
                    vc.view.backgroundColor = .systemOrange
                    vc.title = action.rawValue.uppercased()
                    self?.delegate?.pushViewController(vc)
                }
                
                switch action {
                case .user:
                    // present Profile of that user
                    break
                case .post:
                    // present post of that user
                    break
                case .hashtag:
                    // present hashtag of that user
                    break
                }
            }
        })
    }
    
    // MARK: - USERS
    public func getExploreCreators() -> [ExploreUserViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        
        return exploreData.creators.compactMap ({ model in
            ExploreUserViewModel(
                profilePicture: UIImage(named: model.image),
                username: model.username,
                followerCount: model.followers_count
            ) { [ weak self ] in
                // code...
                DispatchQueue.main.async {
                    let userId = model.id
                    // Fetch user object from Firebase
                    let vc = ProfileViewController(user: User(username: "SeanB", profilePictureURL: nil, indentifier: userId))
                    self?.delegate?.pushViewController(vc)
                }
            }
        })
    }
    
    // MARK: - HASHTAGS
    public func getExploreHashtags() -> [ExploreHashtagViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        
        return exploreData.hashtags.compactMap({ model in
            ExploreHashtagViewModel(
                text: model.tag,
                icon: UIImage(systemName: model.image),
                count: model.count
            ) { [ weak self ] in
                //code... main thread
                DispatchQueue.main.async {
                    self?.delegate?.didTapHashTag(model.tag)
                }
            }
        })
    }
    
    
    // MARK: - TRENDING POSTS
    public func getExploreTrendingPosts() -> [ExplorePostsViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        
        return exploreData.trendingPosts.compactMap({ model in
            ExplorePostsViewModel(
                thumbnailImage: UIImage(named: model.image),
                caption: model.caption
            ) { [weak self ] in
                // code... to fetch post by id on firebase
                DispatchQueue.main.async {
                    let postID = model.id
                    let vc = PostViewController(
                        model: PostModel(identifier: postID, user: User(
                            username: "Sean",
                            profilePictureURL: nil,
                            indentifier: UUID().uuidString
                        )))
                    self?.delegate?.pushViewController(vc)
                }
            }
        })
    }
    
    // MARK: - RECENT POSTS
    public func getExploreRecentPosts() -> [ExplorePostsViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        
        return exploreData.recentPosts.compactMap({ model in
            ExplorePostsViewModel(
                thumbnailImage: UIImage(named: model.image),
                caption: model.caption
            ) { [ weak self ] in
                // Soon add some code...
                DispatchQueue.main.async {
                    let postID = model.id
                    let vc = PostViewController(model: PostModel(identifier: postID, user: User(
                        username: "Sean",
                        profilePictureURL: nil,
                        indentifier: UUID().uuidString
                    )))
                    self?.delegate?.pushViewController(vc)
                }
            }
        })
    }
    
    // MARK: - POPULAR POSTS
    public func getExplorePopularPosts() -> [ExplorePostsViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }
        
        return exploreData.popular.compactMap({ model in
            ExplorePostsViewModel(
                thumbnailImage: UIImage(named: model.image),
                caption: model.caption
            ) { [ weak self ] in
                // Soon add some code...
                DispatchQueue.main.async {
                    let postID = model.id
                    let vc = PostViewController(model: PostModel(identifier: postID, user: User(
                        username: "SeanB",
                        profilePictureURL: nil,
                        indentifier: UUID().uuidString
                    )))
                    self?.delegate?.pushViewController(vc)
                }
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

