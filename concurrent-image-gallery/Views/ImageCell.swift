//
//  ImageCell.swift
//  concurrent-image-gallery
//
//  Created by Pranav Patil on 29/09/25.
//

import UIKit

class ImageCell: UICollectionViewCell {

    // MARK: Constants
    
    private static let placeholderImageName = "Placeholder"

    // MARK: Properties

    private var currentURL: URL?

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: Self.placeholderImageName))
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

    func configure(with url: URL) {
        currentURL = url
        ImageLoader.shared.fetchImage(for: url, completion: { [weak self] result in
            DispatchQueue.main.async {
                guard let self, self.currentURL == url else { return }
                switch result {
                    case .success(let image):
                        self.imageView.image = image
                    case .failure(let error):
                        self.imageView.image = UIImage(named: Self.placeholderImageName)
                }
            }
        })
    }
}
