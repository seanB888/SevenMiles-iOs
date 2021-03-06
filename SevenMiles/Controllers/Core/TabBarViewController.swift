//
//  TabBarViewController.swift
//  TabBarViewController
//
//  Created by SEAN BLAKE on 10/8/21.
//

import UIKit

class TabBarViewController: UITabBarController {

    private var signInPresented  = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpController()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !signInPresented {
            presentSignInIfNeeded()
        }
    }

    private func presentSignInIfNeeded() {
        // Checking if the a user is not signed in
        if !AuthManager.shared.isSignedIn {
            signInPresented = true
            let vc = SignInViewController()
            vc.completion = { [weak self ] in
                self?.signInPresented = false
            }
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            present(navVC, animated: false, completion: nil)
        }
    }

    private func setUpController() {
        let home = HomeViewController()
        let explore = ExploreViewController()
        let camera = CameraViewController()
        let notification = NotificationViewController()
        var urlString: String?
        if let cachedUrlString = UserDefaults.standard.string(forKey: "profile_picture_url") {
            urlString = cachedUrlString
        }
        let profile = ProfileViewController(
            user: User(
                username: UserDefaults.standard.string(forKey: "username")?.uppercased() ?? "Me",
                profilePictureURL: URL(string: urlString ?? ""),
                indentifier: UserDefaults.standard.string(forKey: "username")?.lowercased() ?? ""
            )
        )

        // home.title = "Home"
        // explore.title = "Explore"
        camera.title = "Create"
        notification.title = "DM'S"
        profile.title = "Profile"

        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: explore)
        let nav3 = UINavigationController(rootViewController: notification)
        let nav4 = UINavigationController(rootViewController: profile)
        let cameraNav = UINavigationController(rootViewController: camera)

        // Hides NavBar on camera view
        cameraNav.navigationBar.backgroundColor = .clear
        cameraNav.navigationBar.setBackgroundImage(UIImage(), for: .default)
        cameraNav.navigationBar.shadowImage = UIImage()
        cameraNav.navigationBar.tintColor = .systemOrange /// <-- MAKES TEXT ON CAPTIONVIEW WHITE

        nav3.navigationBar.tintColor = .label

        // making the image transparent
        nav1.navigationBar.backgroundColor = .clear
        nav1.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav1.navigationBar.shadowImage = UIImage()

        nav1.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "magnifyingglass"), tag: 2)
        camera.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "camera.circle.fill"), tag: 3)
        nav3.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "mail"), tag: 4)
        nav4.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), tag: 5)

        /// To get a minimal looking backButton
        if #available(iOS 14.0, *) {
            nav1.navigationItem.backButtonDisplayMode = .minimal
            nav2.navigationItem.backButtonDisplayMode = .minimal
            nav3.navigationItem.backButtonDisplayMode = .minimal
            nav4.navigationItem.backButtonDisplayMode = .minimal
            cameraNav.navigationItem.backButtonDisplayMode = .minimal
        }

        nav4.navigationBar.tintColor = .systemOrange

        setViewControllers([nav1, nav2, cameraNav, nav3, nav4], animated: false)
    }
}
