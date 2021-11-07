//
//  ProfileHeaderCollectionReusableView.swift
//  ProfileHeaderCollectionReusableView
//
//  Created by SEAN BLAKE on 11/7/21.
//

import UIKit

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "ProfileHeaderCollectionReusableView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .systemBackground
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
