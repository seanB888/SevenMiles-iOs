//
//  ViewController.swift
//  SevenMiles
//
//  Created by SEAN BLAKE on 10/8/21.
//

import UIKit

class HomeViewController: UIViewController {
    /*
     ScrollView created with an annonymos closure pattern.
     */
    let horizontalScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.backgroundColor = .purple
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    let forYouPagingController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .vertical,
        options: [:]
    )
    
    let followingYouPagingController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .vertical,
        options: [:]
    )
    
    // Used to fetch the POSTS from the database
    /*
     This is using the mockModels for data
     From the PostModel()
     PostModel.mockModels()
     Will change to get real data later
     */
    private var forYouPosts = PostModel.mockModels()
    private var followingPosts = PostModel.mockModels()

    // MARK: -Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(horizontalScrollView)
        setUpFeed()
        horizontalScrollView.contentOffset = CGPoint(x: view.width, y: 0)
    }
    
    // Give the ScrollView a frame
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        horizontalScrollView.frame = view.bounds
    }
    // Feed view
    private func setUpFeed() {
        horizontalScrollView.contentSize = CGSize(width: view.width * 2, height: view.height)
        setUpFollowingFeed()
        setUpForYouFeed()
    }
    
    func setUpFollowingFeed() {
        // getting the first post from the model
        guard let model = followingPosts.first else {
            return
        }
        
        followingYouPagingController.setViewControllers(
            [PostViewController(model: model)],
            direction: .forward,
            animated: false,
            completion: nil
        )
        followingYouPagingController.dataSource = self
        
        // composition child controller
        horizontalScrollView.addSubview(followingYouPagingController.view)
        followingYouPagingController.view.frame = CGRect(
            x: 0,
            y: 0,
            width: horizontalScrollView.width,
            height: horizontalScrollView.height)
        addChild(followingYouPagingController)
        followingYouPagingController.didMove(toParent: self)
    }
    
    func setUpForYouFeed() {
        // getting to first post from the model
        guard let model = forYouPosts.first else {
            return
        }
        
        forYouPagingController.setViewControllers(
            [PostViewController(model: model)],
            direction: .forward,
            animated: false,
            completion: nil
        )
        forYouPagingController.dataSource = self
        
        // composition child controller
        horizontalScrollView.addSubview(forYouPagingController.view)
        forYouPagingController.view.frame = CGRect(
            x: view.width,
            y: 0,
            width: horizontalScrollView.width,
            height: horizontalScrollView.height)
        addChild(forYouPagingController)
        forYouPagingController.didMove(toParent: self)
    }
}

extension HomeViewController: UIPageViewControllerDataSource {
    // this function is used to scroll from the bottom up to the top
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // Used to get the current post
        guard let fromPost = (viewController as? PostViewController)?.model else {
            // if are not able to get the post, return nil
            return nil
        }
        // getting the correct index that matches the identifier
        guard let index = currentPosts.firstIndex(where: {
            // the element identifier = fromPost indentifier
            $0.identifier == fromPost.identifier
        }) else {
            // if doesn't get anything, return nil
            return nil
        }
        
        if index == 0 {
            return nil
        }
        
        let priorIndex = index - 1
        let model = currentPosts[priorIndex]
        let vc = PostViewController(model: model)
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // Used to get the current post
        guard let fromPost = (viewController as? PostViewController)?.model else {
            // if are not able to get the post, return nil
            return nil
        }
        // getting the current index that matches the identifier
        guard let index = currentPosts.firstIndex(where: {
            // the element identifier = fromPost indentifier
            $0.identifier == fromPost.identifier
        }) else {
            // if doesn't get anything, return nil
            return nil
        }
        
        guard index < (currentPosts.count - 1) else {
            return nil
        }
        
        let nextIndex = index + 1
        let model = currentPosts[nextIndex]
        let vc = PostViewController(model: model)
        return vc
    }
    
    // Use to arrange the post
    var currentPosts: [PostModel] {
        if horizontalScrollView.contentOffset.x == 0 {
            // Following page
            return followingPosts
        }
        // ForYou page
        return forYouPosts
    }
}
