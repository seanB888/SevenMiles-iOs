//
//  ProfileViewController.swift
//  ProfileViewController
//
//  Created by SEAN BLAKE on 10/8/21.
//

import UIKit

class ProfileViewController: UIViewController {
    // brings in user info from the database
    let user: User
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = user.username.uppercased()
        view.backgroundColor = .systemBackground
    }
}
