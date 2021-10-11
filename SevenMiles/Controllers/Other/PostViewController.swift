//
//  PostViewController.swift
//  PostViewController
//
//  Created by SEAN BLAKE on 10/8/21.
//

import UIKit

protocol PostViewControllerDelegate: AnyObject {
    func postViewController(_ vc: PostViewController, didTapCommentButtonFor post: PostModel)
}

class PostViewController: UIViewController {
    
    weak var delegate: PostViewControllerDelegate?
    
    // Used to pass into the controller
    var model: PostModel
    
    // the UIButton properties
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "plus.message.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    
    // Comments label
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "At it again Boy!!!"
        label.font = .systemFont(ofSize: 22)
        label.textColor = .white
        return label
    }()
    
    // HashTag label
    private let hashTagLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = "#Colored Folks #WildinOut #Black #Brown #coloredpeople"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemPink
        return label
    }()
    
    // MARK: - Init
    
    // the constructor "an initializer"
    init(model: PostModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let colors: [UIColor] = [
            .darkGray, .lightGray, .systemGray, .systemGray2, .systemGray3, .systemGray4, .systemGray5, .gray
        ]
        view.backgroundColor = colors.randomElement()
        
        setupButtons()
        // Double top to like
        setUpDoubleTapToLike()
        
        // comments
        view.addSubview(captionLabel)
        view.addSubview(hashTagLabel)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let size: CGFloat = 35
        let yStart: CGFloat = view.height - (size * 4) - 30 - view.safeAreaInsets.bottom - (tabBarController?.tabBar.height ?? 0)
        for (index, button) in [likeButton, commentButton, shareButton].enumerated() {
            button.frame = CGRect(x: view.width-size-10, y: yStart + (CGFloat(index) * 10) + (CGFloat(index) * size), width: size, height: size)
        }
        
        // working with the caption label and size
        captionLabel.sizeToFit()
        let labelSize = captionLabel.sizeThatFits(CGSize(width: view.width - size - 12, height: view.height))
        captionLabel.frame = CGRect(
            x: 5,
            y: view.height - 30 - view.safeAreaInsets.bottom - labelSize.height - (tabBarController?.tabBar.height ?? 0),
            width: view.width - size - 12,
            height: labelSize.height)
        
        // working with the caption label and size
        hashTagLabel.sizeToFit()
        let hashTagSize = hashTagLabel.sizeThatFits(CGSize(width: view.width - size - 5, height: view.height))
        hashTagLabel.frame =
        CGRect(
            x: 5,
            y: view.height - 15 - view.safeAreaInsets.bottom - hashTagSize.height - (tabBarController?.tabBar.height ?? 0),
            width: view.width - size - 12,
            height: hashTagSize.height)
    }
    
    func setupButtons() {
        view.addSubview(likeButton)
        view.addSubview(commentButton)
        view.addSubview(shareButton)
        
        // The Actions
        likeButton.addTarget(self, action: #selector(didTapLikeBtn), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapCommentBtn), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShareBtn), for: .touchUpInside)
    }
    
    // button function
    @objc private func didTapLikeBtn() {
        model.isLikedByCurrentUser = !model.isLikedByCurrentUser
        
        likeButton.tintColor = model.isLikedByCurrentUser ? .systemRed : .white
    }
    
    @objc private func didTapCommentBtn() {
        delegate?.postViewController(self, didTapCommentButtonFor: model)
    }
    
    @objc private func didTapShareBtn() {
        // mockup post
        guard let url = URL(string: "https://www.guhso.com/welcome-to-jamaica") else {
            return
        }
        
        // Presents a share sheet
        let vc = UIActivityViewController(
            activityItems: [url],
            applicationActivities: []
            )
        present(vc, animated: true)
    }
    
    func setUpDoubleTapToLike() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
    }
    
    @objc private func didDoubleTap(_ gesture: UITapGestureRecognizer) {
        if !model.isLikedByCurrentUser {
            model.isLikedByCurrentUser = true
        }
        // finds the location that was touched
        let touchPoint = gesture.location(in: view)
        
        let imageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        imageView.tintColor = .white
        imageView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        imageView.center = touchPoint
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        view.addSubview(imageView)
        
        UIView.animate(withDuration: 0.2) {
            imageView.alpha = 0.5
        } completion: { done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                    UIView.animate(withDuration: 0.3) {
                        imageView.alpha = 0
                    } completion: { done in
                        if done {
                            imageView.removeFromSuperview()
                        }
                    }
                }
            }
        }
    }
}
