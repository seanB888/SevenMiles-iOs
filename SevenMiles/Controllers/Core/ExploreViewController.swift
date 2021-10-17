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
        // MARK - Banner
        /// Banner
        var cells = [ExploreCell]()
        for _ in 0...2 {
            let cell = ExploreCell.banner(
                viewModel: ExploreBannerViewModel(
                    image: UIImage(named: "r35rb"),
                    title: "Rocket Bunny R35",
                    handler: {
                        
                    }
                )
            )
            cells.append(cell)
        }
        sections.append(
            ExploreSection(
                type: .banners,
                cells: cells
            )
        )
        
        // MARK - Trending Post
        ///Trending Posts
        var posts = [ExploreCell]()
        for _ in 0...10 {
            posts.append(
                ExploreCell.post(
                    viewModel: ExplorePostsViewModel(thumbnailImage: UIImage(named: "test"),
                        caption: "Free from",
                        handler: {
                            
                        })))
        }
        sections.append(
            ExploreSection(
                type: .trendingPosts,
                cells: posts
            )
        )
        
        // MARK - Users
        /// Users
        sections.append(
            ExploreSection(
                type: .users,
                cells: [
                    .user(viewModel: ExploreUserViewModel(
                        profilePictureURL: nil,
                        username: "SeanB",
                        followerCount: 30000000,
                        handler: {
                            
                        })),
                    .user(viewModel: ExploreUserViewModel(
                        profilePictureURL: nil,
                        username: "YogieB",
                        followerCount: 50000000,
                        handler: {
                            
                        })),
                    .user(viewModel: ExploreUserViewModel(
                        profilePictureURL: nil,
                        username: "uzimmie",
                        followerCount: 30000000,
                        handler: {
                            
                        })),
                    .user(viewModel: ExploreUserViewModel(
                        profilePictureURL: nil,
                        username: "Guhso",
                        followerCount: 30000000,
                        handler: {
                            
                        })),
                    .user(viewModel: ExploreUserViewModel(
                        profilePictureURL: nil,
                        username: "nadsa45",
                        followerCount: 1800,
                        handler: {
                            
                        })),
                    .user(viewModel: ExploreUserViewModel(
                        profilePictureURL: nil,
                        username: "Auriah",
                        followerCount: 130000000,
                        handler: {
                            
                        })),
                    .user(viewModel: ExploreUserViewModel(
                        profilePictureURL: nil,
                        username: "MikaB",
                        followerCount: 300000000,
                        handler: {
                            
                        })),
                    .user(viewModel: ExploreUserViewModel(
                        profilePictureURL: nil,
                        username: "AliyaT",
                        followerCount: 800000000,
                        handler: {
                            
                        }))
                ]
            )
        )
        
        /// Trending Hashtags
//        var hashtags = [ExploreCell]()
//        for _ in 0...40 {
//            hashtags.append(
//                ExploreCell.post(viewModel: ExplorePostsViewModel(thumbnailImage: nil, caption: "", handler: {
//
//                }))
//            )
//        }
        sections.append(
            ExploreSection(
                type: .trendingHashtags,
                cells: [
                    .hashtag(viewModel: ExploreHashtagViewModel(text: "#iOSDEV", icon: nil, count: 15, handler: {
                        
                    })),
                    .hashtag(viewModel: ExploreHashtagViewModel(text: "#blackandbrownandred", icon: nil, count: 1000000, handler: {
                        
                    })),
                    .hashtag(viewModel: ExploreHashtagViewModel(text: "#typer", icon: nil, count: 100, handler: {
                        
                    })),
                    .hashtag(viewModel: ExploreHashtagViewModel(text: "#cbr1000rr", icon: nil, count: 60, handler: {
                        
                    })),
                    .hashtag(viewModel: ExploreHashtagViewModel(text: "#asiansensation", icon: nil, count: 1800000, handler: {
                        
                    })),
                    .hashtag(viewModel: ExploreHashtagViewModel(text: "#hotimportnights", icon: nil, count: 1245000, handler: {
                        
                    }))
                ]
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
            forCellWithReuseIdentifier: "cell"
        )
        collectionView.register(
            ExploreBannerCollectionViewCell.self,
            forCellWithReuseIdentifier: ExploreBannerCollectionViewCell.identifier
        )
        collectionView.register(
            ExplorePostCollectionViewCell.self,
            forCellWithReuseIdentifier: ExplorePostCollectionViewCell.identifier
        )
        collectionView.register(
            ExploreUserCollectionViewCell.self,
            forCellWithReuseIdentifier: ExploreUserCollectionViewCell.identifier
        )
        collectionView.register(
            ExploreHashtagCollectionViewCell.self,
            forCellWithReuseIdentifier: ExploreHashtagCollectionViewCell.identifier
        )
        
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        // collectionView.backgroundColor = .systemPink
        view.addSubview(collectionView)
        
        self.collectionView = collectionView
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
        // BANNER
        case .banner(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExploreBannerCollectionViewCell.identifier,
                for: indexPath
            ) as? ExploreBannerCollectionViewCell else {
                return collectionView.dequeueReusableCell(
                    withReuseIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.configure(with: viewModel)
            return cell
            
        // POST
        case .post(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExplorePostCollectionViewCell.identifier,
                for: indexPath
            ) as? ExplorePostCollectionViewCell else {
                return collectionView.dequeueReusableCell(
                    withReuseIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.configure(with: viewModel)
            return cell
            
        // HASTAG
        case .hashtag(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ExploreHashtagCollectionViewCell.identifier,
                for: indexPath
            ) as? ExploreHashtagCollectionViewCell else {
                return collectionView.dequeueReusableCell(
                    withReuseIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.configure(with: viewModel)
            return cell
            
            // USER
            case .user(let viewModel):
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ExploreUserCollectionViewCell.identifier,
                    for: indexPath
                ) as? ExploreUserCollectionViewCell else {
                    return collectionView.dequeueReusableCell(
                        withReuseIdentifier: "cell",
                        for: indexPath
                    )
                }
            cell.configure(with: viewModel)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        let model = sections[indexPath.section].cells[indexPath.row]
        
        switch model {
            // BANNER
        case .banner(let viewModel):
            break
            // POST
        case .post(let viewModel):
            break
            // HASTAG
        case .hashtag(let viewModel):
            break
            // USER
        case .user(let viewModel):
            break
        }
    }
}

extension ExploreViewController: UISearchBarDelegate {
    
}

// MARK: - Sections Layouts

extension ExploreViewController {
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
                    widthDimension: .absolute(250),
                    heightDimension: .absolute(85)
                ),
                subitem: item,
                count: 1
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(250),
                    heightDimension: .absolute(85)
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
                    widthDimension: .absolute(150),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            
            // Section layout
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            
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
                    widthDimension: .absolute(200),
                    heightDimension: .absolute(50)
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
