//
//  ExploreBannerCollectionViewCell.swift
//  ExploreBannerCollectionViewCell
//
//  Created by SEAN BLAKE on 10/15/21.
//

import UIKit

class ExploreBannerCollectionViewCell: UICollectionViewCell {
    // the identifier
    static let identifier = "ExploreBannerCollectionViewCell"

    // the variable for the image
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    // the variable for the label that sits on image
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        return label
    }()

    // create a frame for the initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.addSubview(label)
        contentView.addSubview(imageView)
        // contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        label.sizeToFit()
        imageView.frame = contentView.bounds
        label.frame = CGRect(x: 10, y: contentView.height - 5 - label.height, width: label.width, height: label.height)
        contentView.bringSubviewToFront(label)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        label.text = nil
    }

    func configure(with viewModel: ExploreBannerViewModel) {
        imageView.image = viewModel.image
        label.text = viewModel.title
    }
}
