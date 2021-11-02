//
//  NotificationsPostLikeTableViewCell.swift
//  NotificationsPostLikeTableViewCell
//
//  Created by SEAN BLAKE on 10/31/21.
//

import UIKit

class NotificationsPostLikeTableViewCell: UITableViewCell {
    static let identifier = "NotificationsPostLikeTableViewCell"
    
    /// avatar
    private let postThumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    /// label
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    
    override init (style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(postThumbnailImageView)
        contentView.addSubview(label) 
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postThumbnailImageView.image = nil
        label.text = nil
    }
    
    func configure(with postFileName: String) {
        
        postThumbnailImageView.image = nil
        label.text = nil
    }
}
