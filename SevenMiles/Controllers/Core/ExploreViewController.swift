//
//  ExploreViewController.swift
//  ExploreViewController
//
//  Created by SEAN BLAKE on 10/8/21.
//

import UIKit

class ExploreViewController: UIViewController {
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search..."
        bar.layer.cornerRadius = 25
        bar.layer.masksToBounds = true
        return bar
    }()
    
    // a private collection of sections
    private var sections = [ExploreSection]()
    
    private var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureModels()
        setUpSearchBar()
        setUpCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    func setUpSearchBar() {
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
    
    func configureModels() {
        var cells = [ExploreCell]()
        for _ in 0...100 {
            let cell = ExploreCell.banner(
                viewModel: ExploreBannerViewModel(
                    image: nil,
                    title: "Foo Fighter",
                    handler: {
                        
                    }
                )
            )
            cells.append(cell)
        }
        /// Banner
        sections.append(
                ExploreSection(
                    type: .banners,
                    cells: cells
                )
        )
        
        var trendings = [ExploreCell]()
        for _ in 0...40 {
            trendings.append(
                ExploreCell.post(viewModel: ExplorePostsViewModel(thumbnailImage: nil, caption: "", handler: {
                    
                }))
            )
        }
        
        ///Trending Posts
        sections.append(
                ExploreSection(
                    type: .trendingPosts,
                    cells: trendings
                )
        )
        
        var users = [ExploreCell]()
        for _ in 0...40 {
            users.append(
                ExploreCell.post(viewModel: ExplorePostsViewModel(thumbnailImage: nil, caption: "", handler: {
                    
                }))
            )
        }
        
        /// Users
        sections.append(
                ExploreSection(
                    type: .users,
                    cells: users
//                    cells: [
//                        .user(viewModel: ExploreUserViewModel(
//                            profilePictureURL: nil,
//                            username: "SeanB",
//                            followerCount: 30000000,
//                            handler: {
//
//                        })),
//                        .user(viewModel: ExploreUserViewModel(
//                            profilePictureURL: nil,
//                            username: "YogieB",
//                            followerCount: 50000000,
//                            handler: {
//
//                        })),
//                        .user(viewModel: ExploreUserViewModel(
//                            profilePictureURL: nil,
//                            username: "uzimmie",
//                            followerCount: 30000000,
//                            handler: {
//
//                        })),
//                        .user(viewModel: ExploreUserViewModel(
//                            profilePictureURL: nil,
//                            username: "Guhso",
//                            followerCount: 30000000,
//                            handler: {
//
//                        })),
//                        .user(viewModel: ExploreUserViewModel(
//                            profilePictureURL: nil,
//                            username: "nadsa45",
//                            followerCount: 1800,
//                            handler: {
//
//                        })),
//                        .user(viewModel: ExploreUserViewModel(
//                            profilePictureURL: nil,
//                            username: "Auriah",
//                            followerCount: 130000000,
//                            handler: {
//
//                        })),
//                        .user(viewModel: ExploreUserViewModel(
//                            profilePictureURL: nil,
//                            username: "MikaB",
//                            followerCount: 300000000,
//                            handler: {
//
//                        })),
//                        .user(viewModel: ExploreUserViewModel(
//                            profilePictureURL: nil,
//                            username: "AliyaT",
//                            followerCount: 800000000,
//                            handler: {
//
//                        }))
//                    ]
                )
        )
        
        var posts = [ExploreCell]()
        for _ in 0...40 {
            posts.append(
                ExploreCell.post(viewModel: ExplorePostsViewModel(thumbnailImage: nil, caption: "", handler: {
                    
                }))
            )
        }
        
        /// Trending Hashtags
        sections.append(
                ExploreSection(
                    type: .trendingHashtags,
                    cells: posts
                )
        )
        
        /// Recommended
        sections.append(
                ExploreSection(
                    type: .recommended,
                    cells: [
                        .post(viewModel: ExplorePostsViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                        })),
                        .post(viewModel: ExplorePostsViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                        })),
                        .post(viewModel: ExplorePostsViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                        })),
                        .post(viewModel: ExplorePostsViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                        })),
                        .post(viewModel: ExplorePostsViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                        }))
                    ]
                )
        )
        
        ///Popular
        sections.append(
                ExploreSection(
                    type: .popular,
                    cells: [
                        .post(viewModel: ExplorePostsViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                        })),
                        .post(viewModel: ExplorePostsViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                        })),
                        .post(viewModel: ExplorePostsViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                        })),
                        .post(viewModel: ExplorePostsViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                        })),
                        .post(viewModel: ExplorePostsViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                        }))
                    ]
                )
        )
        
        /// Recent
        sections.append(
                ExploreSection(
                    type: .new,
                    cells: [
                        .post(viewModel: ExplorePostsViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                        })),
                        .post(viewModel: ExplorePostsViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                        })),
                        .post(viewModel: ExplorePostsViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                        })),
                        .post(viewModel: ExplorePostsViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                        })),
                        .post(viewModel: ExplorePostsViewModel(thumbnailImage: nil, caption: "", handler: {
                            
                        }))
                    ]
                )
        )
    }
    
    func setUpCollectionView() {
        let layout = UICollectionViewCompositionalLayout { section, _ -> NSCollectionLayoutSection? in
            return self.layout(for: section)
        }
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            UICollectionViewCell.self,
            forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        // collectionView.backgroundColor = .systemPink
        view.addSubview(collectionView)
        
        self.collectionView = collectionView
    }
    
    func layout(for section: Int) -> NSCollectionLayoutSection {
        let sectionType = sections[section].type
        
        switch sectionType {
        /// Banners
        case .banners:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.98),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            
            // Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
            
            // Return
            return sectionLayout
            
        /// Trending P osts
        case .trendingPosts:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Group
            let Verticalgroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(150),
                    heightDimension: .absolute(150)
                ),
                subitem: item,
                count: 1
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(150),
                    heightDimension: .absolute(150)
                ),
                subitems: [Verticalgroup])
            
            // Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            
            // Return
            return sectionLayout
            
        /// Users
        case .users:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.98),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            
            // Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
            
            // Return
            return sectionLayout
            
        /// Trending Hashtags
        case .trendingHashtags:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Group
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(240),
                    heightDimension: .absolute(100)
                ),
                subitem: item,
                count: 1
            )
            
            // Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
            
            // Return
            return sectionLayout
            
        /// Recommended
        case .recommended:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.98),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            
            // Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
            
            // Return
            return sectionLayout
            
        /// Popular
        case .popular:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(150),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            
            // Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
            
            // Return
            return sectionLayout
            
        /// New
        case .new:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            // Group
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.98),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            
            // Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
            
            // Return
            return sectionLayout
        }
    }
}

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = sections[indexPath.section].cells[indexPath.row]
        
        switch model {
            
        case .banner(let viewModel):
            break
        case .post(let viewModel):
            break
        case .hashtag(let viewModel):
            break
        case .user(let viewModel):
            break
        }
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        )
        cell.backgroundColor = .black
        return cell
    }
}

extension ExploreViewController: UISearchBarDelegate {
    
}
