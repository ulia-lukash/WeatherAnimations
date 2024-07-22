//
//  CollectionCell.swift
//  WeatherAnimations
//
//  Created by Uliana Lukash on 21.07.2024.
//

import Foundation
import UIKit

final class CollectionCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: Private Properties
    
    lazy private var imageView = UIImageView()
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.tintColor = .white
        configCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Methods
    
    func configure(_ item: WeatherInst) {
        let imageName = item.imageName
        let image = UIImage(systemName: imageName)
        imageView.image = image
    }
    
    // MARK: Private Methods
    
    private func configCellLayout() {
        [imageView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
