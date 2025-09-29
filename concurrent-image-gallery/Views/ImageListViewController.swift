//
//  ImageListViewController.swift
//  concurrent-image-gallery
//
//  Created by Pranav Patil on 29/09/25.
//

import UIKit

class ImageListViewController: UIViewController {

    // MARK: Constants

    private static let imageCellReuseID = "imageCellReuseID"
    private static let placeholderImageName = "Placeholder"
    private static let itemsPerRow: CGFloat = 3

    // MARK: Dummy data

    // TODO: Remove when appropriate logic is added.
    private static let collectionViewColor = UIColor.yellow
    private static let vcViewColor = UIColor.red
    private static let numberOfItemsInSection = 44

    // MARK: Properties

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: Self.imageCellReuseID)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = Self.collectionViewColor
        return collectionView
    }()

    // MARK: Overriden methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Self.vcViewColor
        view.addSubview(collectionView, pinToParent: true)
    }
}

// MARK: UICollectionViewDataSource

extension ImageListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Self.numberOfItemsInSection
    }

    func collectionView(_ collectionView: UICollectionView, 
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Self.imageCellReuseID,
            for: indexPath) as? ImageCell else {
            return UICollectionViewCell()
        }

        cell.configure(with: UIImage(named: Self.placeholderImageName))
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension ImageListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            preconditionFailure("Invalid collectionViewLayout")
        }

        let horizontalPadding = flowLayout.minimumInteritemSpacing * (Self.itemsPerRow-1) 
            + flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
        let dimension = (collectionView.bounds.size.width - horizontalPadding)/Self.itemsPerRow
        return CGSize(width: dimension, height: dimension)
    }
}
