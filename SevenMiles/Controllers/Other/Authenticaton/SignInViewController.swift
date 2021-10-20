//
//  SigninViewController.swift
//  SigninViewController
//
//  Created by SEAN BLAKE on 10/8/21.
//

import UIKit

class SignInViewController: UIViewController, UITextViewDelegate  {
    
    public var completion: (() -> Void)?
    
    // MARK: - Logo
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
    private let emailField = AuthField(type: .email)
    private let passwordField = AuthField(type: .password)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Sign In"
        view.addSubview(logoImageView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

}
