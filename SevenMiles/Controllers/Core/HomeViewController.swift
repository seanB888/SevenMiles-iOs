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
    private let horizontalScrollView: UIScrollView = {
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

    // MARK: -Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(horizontalScrollView)
        setUpFeed()
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
        let vc = UIViewController()
        vc.view.backgroundColor = .orange
        
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
        let forYouPagingController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .vertical,
            options: [:]
        )
        
        let vc = UIViewController()
        vc.view.backgroundColor = .orange
        
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
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = UIViewController()
        vc.view.backgroundColor = [UIColor.red, UIColor.gray, UIColor.green].randomElement()
        return vc
    }
}
