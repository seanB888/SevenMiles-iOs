//
//  PostViewController.swift
//  PostViewController
//
//  Created by SEAN BLAKE on 10/8/21.
//
import AVFoundation
import UIKit

protocol PostViewControllerDelegate: AnyObject {
    // PostViewController
    func postViewController(_ vc: PostViewController, didTapCommentButtonFor post: PostModel)
    // ProfileViewController
    func postViewController(_ vc: PostViewController, didTapProfileButtonFor post: PostModel)
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
        button.setBackgroundImage(UIImage(systemName: "message.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()

    private let shareButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "arrowshape.turn.up.forward.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        return button
    }()
    // The Profile Button
    private let profileButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "test"), for: .normal)
        button.layer.masksToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .white
        return button
    }()

    // Comments label
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "2021 Why We Ride"
        label.font = .systemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()

    // HashTag label
    private let hashTagLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = "#bikelife #WildinOut #Black #Brown #coloredpeople"
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemOrange
        return label
    }()

    // The video Player
    var player: AVPlayer?

    private var playerDidFinishObserveer: NSObjectProtocol?

    private let videoView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.clipsToBounds = true

        return view
    }()

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.tintColor = .systemOrange
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        return spinner
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
        view.addSubview(videoView)
        configureVideo() /// For the videoPlayer
        view.backgroundColor = .systemGray2

        setupButtons()
        // Double top to like
        setUpDoubleTapToLike()
        // comments
        view.addSubview(captionLabel)
        view.addSubview(hashTagLabel)
        view.addSubview(profileButton)
        profileButton.addTarget(self, action: #selector(didTapProfileButton), for: .touchUpInside)

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        videoView.frame = view.bounds
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = videoView.center
        let size: CGFloat = 40
        let yStart: CGFloat = view.height - (size * 4.0) - 30 - view.safeAreaInsets.bottom
        for (index, button) in [likeButton, commentButton, shareButton].enumerated() {
            button.frame = CGRect(x: view.width-size-10, y: yStart + (CGFloat(index) * 10) + (CGFloat(index) * size), width: size, height: size)
        }

        // working with the caption label and size
        captionLabel.sizeToFit()
        let labelSize = captionLabel.sizeThatFits(CGSize(width: view.width - size - 12, height: view.height))
        captionLabel.frame = CGRect(
            x: 5,
            y: view.height - 30 - view.safeAreaInsets.bottom - labelSize.height,
            width: view.width - size - 12,
            height: labelSize.height)

        // working with the caption label and size
        hashTagLabel.sizeToFit()
        let hashTagSize = hashTagLabel.sizeThatFits(CGSize(width: view.width - size - 5, height: view.height))
        hashTagLabel.frame =
        CGRect(
            x: 5,
            y: view.height - 15 - view.safeAreaInsets.bottom - hashTagSize.height,
            width: view.width - size - 12,
            height: hashTagSize.height
        )

        profileButton.frame = CGRect(
            x: likeButton.left,
            y: likeButton.top - 10 - size,
            width: size,
            height: size
        )
        profileButton.layer.cornerRadius = size / 2
    }

    // MARK: - Configure Video

    // function for the videoPlayer
    private func configureVideo() {
        StorageManager.shared.getDownloadURL(for: model) { [weak self] result in
            DispatchQueue.main.async {
                // To locate the video
                guard let path = Bundle.main.path(forResource: "bikelife", ofType: ".mp4") else {
                    return
                }
                let url = URL(fileURLWithPath: path)
                self?.player = AVPlayer(url: url)
                
                guard let strongSelf = self else {
                    return
                }
                strongSelf.spinner.stopAnimating()
                strongSelf.spinner.removeFromSuperview()
                switch result {
                case.success(let url):
                    strongSelf.player = AVPlayer(url: url)
                    // helps to add to a subView
                    let playerLayer = AVPlayerLayer(player: strongSelf.player)
                    playerLayer.frame = strongSelf.view.bounds
                    playerLayer.videoGravity = .resizeAspectFill
                    strongSelf.videoView.layer.addSublayer(playerLayer)
                    strongSelf.player?.volume = 0.3
                    strongSelf.player?.play()
                case.failure:
                    break
                }
            }
        }

        let url = URL(fileURLWithPath: model.videoChildPath)
        print("video url: \(url)")

        guard let player = player else {
            return
        }

        playerDidFinishObserveer =  NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
            ) { _ in
                player.seek(to: .zero)
                player.play()
            }
    }

    @objc func didTapProfileButton() {
        delegate?.postViewController(self, didTapProfileButtonFor: model)
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

        likeButton.tintColor = model.isLikedByCurrentUser ? .systemOrange : .white
    }

    @objc private func didTapCommentBtn() {
        delegate?.postViewController(self, didTapCommentButtonFor: model)
    }

    @objc private func didTapShareBtn() {
        // mockup post
        guard let url = URL(string: "https://www.guhso.com") else {
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

            // Allows to select the heart like button as well
            likeButton.tintColor = model.isLikedByCurrentUser ? .systemOrange : .white
        }
        HapticsManager.shared.vibrateForSelection()
        // finds the location that was touched
        let touchPoint = gesture.location(in: view)

        let imageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        imageView.tintColor = .systemOrange
        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 180)
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
