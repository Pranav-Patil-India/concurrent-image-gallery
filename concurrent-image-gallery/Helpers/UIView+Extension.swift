//
//  UIView+Extension.swift
//  concurrent-image-gallery
//
//  Created by Pranav Patil on 29/09/25.
//

import UIKit

extension UIView {

    func addSubview(_ view: UIView, pinToParent: Bool, edgeInsets: NSDirectionalEdgeInsets = .zero) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: edgeInsets.leading),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: edgeInsets.bottom),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: edgeInsets.trailing),
            view.topAnchor.constraint(equalTo: topAnchor, constant: edgeInsets.top)
        ])
    }
}
