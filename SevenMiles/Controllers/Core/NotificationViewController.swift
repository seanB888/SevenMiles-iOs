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
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    // Spinner
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .systemOrange
        spinner.startAnimating()
        return spinner
    }()
    
    var notifications = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(noNotificationLabel)
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        view.addSubview(spinner)
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchNotification()
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
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Wha Gwaan"
        return cell
    }
}
