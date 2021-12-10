//
//  EditProfileViewController.swift
//  SevenMiles
//
//  Created by SEAN BLAKE on 12/6/21.
//

import UIKit

class EditProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Profile"
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                           target: self,
                                                           action: #selector(didTapClose))
    }

    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }

}
