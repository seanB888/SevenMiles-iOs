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
        // scrollView.backgroundColor = .purple
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    // UISegmentedControl global variable
    let control: UISegmentedControl = {
        let titles = ["Following", "For You"]
        let control = UISegmentedControl(items: titles)
        control.selectedSegmentIndex = 1
        control.backgroundColor = .clear
        /*
         We want the background to be clear
         the have the text change color.
        // control.selectedSegmentTintColor = .clear
         */
        control.selectedSegmentTintColor = .systemPink
        
        return control
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
        horizontalScrollView.contentInsetAdjustmentBehavior = .never
        horizontalScrollView.delegate = self
        horizontalScrollView.contentOffset = CGPoint(x: view.width, y: 0)
        setUpHeaderButtons()
    }
    
    // Give the ScrollView a frame
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        horizontalScrollView.frame = view.bounds
    }
    
    // Header buttons
    func setUpHeaderButtons() {
//        let titles = ["Following", "For You"]
//        let control = UISegmentedControl(items: titles)
//        control.selectedSegmentIndex = 1
        control.addTarget(self, action: #selector(didChangeSegmentControl(_:)), for: .valueChanged)
        navigationItem.titleView = control
    }
    
    @objc private func didChangeSegmentControl(_ sender: UISegmentedControl) {
        horizontalScrollView.setContentOffset(CGPoint(x: view.width * CGFloat(sender.selectedSegmentIndex),
                                                      y: 0),
                                              animated: true)
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
        
        let vc = PostViewController(model: model)
        vc.delegate = self
        followingYouPagingController.setViewControllers(
            [vc],
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
        
        let vc = PostViewController(model: model)
        vc.delegate = self
        forYouPagingController.setViewControllers(
            [vc],
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
        vc.delegate = self
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
        vc.delegate = self
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

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 || scrollView.contentOffset.x <= (view.width/2) {
            control.selectedSegmentIndex = 0
        }
        else if scrollView.contentOffset.x > (view.width/2) {
            control.selectedSegmentIndex = 1
        }
    }
}

extension HomeViewController: PostViewControllerDelegate {
    func postViewController(_ vc: PostViewController, didTapCommentButtonFor post: PostModel) {
        // to disable horizontal and vertical sliding
        horizontalScrollView.isScrollEnabled = false
        if horizontalScrollView.contentOffset.x == 0 {
            // referring to the following feed
            followingYouPagingController.dataSource = nil
        }
        else {
            forYouPagingController.dataSource = nil
        }
        
        // Presents a comment tray
        let vc = CommentsViewController(post: post)
        vc.delegate = self
        addChild(vc)
        vc.didMove(toParent: self)
        view.addSubview(vc.view)
        let frame: CGRect = CGRect(x: 0, y: view.height, width: view.width, height: view.height * 0.75)
        vc.view.frame = frame
        UIView.animate(withDuration: 0.2) {
            vc.view.frame = CGRect(
                x: 0,
                y: self.view.height - frame.height,
                width: frame.width,
                height: frame.height)
        }
    }
    
    func postViewController(_ vc: PostViewController, didTapProfileButtonFor post: PostModel) {
        let user = post.user
        let vc = ProfileViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: CommentsViewControllerDelegate {
    func didTapCloseForComments(with viewController: CommentsViewController) {
        /* Close comments with animation
           remove comments vc as a child
           Allow horizontal and vertical scroll
        */
        // close comments
        let frame = viewController.view.frame
        UIView.animate(withDuration: 0.2) {
            viewController.view.frame = CGRect(
                x: 0,
                y: self.view.height,
                width: frame.width,
                height: frame.height)
        } completion: { [ weak self ]done in
            if done {
                DispatchQueue.main.async {
                    // Remove comment vc as child
                    viewController.view.removeFromSuperview()
                    viewController.removeFromParent()
                    // allow horizontal and vertical scroll
                    self?.horizontalScrollView.isScrollEnabled = true
                    self?.forYouPagingController.dataSource = self
                    self?.followingYouPagingController.dataSource = self
                }
            }
        }
    }
}
