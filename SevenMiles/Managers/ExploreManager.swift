//
//  ExploreManager.swift
//  ExploreManager
//
//  Created by SEAN BLAKE on 10/16/21.
//

import Foundation
import UIKit

/// Delegate to notify manager events
protocol ExploreManagerDelegate: AnyObject {
    /// Notify a view controller should be pushed
    /// - Parameter vc: the view controller to present
    func pushViewController(_ vc: UIViewController)
    /// Notify a hadhtag element was tapped
    ///  - Parameter hashtag: The hashtag that was tapped
    func didTapHashTag(_ hashtag: String)
}

/// Manager that handles explore view content
final class ExploreManager {
    /// Shared singleton instance
    static let shared = ExploreManager()

    /// Delegate to notify of events
    weak var delegate: ExploreManagerDelegate?

    /// Repersents Banner action type
    enum BannerAction: String {
        /// Post type
        case post
        /// Hastag search type
        case hashtag
        /// Creator type
        case user
    }

    // MARK: - BANNER
    /// Gets Explore Data for the banner
    /// - Returns: Returns collection of models
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
    /// Gets Explore Data of creators
    /// - Returns: Returns collection of models
    public func getExploreCreators() -> [ExploreUserViewModel] {
        guard let exploreData = parseExploreData() else {
            return []
        }

        return exploreData.creators.compactMap({ model in
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
    /// Gets Explore Data for hashtags
    /// - Returns: Returns collection of models
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
                // code... main thread
                DispatchQueue.main.async {
                    self?.delegate?.didTapHashTag(model.tag)
                }
            }
        })
    }

    // MARK: - TRENDING POSTS
    /// Gets Explore Data for trending posts
    /// - Returns: Returns collection of models
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
    /// Gets Explore Data for recent posts
    /// - Returns: Returns collection of models
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
    /// Gets Explore Data for popular posts
    /// - Returns: Returns collection of models
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
    /// Parse explore JSON data
    /// - Returns: Returns a optional response model
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
        } catch {
            print(error)
            return nil
        }
    }
}
