//
//  SignUpViewController.swift
//  SignUpViewController
//
//  Created by SEAN BLAKE on 10/8/21.
//
import SafariServices
import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
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
    private let usernameField = AuthField(type: .username)
    private let passwordField = AuthField(type: .password)
    private let firstNameField = AuthField(type: .firstName)
    private let lastNameField = AuthField(type: .lastName)
    private let phoneNumberField = AuthField(type: .phoneNumber)
    
    private let signUpButton = AuthButton(type: .signUp, title: nil)
    private let termsOfAgreement = AuthButton(type: .plain, title: "Terms Of Agreement")
    private let signInToButton = AuthButton(type: .plain, title: "Already Have An Account")
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Sign Up An Account"
        addSubViews()
        configureField()
        configureButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        usernameField.resignFirstResponder()
    }
    
    func configureButtons() {
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        signInToButton.addTarget(self, action: #selector(didTapHaveAccount), for: .touchUpInside)
        termsOfAgreement.addTarget(self, action: #selector(didTapTerms), for: .touchUpInside)
    }
    
    func configureField() {
        emailField.delegate = self
        usernameField.delegate = self
        passwordField.delegate = self
        firstNameField.delegate = self
        lastNameField.delegate = self
        phoneNumberField.delegate = self
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.width, height: 50))
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapkeyboardDone))
        ]
        toolBar.sizeToFit()
        emailField.inputAccessoryView = toolBar
        usernameField.inputAccessoryView = toolBar
        passwordField.inputAccessoryView = toolBar
        firstNameField.inputAccessoryView = toolBar
        lastNameField.inputAccessoryView = toolBar
        phoneNumberField.inputAccessoryView = toolBar
    }
    
    func addSubViews() {
        view.addSubview(logoImageView)
        view.addSubview(emailField)
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(firstNameField)
        view.addSubview(lastNameField)
        view.addSubview(phoneNumberField)
        view.addSubview(signUpButton)
        view.addSubview(signInToButton)
        view.addSubview(termsOfAgreement)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let imageSize: CGFloat = 100
        // logo
        logoImageView.frame = CGRect(x: (view.width - imageSize)/2, y: view.safeAreaInsets.top + 5, width: imageSize, height: imageSize)
        
        emailField.frame = CGRect(x: 20, y: logoImageView.bottom+20, width: view.width-40, height: 55)
        usernameField.frame = CGRect(x: 20, y: emailField.bottom+15, width: view.width-40, height: 55)
        passwordField.frame = CGRect(x: 20, y: usernameField.bottom+15, width: view.width-40, height: 55)
        firstNameField.frame = CGRect(x: 20, y: passwordField.bottom+15, width: view.width-40, height: 55)
        lastNameField.frame = CGRect(x: 20, y: firstNameField.bottom+15, width: view.width-40, height: 55)
        phoneNumberField.frame = CGRect(x: 20, y: lastNameField.bottom+15, width: view.width-40, height: 55)
        
        
        signUpButton.frame = CGRect(x: 20, y: phoneNumberField.bottom+20, width: view.width-40, height: 55)
        signInToButton.frame = CGRect(x: 20, y: signUpButton.bottom+20, width: view.width-40, height: 55)
        termsOfAgreement.frame = CGRect(x: 20, y: signInToButton.bottom+20, width: view.width-40, height: 55)
        
    }
    
    // Actions
    @objc func didTapSignUp() {
        didTapkeyboardDone()
        
        guard let email = emailField.text,
              let password = passwordField.text,
              let username = usernameField.text,
              let firstName = firstNameField.text,
              let lastName = lastNameField.text,
              let phoneNumber = phoneNumberField.text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !username.trimmingCharacters(in: .whitespaces).isEmpty,
              !firstName.trimmingCharacters(in: .whitespaces).isEmpty,
              !lastName.trimmingCharacters(in: .whitespaces).isEmpty,
              !phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 8,
              !username.contains(" "),
              !username.contains(".") else {
                  let alert = UIAlertController(title: "COME ON YO!", message: " You have to fill out the form. If you dont want to fill out the form use one of the social links below.", preferredStyle: .alert)
                  alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                  present(alert, animated: true)
                  return
              }
        AuthManager.shared.signUp(with: username, emailAddress: email, password: password, firstName: firstName, lastName: lastName, phoneNumnber: phoneNumber) { [ weak self ] success in
            DispatchQueue.main.async {
                if success {
                    print("Your are signed up!")
                }
                else {
                    let alert = UIAlertController(
                        title: "Dat Never Work!",
                        message: " Something nuh right with wha happen awhile ago.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self?.present(alert, animated: true)
                }
            }
        }
        
    }
    
    
    @objc func didTapHaveAccount() {
        didTapkeyboardDone()
        let vc = SignInViewController()
        vc.title = "Sign In To Your Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapTerms() {
        didTapkeyboardDone()
        guard let url = URL(string: "https://guhso.com") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @objc func didTapkeyboardDone() {
        emailField.resignFirstResponder()
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        phoneNumberField.resignFirstResponder()
    }
    
}
