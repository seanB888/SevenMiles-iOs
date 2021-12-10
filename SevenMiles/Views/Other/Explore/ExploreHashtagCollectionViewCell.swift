//
//  ExploreHashtagCollectionViewCell.swift
//  ExploreHashtagCollectionViewCell
//
//  Created by SEAN BLAKE on 10/15/21.
//

import UIKit

class ExploreHashtagCollectionViewCell: UICollectionViewCell {
    // the identifier
    static let identifier = "ExploreHashtagCollectionViewCell"

    // icon for the hashtag
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    // label for the hashtag
    private let hashtagLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .systemOrange
        return label
    }()

    // create a frame for the initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.addSubview(iconImageView)
        contentView.addSubview(hashtagLabel)
        // contentView.backgroundColor = .systemGray5
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let iconSize: CGFloat = contentView.height/2
        iconImageView.frame = CGRect(x: 10, y: (contentView.height - iconSize) / 2, width: iconSize, height: iconSize).integral

        hashtagLabel.sizeToFit()
        hashtagLabel.frame = CGRect(
            x: iconImageView.right + 15,
            y: 0,
            width: contentView.width - iconImageView.right - 10,
            height: contentView.height
        )
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        hashtagLabel.text = nil
    }

    func configure(with viewModel: ExploreHashtagViewModel) {
        iconImageView.image = viewModel.icon
        hashtagLabel.text = viewModel.text
    }

}
