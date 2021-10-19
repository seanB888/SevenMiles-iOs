//
//  SigninViewController.swift
//  SigninViewController
//
//  Created by SEAN BLAKE on 10/8/21.
//

import UIKit

class SignInViewController: UIViewController {
    
    public var completion: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Sign In"
    }

}
