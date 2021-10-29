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
    
    private let captionTextView: UITextView = {
        let textView = UITextView()
        textView.contentInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.cornerRadius = 8
        textView.layer.masksToBounds = true
        return textView
    }()
    
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
        view.addSubview(captionTextView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        captionTextView.frame = CGRect(x: 5, y: view.safeAreaInsets.top+5, width: view.width, height: 150).integral
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captionTextView.becomeFirstResponder()
    }
    
    @objc private func didTapPost() {
        captionTextView.resignFirstResponder()
        let caption = captionTextView.text ?? ""
         // Generate a unique video name base on the id
        let newVideoName = StorageManager.shared.generateVideoName()
        
        ProgressHUD.show("Di video a post. Hold tight!")/// <--- PROGRESSHUD CALLf
        
        // Upload the video
        StorageManager.shared.uploadVideoURL(from:  videoURL, fileName: newVideoName) { [ weak self ] success in
            DispatchQueue.main.async {
                if success {
                    // Update the database
                    DatabaseManager.shared.insertPost(fileName: newVideoName, caption: caption) { databaseUpdated in
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
 
