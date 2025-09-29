//
//  ImageCell.swift
//  concurrent-image-gallery
//
//  Created by Pranav Patil on 29/09/25.
//

import UIKit

class ImageCell: UICollectionViewCell {

    // MARK: Properties

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    // MARK: Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView, pinToParent: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public methods

    func configure(with image: UIImage?) {
        imageView.image = image
    }
}
