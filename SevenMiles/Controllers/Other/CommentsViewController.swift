//
//  CommentsViewController.swift
//  CommentsViewController
//
//  Created by SEAN BLAKE on 10/11/21.
//

import UIKit

protocol CommentsViewControllerDelegate: AnyObject {
    func didTapCloseForComments(with viewController: CommentsViewController)
}

class CommentsViewController: UIViewController {
    
    private let post: PostModel
    
    weak var delegate: CommentsViewControllerDelegate?
    
    private var comments = [PostComment]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            CommentTableViewCell.self,
            forCellReuseIdentifier: CommentTableViewCell.indentifier
        )
        return tableView
    }()
    
    // The close button
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "x.circle"), for: .normal)
        button.tintColor = .systemPink
        
        return button
    }()
    
    init(post: PostModel) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        view.backgroundColor = .white
        
        // Mock datd here
        fetchPostComments()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        closeButton.frame = CGRect(x: view.width - 40, y: 10, width: 30, height: 30)
        tableView.frame = CGRect(x: 0, y: closeButton.bottom, width: view.width, height: view.width - closeButton.bottom)
    }
    
    @objc private func didTapClose() {
        delegate?.didTapCloseForComments(with: self)
    }
    
    func fetchPostComments() {
        // DatabaseManager.shared.fetchComments
        self.comments = PostComment.mockComments()
    }
    
}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = comments[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CommentTableViewCell.indentifier,
            for: indexPath
        ) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: comment)
        return cell
    }
    
    // The height of the cells in the tableView
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // make row not selectable
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
