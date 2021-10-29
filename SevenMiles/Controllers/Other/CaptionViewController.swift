//
//  CaptionViewController.swift
//  CaptionViewController
//
//  Created by SEAN BLAKE on 10/25/21.
//

import ProgressHUD
import UIKit

class CaptionViewController: UIViewController {
    
    let videoURL: URL
    
    init(videoURL: URL) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Caption"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didTapPost))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc private func didTapPost() {
         // Generate a unique video name base on the id
        let newVideoName = StorageManager.shared.generateVideoName()
        
        ProgressHUD.show("Di video a post. Hold tight!")/// <--- PROGRESSHUD CALL
        
        // Upload the video
        StorageManager.shared.uploadVideoURL(from:  videoURL, fileName: newVideoName) { [ weak self ] success in
            DispatchQueue.main.async {
                if success {
                    // Update the database
                    DatabaseManager.shared.insertPost(fileName: newVideoName) { databaseUpdated in
                        if databaseUpdated {
                            ProgressHUD.dismiss()/// <--- PROGRESSHUD CALL
                            HapticsManager.shared.vibrate(for: .success)/// <--- HAPTICSMANAGER CALL
                            /// REST CAMERA AND SWITCH TO FEED
                            self?.navigationController?.popToRootViewController(animated: true)
                            self?.tabBarController?.selectedIndex = 0
                            self?.tabBarController?.tabBar.isHidden = false
                            
                        }
                        else {
                            HapticsManager.shared.vibrate(for: .error)/// <--- HAPTICSMANAGER CALL
                            ProgressHUD.dismiss()/// <--- PROGRESSHUD CALL
                            /// ERROR
                            let alert = UIAlertController(title: "BLOW WOW", message: "Wha gwaan yah so. We can't upload that. Try dat again, fix up dat.", preferredStyle: .alert )
                            alert.addAction(UIAlertAction(title: "Dimiss", style: .cancel, handler: nil ))
                            self?.present(alert, animated: true)
                        }
                    }
                    /// Reset camera and switch to feed
                }
                else {
                    HapticsManager.shared.vibrate(for: .error) /// <--- HAPTICSMANAGER CALL
                    ProgressHUD.dismiss()/// <--- PROGRESSHUD CALL
                    let alert = UIAlertController(title: "BLOW WOW", message: "Wha gwaan yah so. We can't upload that. Try dat again, fix up dat.", preferredStyle: .alert )
                    alert.addAction(UIAlertAction(title: "Dimiss", style: .cancel, handler: nil ))
                    self?.present(alert, animated: true)
                }
            }
        }
        
    }
}
 
