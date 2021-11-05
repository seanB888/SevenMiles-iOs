//
//  NotificationsPostCommentTableViewCell.swift
//  NotificationsPostCommentTableViewCell
//
//  Created by SEAN BLAKE on 10/31/21.
//

import UIKit

protocol NotificationsPostCommentTableViewCellDelegate: AnyObject {
    func notificationsPostCommentTableViewCell(_ cell: NotificationsPostCommentTableViewCell,
                                            didTapPostWith identifier: String)
}

class NotificationsPostCommentTableViewCell: UITableViewCell {
    static let identifier = "NotificationsPostCommentTableViewCell"
    
    weak var delegate: NotificationsPostCommentTableViewCellDelegate?
    
    var postID: String?
    
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
    /// Date label
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init (style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(postThumbnailImageView)
        contentView.addSubview(label)
        contentView.addSubview(dateLabel)
        selectionStyle = .none
        postThumbnailImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapPost))
        postThumbnailImageView.addGestureRecognizer(tap)
    }
    
    @objc func didTapPost() {
        guard let id = postID else {
            return
        }
        delegate?.notificationsPostCommentTableViewCell(self, didTapPostWith: id)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        /// User Avatar Image
        postThumbnailImageView.frame = CGRect(
            x: contentView.width - 50,
            y: 3,
            width: 50,
            height: contentView.height - 6
        )
        
        /// label
        label.sizeToFit()
        dateLabel.sizeToFit()
        let labelSize = label.sizeThatFits(CGSize(
            width: contentView.width - 10 - postThumbnailImageView.width - 5,
            height: contentView.height - 40
            )
        )
        
        label.frame = CGRect(
            x: 10,
            y: 0,
            width: labelSize.width,
            height: labelSize.height
        )
        
        dateLabel.frame = CGRect(
            x: 10,
            y: label.bottom + 3,
            width: contentView.width - postThumbnailImageView.width,
            height: 40
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postThumbnailImageView.image = nil
        label.text = nil
        dateLabel.text = nil
    }
    
    func configure(with postFileName: String, model: Notification) {
        postThumbnailImageView.image = UIImage(named: "test")
        label.text = model.text
        dateLabel.text = .date(with: model.date)
        postID = postFileName
    }
}
