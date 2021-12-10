//
//  CommentTableViewController.swift
//  CommentTableViewController
//
//  Created by SEAN BLAKE on 10/11/21.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    // the cell indentifier
    static let indentifier = "CommentTableViewCell"
    
    private let avatarImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.clipsToBounds = true
        imageview.layer.masksToBounds = true
        return imageview
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        backgroundColor = .secondarySystemBackground
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(avatarImageView)
        contentView.addSubview(commentLabel)
        contentView.addSubview(dateLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        commentLabel.sizeToFit()
        dateLabel.sizeToFit()
        
        // Assign frames
        let imageSize: CGFloat = 44
        // image section
        avatarImageView.frame = CGRect(
            x: 10,
            y: 5,
            width: imageSize,
            height: imageSize
        )
        
        // comment section
        let commentLableHeight = min(contentView.height - dateLabel.top, commentLabel.height)
        commentLabel.frame = CGRect(
            x: avatarImageView.right+10,
            y: 5,
            width: contentView.width - avatarImageView.right - 10,
            height: commentLableHeight
        )
        
        // date section
        dateLabel.frame = CGRect(
            x: avatarImageView.right+10,
            y: commentLabel.bottom,
            width: dateLabel.width,
            height: dateLabel.height
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // have these fields reset
        dateLabel.text = nil
        commentLabel.text = nil
        avatarImageView.image = nil
    }
    
    public func configure(with model: PostComment) {
        commentLabel.text = model.text
        dateLabel.text = .date(with: model.date)
        if let url = model.user.profilePictureURL {
            print(url)
        }
        else {
            avatarImageView.image = UIImage(systemName: "person.circle")
        }
    }
}
