//
//  SigninViewController.swift
//  SigninViewController
//
//  Created by SEAN BLAKE on 10/8/21.
//

import SafariServices
import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {
    
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
    
    private let signInButton = AuthButton(type: .signIn, title: nil)
    private let signUpButton = AuthButton(type: .signUp, title: "New User? Create Account")
    private let forgetPassword = AuthButton(type: .plain, title: "Forgot Your Password")
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Sign In"
        addSubViews()
        configureField()
        configureButtons()
    }
    
    func configureButtons() {
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        forgetPassword.addTarget(self, action: #selector(didTapForgetPassword), for: .touchUpInside)
    }
    
    func configureField() {
        emailField.delegate = self
        passwordField.delegate = self
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.width, height: 50))
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            // UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapkeyboardDone))
        ]
        toolBar.sizeToFit()
        emailField.inputAccessoryView = toolBar
        passwordField.inputAccessoryView = toolBar
    }
    
    func addSubViews() {
        view.addSubview(logoImageView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        view.addSubview(forgetPassword)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let imageSize: CGFloat = 100
        // logo
        logoImageView.frame = CGRect(x: (view.width - imageSize)/2, y: view.safeAreaInsets.top + 5, width: imageSize, height: imageSize)
        
        emailField.frame = CGRect(x: 20, y: logoImageView.bottom+20, width: view.width-40, height: 55)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom+15, width: view.width-40, height: 55)
        signInButton.frame = CGRect(x: 20, y: passwordField.bottom+20, width: view.width-40, height: 55)
        signUpButton.frame = CGRect(x: 20, y: signInButton.bottom+20, width: view.width-40, height: 55)
        forgetPassword.frame = CGRect(x: 20, y: signUpButton.bottom+20, width: view.width-40, height: 55)
        
    }
    
    //MARK: - Actions
    @objc func didTapSignIn() {
        didTapkeyboardDone()
        
        guard let email = emailField.text,
              let password = passwordField.text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 8 else {
                  
                  let alert = UIAlertController(title: "Yu messup, check dat again", message: "Di Password or the Username wrong. Fix up dat and try again!", preferredStyle: .alert)
                  alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                  present(alert, animated: true)
                  return
              }
        
        AuthManager.shared.signIn(with: email, password: password) { [weak self] result in
            DispatchQueue.main.async{
                switch result {
                case .success:
                    HapticsManager.shared.vibrate(for: .success)
                    self?.dismiss(animated: true, completion: nil)
                   
                case .failure:
                    HapticsManager.shared.vibrate(for: .error)
                    let alert = UIAlertController(title: "Yu messup, check dat again", message: "Yu need fi check the email or password.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    @objc func didTapSignUp() {
        didTapkeyboardDone()
        let vc = SignUpViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapForgetPassword() {
        didTapkeyboardDone()
        guard let url = URL(string: "https://guhso.com") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc func didTapkeyboardDone() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
}
