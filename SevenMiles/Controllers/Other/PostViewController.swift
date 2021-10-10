//
//  PostViewController.swift
//  PostViewController
//
//  Created by SEAN BLAKE on 10/8/21.
//

import UIKit

class PostViewController: UIViewController {
    // Used to pass into the controller
    let model: PostModel
    
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
            .red, .green, .yellow, .orange, .blue, .purple, .systemPink, .white
        ]
        view.backgroundColor = colors.randomElement()
        
    }
}
