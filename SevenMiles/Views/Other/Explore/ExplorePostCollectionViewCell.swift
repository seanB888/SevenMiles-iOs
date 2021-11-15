//
//  ExplorePostCollectionViewCell.swift
//  ExplorePostCollectionViewCell
//
//  Created by SEAN BLAKE on 10/15/21.
//

import UIKit

class ExplorePostCollectionViewCell: UICollectionViewCell {
    // the identifier
    static let identifier = "ExplorePostCollectionViewCell"
    
    // variable for the image
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // Caption Label
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .systemOrange
        return label
    }()
    
    // create a frame for the initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.addSubview(captionLabel)
        contentView.addSubview(thumbnailImageView)
        contentView.layer.cornerRadius = 3
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        captionLabel.sizeToFit()
        thumbnailImageView.frame = contentView.bounds
        captionLabel.frame = CGRect(x: 10, y: contentView.height - 5 - captionLabel.height,
                                    width: captionLabel.width, height: captionLabel.height)
        contentView.bringSubviewToFront(captionLabel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        captionLabel.text = nil
    }
    
    func configure(with viewModel: ExplorePostsViewModel) {
        captionLabel.text = viewModel.caption
        //print(viewModel.thumbnailImage)
        thumbnailImageView.image = viewModel.thumbnailImage
    }
}
