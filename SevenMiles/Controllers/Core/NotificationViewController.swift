//
//  NotificationViewController.swift
//  NotificationViewController
//
//  Created by SEAN BLAKE on 10/8/21.
//

import UIKit

class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let noNotificationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.text = "There are no notifications"
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    /// TABLEVIEW TO SHOW LIST OF NOTIFICATION
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "cell"
        )
        table.register(
            NotificationsUserFollowTableViewCell.self,
            forCellReuseIdentifier: NotificationsUserFollowTableViewCell.identifier
        )
        table.register(
            NotificationsPostCommentTableViewCell.self,
            forCellReuseIdentifier: NotificationsPostCommentTableViewCell.identifier
        )
        table.register(
            NotificationsPostLikeTableViewCell.self,
            forCellReuseIdentifier: NotificationsPostLikeTableViewCell.identifier
        )
        return table
    }()
    
    // Spinner
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .systemOrange
        spinner.startAnimating()
        return spinner
    }()
    
    var notifications = [Notification]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(noNotificationLabel)
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        view.addSubview(spinner)
        tableView.delegate = self
        tableView.dataSource = self
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(didPullToRefresh(_:)), for: .valueChanged)
        tableView.refreshControl = control
        
        fetchNotification()
    }
    
    @objc func didPullToRefresh(_ sender: UIRefreshControl) {
        sender.beginRefreshing()
        /// This is the refresher for the Notification view
        DatabaseManager.shared.getNotifications { [weak self] notifications in
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                self?.notifications = notifications
                self?.tableView.reloadData()
                sender.endRefreshing()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noNotificationLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        noNotificationLabel.center = view.center
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
    }
    
    // to fecth notification
    func fetchNotification() {
        DatabaseManager.shared.getNotifications { [weak self] notifications in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                self?.spinner.isHidden = true
                self?.notifications = notifications
                self?.updateUI()
            }
        }
    }
    
    func updateUI() {
        if notifications.isEmpty {
            noNotificationLabel.isHidden = false
            tableView.isHidden = true
        } else {
            noNotificationLabel.isHidden = true
            tableView.isHidden = false
        }
        tableView.reloadData()
    }
    
    // Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        // return notifications.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = notifications[indexPath.row]
        
        switch model.type {
        case .postLike(let postName):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NotificationsPostLikeTableViewCell.identifier,
                for: indexPath
            ) as? NotificationsPostLikeTableViewCell else {
                return tableView.dequeueReusableCell(
                    withIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.delegate = self
            cell.configure(with: postName, model: model)
            return cell
        case .userFollow(let username):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NotificationsUserFollowTableViewCell.identifier,
                for: indexPath
            ) as? NotificationsUserFollowTableViewCell else {
                return tableView.dequeueReusableCell(
                    withIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.delegate = self
            cell.configure(with: username, model: model)
            return cell
        case .postComment(let postName):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NotificationsPostCommentTableViewCell.identifier,
                for: indexPath
            ) as? NotificationsPostCommentTableViewCell else {
                return tableView.dequeueReusableCell(
                    withIdentifier: "cell",
                    for: indexPath
                )
            }
            cell.delegate = self
            cell.configure(with: postName, model: model)
            return cell
        }
    }
    
    /// For hidding Row
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        let model =  notifications[indexPath.row]
        model.isHidden = true
        
        DatabaseManager.shared.markNotificationAsHidden(notificationID: model.identifier) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.notifications = self?.notifications.filter({$0.isHidden == false}) ?? []
                    
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .none)
                    tableView.endUpdates()
                }
            }
        }
    }
    
    /// Fixed height for the Rows
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension NotificationViewController: NotificationsUserFollowTableViewCellDelegate {
    func notificationsUserFollowTableViewCell(_ cell: NotificationsUserFollowTableViewCell, didTapFollowFor username: String) {
        DatabaseManager.shared.follow(username: username) { success in
            if !success {
                print("Something went wrong mi idreen")
            }
        }
    }
    
    func notificationsUserFollowTableViewCell(_ cell: NotificationsUserFollowTableViewCell, didTapAvatarFor username: String) {
        let vc = ProfileViewController(user: User(
            username: username,
            profilePictureURL: nil,
            indentifier: "123"))
        vc.title = username.uppercased()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension NotificationViewController: NotificationsPostLikeTableViewCellDelegate {
    func notificationsPostLikeTableViewCell(_ cell: NotificationsPostLikeTableViewCell, didTapPostWith identifier: String) {
        openPost(with: identifier)
    }
}

extension NotificationViewController: NotificationsPostCommentTableViewCellDelegate {
    func notificationsPostCommentTableViewCell(_ cell: NotificationsPostCommentTableViewCell, didTapPostWith identifier: String) {
        openPost(with: identifier)
    }
}

extension NotificationViewController {
    func openPost(with identifier: String) {
        ///resolve post model from database
        let vc = PostViewController(model: PostModel(identifier: identifier, user: User(
            username: "SeanB",
            profilePictureURL: nil,
            indentifier: UUID().uuidString
        )))
        vc.title = "Video"
        navigationController?.pushViewController(vc, animated: true)
    }
}
