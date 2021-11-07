//
//  ProfileHeaderCollectionReusableView.swift
//  ProfileHeaderCollectionReusableView
//
//  Created by SEAN BLAKE on 11/7/21.
//

import UIKit


protocol ProfileHeaderCollectionReusableViewDelegate: AnyObject {
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView,
                                             didTapPrimaryButtonWith viewModel: String)
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView,
                                             didTapFollowersButtonWith viewModel: String)
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView,
                                             didTapFollowingButtonWith viewModel: String)
}

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "ProfileHeaderCollectionReusableView"
    
    weak var delegate: ProfileHeaderCollectionReusableViewDelegate?
    
    /// ViewModel
    var viewModel: ProfileHeaderViewModel?
    
    /// Subviews
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    /// Follow or Edit Profile
    /// Primary Button
    private let primaryButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        return button
    }()
    /// Follow Button
    private let followersButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.setTitle("Followers", for: .normal)
        return button
    }()
    /// Edit Button
    private let followingButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.setTitle("Following", for: .normal)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .systemBackground
        /// add subviews
        addButtonSubviews()
        configureButtons()
    }
    
    /// subview buttons
    func addButtonSubviews() {
        addSubview(avatarImageView)
        addSubview(primaryButton)
        addSubview(followersButton)
        addSubview(followingButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    // MARK: - Configure the buttons
    func configureButtons() {
        primaryButton.addTarget(self, action: #selector(didTapPrimaryButton), for: .touchUpInside)
        followersButton.addTarget(self, action: #selector(didTapFollowersButton), for: .touchUpInside)
        followingButton.addTarget(self, action: #selector(didTapFollowingButton), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let avatarSize: CGFloat = 130
        avatarImageView.frame = CGRect(x: (width - avatarSize)/2, y: 5, width: avatarSize, height: avatarSize)
        avatarImageView.layer.cornerRadius = avatarImageView.height/2
        
    }
    
    ///Actions
    @objc func didTapPrimaryButton() {
        delegate?.profileHeaderCollectionReusableView(self, didTapPrimaryButtonWith: "")
    }
    
    @objc func didTapFollowersButton() {
        delegate?.profileHeaderCollectionReusableView(self, didTapFollowersButtonWith: "")
    }
    
    @objc func didTapFollowingButton() {
        delegate?.profileHeaderCollectionReusableView(self, didTapFollowersButtonWith: "")
    }
    
    func configure(with viewModel: ProfileHeaderViewModel) {
        self.viewModel = viewModel
        /// Setup the header
    }
}
